# Smart Access Control System — FPGA RTL Design Report

**Target Board:** AT-STLN-ARTIX7-001 (ANM-PRD-2025-005)
**System Clock:** 24 MHz
**HDL:** Verilog

---

# Part A — Plain-English Explanation

## 1. What This System Does

This is a keypad-operated electronic door lock built on an FPGA. A person types a 4-digit PIN on a keypad; the system checks it against a stored password and, if correct, unlocks a door (via a relay) for 5 seconds. If the PIN is wrong, it sounds a buzzer instead. An LCD screen shows live status messages, and an ESP32 Wi-Fi module is notified over a serial link so it can push an alert to a phone whenever something important happens (door opened, wrong PIN, admin mode used, password changed).

## 2. How It Works, Step by Step

1. **Idle:** When powered on, the system resets and immediately shows "ENTER PIN" on the LCD, waiting for the first key press.
2. **Typing the PIN:** As each key (0-9) is pressed, the `keypad_decoder` module turns the physical key press into a 4-bit number and tells the rest of the system "a key was pressed, here is its value." The main controller collects up to 4 digits. Pressing the clear key (E) erases what has been typed so far.
3. **Submitting the PIN:** Once 4 digits are entered, pressing the enter key (F) moves the system into a verification step.
4. **Checking the PIN:** The entered 4 digits are compared against the password stored in memory. The stored password is kept in a scrambled (XOR-encrypted) form rather than in plain text, and is unscrambled only for this comparison.
5. **Granting access:** If the PIN matches, the relay (which physically controls the door lock) is switched on and a 5-second timer starts. The LCD shows "ACCESS GRANTED" and the ESP32 is sent the message `ACC_OK` so a phone notification can be triggered. When the 5 seconds are up, the relay switches off and the system returns to idle.
6. **Denying access:** If the PIN does not match, the buzzer sounds for 5 seconds instead of the relay turning on, the LCD shows "ACCESS DENIED," and the ESP32 is sent `ACC_FAIL`.
7. **Admin mode (changing the password):** From the idle/entry screen, pressing the admin key (D) takes the user into admin mode. The LCD shows "ADMIN MODE." Entering a fixed master code (9999) and pressing enter allows the user to type a brand-new 4-digit password, which then overwrites the old one in memory. The ESP32 is told `ADMIN` when admin mode is entered, and `PWD_CHG` once the new password has been saved. Entering the wrong admin code simply returns to idle without changing anything.

## 3. Visual Flow of the System (FSM Diagram)

The diagram below shows every state the system can be in and what causes it to move from one state to the next. Blue ovals are the everyday PIN-entry path, green is a successful unlock, red is a rejected attempt, and amber is the admin/password-change path.

![Access FSM Diagram](fsm_diagram.png)

## 4. The Building Blocks (Modules) and Their Jobs

| Module | Plain-English Job |
|---|---|
| `keypad_decoder` | Watches the 16 keypad inputs and reports which single key was pressed, as a simple 4-bit number. |
| `access_fsm` | The "brain" of the system. Tracks what stage the system is in (entering PIN, checking it, granting/denying access, admin mode) and decides what to do next. |
| `password_manager` | Keeps the secret password safely (scrambled) and updates it when the admin sets a new one. |
| `timer_5s` | A simple stopwatch that counts 5 seconds, used to time how long the door stays unlocked or the buzzer sounds. |
| `lcd_message` | Picks the right two lines of text to show on the screen depending on what the brain (FSM) is doing. |
| `lcd_controller` | Handles the low-level wiring details of actually drawing text onto the physical LCD screen. |
| `esp32_notifier` | Notices when something notable happens (granted, denied, admin, password changed) and sends a short text message out over a serial wire. |
| `uart_tx` | Converts that short text message into the electrical serial signal the ESP32 module expects to receive. |

## 5. Key Numbers at a Glance

| Parameter | Value |
|---|---|
| System clock | 24 MHz |
| Door unlock / lockout time | 5 seconds |
| PIN length | 4 digits |
| Password protection | Scrambled (XOR) with a fixed key before storage |
| Admin master code | 9999 (fixed) |
| Phone notification link | Serial UART, 9600 baud, to an ESP32 |
| Display | 16x2 character LCD |
| Buzzer tone | 1 kHz beep |

## 6. Shortcomings

- **LCD display does not reliably work:** the controller never checks whether the screen is actually ready. It is supposed to read back a "busy" signal from the LCD before sending the next character, but the wiring (`lcd_rw`) is permanently fixed to write-only mode, so that check never happens. Instead, it just waits a fixed amount of time and assumes the screen kept up. On real hardware this can result in the LCD showing blank, garbled, or partially-updated text, especially right after power-on or if the specific LCD unit is slightly slower than expected.

---

# Part B — Technical RTL Report

## 1. Overview

The Smart Access Control System is an FPGA-based keypad entry system that authenticates a 4-digit PIN, controls a relay (door lock) and buzzer, displays status on a 16x2 character LCD, and sends event notifications to an ESP32 over UART for mobile push alerts.

## 2. System Block Diagram (Module Hierarchy)

```
smart_access_top
 ├── keypad_decoder      (16-key matrix → 4-bit value + valid flag)
 ├── password_manager    (stores encrypted password)
 ├── timer_5s            (5-second relay/buzzer hold timer)
 ├── access_fsm          (core authentication state machine)
 ├── lcd_message         (FSM state → display text mux)
 ├── lcd_controller      (drives DS1WC1602A 16x2 LCD, 8-bit mode)
 ├── esp32_notifier      (FSM state → UART event strings)
 │    └── uart_tx        (9600 8N1 UART transmitter)
 └── buzzer tone generator (1 kHz, inline in top module)
```

## 3. Module Descriptions

### 3.1 keypad_decoder
Combinational priority decoder. Converts 16 individual key inputs (0–9, A–F) into a 4-bit `key_value` and a `valid` flag. Key `0` has lowest priority order in the if/else chain (first checked), `F` highest.

### 3.2 password_manager
Stores the access password in encrypted form (`stored = password XOR KEY`, KEY = 16'hA5A5). Default password on reset decrypts to `16'h1234`. Updated synchronously when `write_en` is pulsed by the FSM. Uses **synchronous reset**.

### 3.3 timer_5s
27-bit counter producing a `done` pulse after 5 seconds (120,000,000 cycles @ 24 MHz). Used both to hold the relay open on success and to hold the buzzer/lockout on failure. Uses **asynchronous reset**.

### 3.4 access_fsm
Core 7-state authentication state machine (`IDLE`, `PIN_ENTRY`, `VERIFY`, `ACCESS_OK`, `ACCESS_FAIL`, `ADMIN_MODE`, `NEW_PASS`):

| State | Function |
|---|---|
| IDLE | Reset/idle, transitions immediately to PIN_ENTRY |
| PIN_ENTRY | Collects 4 digits; `E`=clear, `D`=enter admin mode, `F`=submit |
| VERIFY | Compares entered PIN against decrypted stored password |
| ACCESS_OK | Asserts relay, starts 5s timer, returns to IDLE on timeout |
| ACCESS_FAIL | Asserts buzzer, starts 5s timer, returns to IDLE on timeout |
| ADMIN_MODE | Requires fixed admin code `9999` to proceed to NEW_PASS |
| NEW_PASS | Collects 4-digit replacement password, pulses `write_en` |

Exposes `fsm_state` (3-bit) for use by the LCD message mux and ESP32 notifier. Uses **asynchronous reset**.

### 3.5 lcd_message
Combinational lookup table mapping `fsm_state` to two 16-character display lines (128-bit packed ASCII) — e.g. "ACCESS GRANTED / DOOR OPEN", "ENTER PIN / ****", etc.

### 3.6 lcd_controller
Sequencer driving an 8-bit parallel LCD (DS1WC1602A). Handles power-on delay (15 ms), 4-command initialization sequence, and refresh of both display lines whenever `line1`/`line2` change. Built around a reusable `send_byte` task for EN-pulse timing.

### 3.7 esp32_notifier
Watches `fsm_state` for rising-edge transitions into notable states and transmits a fixed ASCII message over UART to an ESP32:

| Trigger | Message |
|---|---|
| Enter ACCESS_OK | `ACC_OK\n` |
| Enter ACCESS_FAIL | `ACC_FAIL\n` |
| Enter ADMIN_MODE | `ADMIN\n` |
| NEW_PASS → IDLE | `PWD_CHG\n` |

Messages are stored as 64-bit packed ASCII ROM constants and shifted out byte-by-byte through `uart_tx`.

### 3.8 uart_tx
Standard 8N1 UART transmitter, 9600 baud at 24 MHz (2500 clocks/bit). `send` pulse latches a byte and shifts it out LSB-first with start/stop bits; `busy` flag gates back-to-back sends.

### 3.9 smart_access_top
Top-level integration: instantiates all submodules, generates the 1 kHz buzzer tone (gated by `buzzer_on`), and exposes board-level I/O (keypad, relay, buzzer, LEDs, LCD bus, ESP32 UART pin).

## 4. Key Design Parameters

| Parameter | Value |
|---|---|
| System clock | 24 MHz |
| Access timeout / lockout duration | 5 s |
| PIN length | 4 digits |
| Password encryption | XOR with fixed 16-bit key (0xA5A5) |
| Admin override code | 9999 (fixed) |
| UART baud rate | 9600 8N1 |
| LCD interface | 8-bit parallel, 16x2 character |
| Buzzer tone | 1 kHz |

## 5. Reset Strategy

| Module | Reset Type |
|---|---|
| access_fsm | Asynchronous |
| timer_5s | Asynchronous |
| uart_tx | Asynchronous |
| lcd_controller | Asynchronous |
| esp32_notifier | Asynchronous |
| password_manager | **Synchronous** |

> Note: `password_manager` is the only module using a synchronous reset; all others are asynchronous. This inconsistency should be confirmed as intentional during integration/timing closure.

## 6. Shortcomings

- **LCD busy flag not checked / display reliability issue** — `lcd_rw` is permanently driven low (`1'b0`), so `lcd_controller` never goes into read mode to poll the LCD's busy flag. All timing is open-loop, based purely on fixed cycle-count delays (`T_PWR`, `T_INIT`, `T_CMD`, `T_CHAR`). This works only as long as those delays are conservative enough for the actual LCD's real timing; there is no feedback path confirming the display has actually accepted each byte. In practice this means the LCD display may not work reliably — characters can be dropped, garbled, or left stale if the connected LCD's actual timing differs from the assumed constants.

## 7. File Listing

| File | Module |
|---|---|
| `smart_access_top.v` | Top-level integration |
| `access_fsm.v` | Authentication state machine |
| `keypad_decoder.v` | Keypad matrix decoder |
| `password_manager.v` | Encrypted password storage |
| `timer_5s.v` | 5-second hold timer |
| `lcd_message.v` | State → LCD text mapping |
| `lcd_controller.v` | LCD hardware driver |
| `esp32_notifier.v` | FSM → UART event notifier |
| `uart_tx.v` | UART transmitter |
