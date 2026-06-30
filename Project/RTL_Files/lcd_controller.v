// ============================================================
//  lcd_controller.v
//  Board  : AT-STLN-ARTIX7-001 (ANM-PRD-2025-005)
//  Clock  : 24 MHz
//  Mode   : 8-bit parallel (DS1WC1602A onboard LCD)
//  Inputs : line1[127:0], line2[127:0]  - from lcd_message.v
// ============================================================

`timescale 1ns / 1ps

module lcd_controller(
    input  wire         clk,
    input  wire         rst,
    input  wire [127:0] line1,
    input  wire [127:0] line2,
    output reg          lcd_rs,
    output reg          lcd_rw,
    output reg          lcd_en,
    output reg  [7:0]   lcd_d
);

// ------------------------------------------------------------
//  Timing @ 24 MHz
//  1 cycle = 41.67 ns
//  15 ms power-on  = 360,000 cycles
//  4  ms init gap  = 96,000  cycles
//  2  ms cmd gap   = 48,000  cycles
//  50 us char gap  = 1,200   cycles
//  EN pulse >= 230 ns = 6 cycles minimum (use 12 for safety)
// ------------------------------------------------------------
localparam T_PWR   = 360000;   // 15 ms
localparam T_INIT  = 96000;    // 4  ms
localparam T_CMD   = 48000;    // 2  ms
localparam T_CHAR  = 1200;     // 50 us
localparam T_EN    = 12;       // EN high pulse width

// ------------------------------------------------------------
//  Sequencer states
// ------------------------------------------------------------
localparam S_PWR    = 4'd0;   // power-on delay
localparam S_INIT1  = 4'd1;   // cmd: 0x38 function set
localparam S_INIT2  = 4'd2;   // cmd: 0x0C display on
localparam S_INIT3  = 4'd3;   // cmd: 0x01 clear
localparam S_INIT4  = 4'd4;   // cmd: 0x06 entry mode
localparam S_WAIT   = 4'd5;   // idle, wait for line change
localparam S_ADDR1  = 4'd6;   // set DDRAM to 0x80 (line 1)
localparam S_LINE1  = 4'd7;   // write 16 chars line 1
localparam S_ADDR2  = 4'd8;   // set DDRAM to 0xC0 (line 2)
localparam S_LINE2  = 4'd9;   // write 16 chars line 2

reg [3:0]  seq;
reg [19:0] cnt;
reg [4:0]  ci;           // char index 0-15
reg [2:0]  ph;           // phase: 0=setup 1=EN_hi 2=EN_lo 3=delay

// track line changes to trigger refresh
reg [127:0] prev_line1, prev_line2;
reg         do_refresh;

// extract current character from line1/line2 based on ci
wire [7:0] ch1 = line1[127 - ci*8 -: 8];
wire [7:0] ch2 = line2[127 - ci*8 -: 8];

// ------------------------------------------------------------
//  Send byte helper - runs as phases within each seq state
//  ph=0 : drive data+rs, raise EN
//  ph=1 : hold EN high for T_EN cycles
//  ph=2 : lower EN
//  ph=3 : post-command delay (T_CMD or T_CHAR)
//  returns 1 when done (ph wraps back to 0 and seq advances)
// ------------------------------------------------------------

task send_byte;
    input [7:0]  byte_val;
    input        rs_val;
    input [19:0] delay;
    input [3:0]  next_seq;
    begin
        case(ph)
        0: begin
            lcd_rs <= rs_val;
            lcd_rw <= 0;
            lcd_d  <= byte_val;
            lcd_en <= 1;
            cnt    <= 0;
            ph     <= 1;
        end
        1: begin
            if(cnt < T_EN) cnt <= cnt + 1;
            else begin lcd_en <= 0; cnt <= 0; ph <= 2; end
        end
        2: begin
            // EN low hold (one cycle) then delay
            cnt <= 0; ph <= 3;
        end
        3: begin
            if(cnt < delay) cnt <= cnt + 1;
            else begin cnt <= 0; ph <= 0; seq <= next_seq; end
        end
        endcase
    end
endtask

always @(posedge clk or posedge rst) begin
    if(rst) begin
        seq        <= S_PWR;
        cnt        <= 0;
        ci         <= 0;
        ph         <= 0;
        lcd_rs     <= 0;
        lcd_rw     <= 0;
        lcd_en     <= 0;
        lcd_d      <= 8'h00;
        prev_line1 <= 0;
        prev_line2 <= 0;
        do_refresh <= 0;
    end
    else begin

        // detect any change in display content -> trigger refresh
        if(line1 !== prev_line1 || line2 !== prev_line2) begin
            prev_line1 <= line1;
            prev_line2 <= line2;
            do_refresh <= 1;
        end

        case(seq)

        // ── Power-on delay (15 ms) ─────────────────────────
        S_PWR: begin
            lcd_en <= 0;
            if(cnt < T_PWR) cnt <= cnt + 1;
            else begin cnt <= 0; ph <= 0; seq <= S_INIT1; end
        end

        // ── Init sequence ───────────────────────────────────
        S_INIT1: begin
            send_byte(8'h38, 1'b0, T_INIT, S_INIT2);   // function set: 8-bit, 2-line, 5x8
        end
        S_INIT2: begin
            send_byte(8'h0C, 1'b0, T_INIT, S_INIT3);   // display on, cursor off, blink off
        end
        S_INIT3: begin
            send_byte(8'h01, 1'b0, T_CMD, S_INIT4);    // clear display, needs extra time
        end
        S_INIT4: begin
            send_byte(8'h06, 1'b0, T_CMD, S_WAIT);     // entry mode: increment, no shift
        end

        // ── Wait for content change ─────────────────────────
        S_WAIT: begin
            lcd_en <= 0;
            if(do_refresh) begin
                do_refresh <= 0;
                ci         <= 0;
                ph         <= 0;
                seq        <= S_ADDR1;
            end
        end

        // ── Set cursor line 1 (DDRAM 0x80) ─────────────────
        S_ADDR1: begin
            send_byte(8'h80, 1'b0, T_CMD, S_LINE1);    // set DDRAM line 1
        end

        // ── Write 16 chars to line 1 ────────────────────────
        S_LINE1: begin
            case(ph)
            0: begin
                lcd_rs <= 1;
                lcd_rw <= 0;
                lcd_d  <= ch1;
                lcd_en <= 1;
                cnt    <= 0;
                ph     <= 1;
            end
            1: begin
                if(cnt < T_EN) cnt <= cnt + 1;
                else begin lcd_en <= 0; cnt <= 0; ph <= 2; end
            end
            2: begin cnt <= 0; ph <= 3; end
            3: begin
                if(cnt < T_CHAR) cnt <= cnt + 1;
                else begin
                    cnt <= 0; ph <= 0;
                    if(ci == 15) begin ci <= 0; seq <= S_ADDR2; end
                    else ci <= ci + 1;
                end
            end
            endcase
        end

        // ── Set cursor line 2 (DDRAM 0xC0) ─────────────────
        S_ADDR2: begin
            send_byte(8'hC0, 1'b0, T_CMD, S_LINE2);    // set DDRAM line 2
        end

        // ── Write 16 chars to line 2 ────────────────────────
        S_LINE2: begin
            case(ph)
            0: begin
                lcd_rs <= 1;
                lcd_rw <= 0;
                lcd_d  <= ch2;
                lcd_en <= 1;
                cnt    <= 0;
                ph     <= 1;
            end
            1: begin
                if(cnt < T_EN) cnt <= cnt + 1;
                else begin lcd_en <= 0; cnt <= 0; ph <= 2; end
            end
            2: begin cnt <= 0; ph <= 3; end
            3: begin
                if(cnt < T_CHAR) cnt <= cnt + 1;
                else begin
                    cnt <= 0; ph <= 0;
                    if(ci == 15) begin ci <= 0; seq <= S_WAIT; end
                    else ci <= ci + 1;
                end
            end
            endcase
        end

        default: seq <= S_WAIT;
        endcase
    end
end

endmodule