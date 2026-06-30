`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.06.2026 12:51:42
// Design Name: 
// Module Name: uart_tx
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
// Module Name : uart_tx
// Description : 8N1 UART Transmitter
//               Baud = 9600, Clock = 24 MHz
//               Clocks per bit = 24_000_000 / 9600 = 2500
//
// Interface:
//   send     - pulse high for 1 clk to start transmission
//   data     - 8-bit byte to transmit
//   busy     - high while transmission is in progress
//   tx       - serial output line (idle HIGH)
//////////////////////////////////////////////////////////////////////////////////
module uart_tx (
    input  wire       clk,
    input  wire       rst,
    input  wire       send,
    input  wire [7:0] data,
    output reg        busy,
    output reg        tx
);

// ── Baud generator ───────────────────────────────────────────
parameter CLK_FREQ  = 24_000_000;
parameter BAUD_RATE = 9600;
localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;   // 2500

// ── Internal registers ────────────────────────────────────────
reg [12:0] baud_cnt;     // counts up to 2500
reg [3:0]  bit_idx;      // 0=start, 1-8=data bits, 9=stop
reg [9:0]  shift_reg;    // {stop, d7..d0, start}
reg        active;

// ── FSM ───────────────────────────────────────────────────────
always @(posedge clk or posedge rst) begin
    if (rst) begin
        tx        <= 1'b1;
        busy      <= 1'b0;
        active    <= 1'b0;
        baud_cnt  <= 13'd0;
        bit_idx   <= 4'd0;
        shift_reg <= 10'h3FF;
    end
    else begin
        if (!active) begin
            tx   <= 1'b1;
            busy <= 1'b0;
            if (send) begin
                // {stop=1, data[7:0], start=0}
                shift_reg <= {1'b1, data, 1'b0};
                active    <= 1'b1;
                busy      <= 1'b1;
                baud_cnt  <= 13'd0;
                bit_idx   <= 4'd0;
            end
        end
        else begin
            tx <= shift_reg[0];   // LSB first
            if (baud_cnt == CLKS_PER_BIT - 1) begin
                baud_cnt  <= 13'd0;
                shift_reg <= {1'b1, shift_reg[9:1]};  // shift right
                bit_idx   <= bit_idx + 1'b1;
                if (bit_idx == 4'd9) begin             // all 10 bits sent
                    active <= 1'b0;
                    busy   <= 1'b0;
                    tx     <= 1'b1;
                end
            end
            else begin
                baud_cnt <= baud_cnt + 1'b1;
            end
        end
    end
end

endmodule
