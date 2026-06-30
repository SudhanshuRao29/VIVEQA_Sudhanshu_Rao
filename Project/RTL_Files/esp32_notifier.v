`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.06.2026 12:52:24
// Design Name: 
// Module Name: esp32_notifier
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name : esp32_notifier
// Description : Watches FSM state transitions and sends fixed ASCII strings
//               over UART to an ESP32 for mobile push notifications.
//
// Protocol    : 9600 8N1, each event sends a single-line ASCII string
//               terminated with '\n' (0x0A).
//
// Messages sent (ESP32 parses the prefix):
//   "ACC_OK\n"    - Access Granted
//   "ACC_FAIL\n"  - Access Denied
//   "ADMIN\n"     - Admin mode entered
//   "PWD_CHG\n"   - Password changed
//
// The module detects rising-edge transitions into target states,
// latches the message, and feeds bytes one-by-one to uart_tx.
//////////////////////////////////////////////////////////////////////////////////
module esp32_notifier (
    input  wire       clk,
    input  wire       rst,
    input  wire [2:0] fsm_state,   // from access_fsm
    output wire       uart_tx_pin, // to ESP32 RX
    // debug
    output wire       notifier_busy
);

// ── FSM State constants (mirror access_fsm) ──────────────────
localparam S_IDLE       = 3'd0;
localparam S_PIN_ENTRY  = 3'd1;
localparam S_VERIFY     = 3'd2;
localparam S_ACCESS_OK  = 3'd3;
localparam S_ACCESS_FAIL= 3'd4;
localparam S_ADMIN_MODE = 3'd5;
localparam S_NEW_PASS   = 3'd6;

// ── Message ROM ───────────────────────────────────────────────
// Max message length = 8 bytes (e.g. "PWD_CHG\n")
// Stored MSB-first in 64-bit registers; we send byte [63:56] first.
localparam [63:0] MSG_ACC_OK   = "ACC_OK\n ";   // 7 used + 1 pad
localparam [63:0] MSG_ACC_FAIL = "ACC_FAIL";    // 8 used (add \n after)
localparam [63:0] MSG_ADMIN    = "ADMIN\n  ";   // 6 used + 2 pad
localparam [63:0] MSG_PWD_CHG  = "PWD_CHG\n";  // 8 used

// Message lengths (including '\n', excluding pads)
localparam [3:0] LEN_ACC_OK   = 4'd7;
localparam [3:0] LEN_ACC_FAIL = 4'd9;   // "ACC_FAIL\n"  9 chars
localparam [3:0] LEN_ADMIN    = 4'd6;
localparam [3:0] LEN_PWD_CHG  = 4'd8;

// ── Registers ────────────────────────────────────────────────
reg [2:0]  prev_state;
reg [63:0] msg_buf;        // current message shift register
reg [3:0]  msg_len;        // total bytes to send
reg [3:0]  byte_idx;       // bytes sent so far
reg        sending;        // 1 = transmission in progress

// Extra byte for ACC_FAIL newline (9 bytes = 64-bit + 1)
reg        extra_nl;       // flag: send extra '\n' after 8-byte msg
reg        sent_extra;

// ── UART TX wires ─────────────────────────────────────────────
reg        uart_send;
reg  [7:0] uart_data;
wire       uart_busy;

uart_tx u_uart (
    .clk  (clk),
    .rst  (rst),
    .send (uart_send),
    .data (uart_data),
    .busy (uart_busy),
    .tx   (uart_tx_pin)
);

assign notifier_busy = sending;

// ── State-transition detector & message loader ────────────────
always @(posedge clk or posedge rst) begin
    if (rst) begin
        prev_state  <= S_IDLE;
        sending     <= 1'b0;
        uart_send   <= 1'b0;
        uart_data   <= 8'h00;
        msg_buf     <= 64'd0;
        msg_len     <= 4'd0;
        byte_idx    <= 4'd0;
        extra_nl    <= 1'b0;
        sent_extra  <= 1'b0;
    end
    else begin
        uart_send  <= 1'b0;   // default: no send pulse

        prev_state <= fsm_state;

        // ── Detect rising edge into notification states ────────
        if (!sending) begin
            if (prev_state != fsm_state) begin
                case (fsm_state)
                    S_ACCESS_OK: begin
                        msg_buf    <= MSG_ACC_OK;
                        msg_len    <= LEN_ACC_OK;
                        byte_idx   <= 4'd0;
                        extra_nl   <= 1'b0;
                        sending    <= 1'b1;
                    end
                    S_ACCESS_FAIL: begin
                        // "ACC_FAIL" fits in 8 bytes, '\n' is 9th
                        msg_buf    <= MSG_ACC_FAIL;
                        msg_len    <= 4'd8;
                        byte_idx   <= 4'd0;
                        extra_nl   <= 1'b1;   // send '\n' after
                        sent_extra <= 1'b0;
                        sending    <= 1'b1;
                    end
                    S_ADMIN_MODE: begin
                        msg_buf    <= MSG_ADMIN;
                        msg_len    <= LEN_ADMIN;
                        byte_idx   <= 4'd0;
                        extra_nl   <= 1'b0;
                        sending    <= 1'b1;
                    end
                    S_NEW_PASS: begin
                        // Transition OUT of NEW_PASS back to IDLE
                        // means password was changed - handled below
                    end
                    S_IDLE: begin
                        // If previous was NEW_PASS → password changed
                        if (prev_state == S_NEW_PASS) begin
                            msg_buf    <= MSG_PWD_CHG;
                            msg_len    <= LEN_PWD_CHG;
                            byte_idx   <= 4'd0;
                            extra_nl   <= 1'b0;
                            sending    <= 1'b1;
                        end
                    end
                    default: ;
                endcase
            end
        end

        // ── Byte-by-byte UART transmitter ─────────────────────
        if (sending && !uart_busy && !uart_send) begin
            if (byte_idx < msg_len) begin
                uart_data  <= msg_buf[63:56];       // send MSB byte
                msg_buf    <= {msg_buf[55:0], 8'h00}; // shift left
                uart_send  <= 1'b1;
                byte_idx   <= byte_idx + 1'b1;
            end
            else if (extra_nl && !sent_extra) begin
                uart_data  <= 8'h0A;                // '\n'
                uart_send  <= 1'b1;
                sent_extra <= 1'b1;
            end
            else begin
                sending    <= 1'b0;                 // done
                sent_extra <= 1'b0;
            end
        end
    end
end

endmodule