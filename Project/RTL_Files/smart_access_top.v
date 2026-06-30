`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name : smart_access_top
// Description : Smart Access System - Top Level
//               Updated to include ESP32 UART notification channel.
//
// Change log  :
//   v1.0  - Original (LCD, keypad, FSM, relay, buzzer)
//   v2.0  - Replaced SD card plan; added esp32_notifier + uart_tx
//           New port: esp32_tx (UART serial out to ESP32 RX pin)
//////////////////////////////////////////////////////////////////////////////////
module smart_access_top(
    input  wire clk,
    input  wire rst,

    // ── Keypad ────────────────────────────────────────────────
    input  wire key0,  input wire key1,  input wire key2,  input wire key3,
    input  wire key4,  input wire key5,  input wire key6,  input wire key7,
    input  wire key8,  input wire key9,
    input  wire keyA,  input wire keyB,  input wire keyC,
    input  wire keyD,  input wire keyE,  input wire keyF,

    // ── Outputs ───────────────────────────────────────────────
    output wire relay_out,
    output wire buzzer_out,
    output wire [7:0] leds,

    // ── LCD (DS1WC1602A onboard) ──────────────────────────────
    output wire lcd_rs,
    output wire lcd_rw,
    output wire lcd_en,
    output wire [7:0] lcd_d,

    // ── ESP32 UART (NEW) ──────────────────────────────────────
    output wire esp32_tx           // FPGA TX → ESP32 RX (9600 8N1)
);

// ── Internal wires ────────────────────────────────────────────
wire        key_valid;
wire [3:0]  key_value;
wire [15:0] encrypted_password;
wire        write_en;
wire [15:0] new_password;
wire        relay_on;
wire        buzzer_on;
wire        timer_done;
wire        timer_start;
wire [2:0]  fsm_state;
wire [127:0] line1, line2;

// ──────────────────────────────────────────────────────────────
// Buzzer tone generator - 1 kHz @ 24 MHz
// 24,000,000 / 1000 / 2 = 12,000 cycles per half-period
// ──────────────────────────────────────────────────────────────
reg [13:0] buzz_cnt;
reg        buzz_tone;
always @(posedge clk) begin
    if (buzz_cnt == 14'd11_999) begin
        buzz_cnt  <= 0;
        buzz_tone <= ~buzz_tone;
    end
    else
        buzz_cnt <= buzz_cnt + 1;
end
assign buzzer_out = buzzer_on & buzz_tone;

// ──────────────────────────────────────────────────────────────
// Keypad Decoder
// ──────────────────────────────────────────────────────────────
keypad_decoder u_decoder(
    .key0(key0),  .key1(key1),  .key2(key2),  .key3(key3),
    .key4(key4),  .key5(key5),  .key6(key6),  .key7(key7),
    .key8(key8),  .key9(key9),
    .keyA(keyA),  .keyB(keyB),  .keyC(keyC),
    .keyD(keyD),  .keyE(keyE),  .keyF(keyF),
    .valid(key_valid),
    .key_value(key_value)
);

// ──────────────────────────────────────────────────────────────
// Password Manager
// ──────────────────────────────────────────────────────────────
password_manager u_pwd(
    .clk(clk),
    .rst(rst),
    .write_en(write_en),
    .new_password(new_password),
    .encrypted_password(encrypted_password)
);

// ──────────────────────────────────────────────────────────────
// Timer (5 seconds @ 24 MHz)
// ──────────────────────────────────────────────────────────────
timer_5s u_timer(
    .clk(clk),
    .rst(rst),
    .start(timer_start),
    .done(timer_done)
);

// ──────────────────────────────────────────────────────────────
// Access FSM
// ──────────────────────────────────────────────────────────────
access_fsm u_fsm(
    .clk(clk),
    .rst(rst),
    .key_valid(key_valid),
    .key_value(key_value),
    .encrypted_password(encrypted_password),
    .timer_done(timer_done),
    .timer_start(timer_start),
    .relay_on(relay_on),
    .buzzer_on(buzzer_on),
    .write_en(write_en),
    .new_password(new_password),
    .leds(leds),
    .fsm_state(fsm_state)
);

// ──────────────────────────────────────────────────────────────
// LCD Message Mux
// ──────────────────────────────────────────────────────────────
lcd_message u_msg(
    .state(fsm_state),
    .line1(line1),
    .line2(line2)
);

// ──────────────────────────────────────────────────────────────
// LCD Controller
// ──────────────────────────────────────────────────────────────
lcd_controller u_lcd(
    .clk(clk),
    .rst(rst),
    .line1(line1),
    .line2(line2),
    .lcd_rs(lcd_rs),
    .lcd_rw(lcd_rw),
    .lcd_en(lcd_en),
    .lcd_d(lcd_d)
);

// ──────────────────────────────────────────────────────────────
// ESP32 Notifier (NEW)
// Monitors FSM state, sends ASCII event strings via UART
// ──────────────────────────────────────────────────────────────
esp32_notifier u_esp32(
    .clk          (clk),
    .rst          (rst),
    .fsm_state    (fsm_state),
    .uart_tx_pin  (esp32_tx),
    .notifier_busy()           // unconnected - for debug only
);

// ──────────────────────────────────────────────────────────────
// Relay
// ──────────────────────────────────────────────────────────────
assign relay_out = relay_on;

endmodule