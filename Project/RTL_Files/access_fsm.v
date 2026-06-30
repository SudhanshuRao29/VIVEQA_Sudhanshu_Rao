module access_fsm(
    input clk,
    input rst,
    input key_valid,
    input [3:0] key_value,
    input [15:0] encrypted_password,
    input timer_done,
    output reg timer_start,
    output reg relay_on,
    output reg buzzer_on,
    output reg write_en,
    output reg [15:0] new_password,
    output reg [7:0] leds,
    output wire [2:0] fsm_state        // NEW: for lcd_message
);

parameter KEY = 16'hA5A5;

localparam IDLE        = 3'd0;
localparam PIN_ENTRY   = 3'd1;
localparam VERIFY      = 3'd2;
localparam ACCESS_OK   = 3'd3;
localparam ACCESS_FAIL = 3'd4;
localparam ADMIN_MODE  = 3'd5;
localparam NEW_PASS    = 3'd6;

reg [2:0] state;
reg [15:0] entered_pin;
reg [2:0] digit_count;

wire [15:0] stored_password;
assign stored_password = encrypted_password ^ KEY;

assign fsm_state = state;              // expose to top for LCD

always @(posedge clk or posedge rst) begin
    if(rst) begin
        state        <= IDLE;
        entered_pin  <= 16'h0000;
        digit_count  <= 3'd0;
        relay_on     <= 1'b0;
        buzzer_on    <= 1'b0;
        timer_start  <= 1'b0;
        write_en     <= 1'b0;
        new_password <= 16'h0000;
        leds         <= 8'b00000001;
    end
    else begin
        write_en <= 1'b0;
        case(state)

        IDLE: begin
            relay_on    <= 1'b0;
            buzzer_on   <= 1'b0;
            timer_start <= 1'b0;
            entered_pin <= 16'h0000;
            digit_count <= 3'd0;
            leds        <= 8'b00000001;
            state       <= PIN_ENTRY;
        end

        PIN_ENTRY: begin
            leds <= 8'b00000010;
            if(key_valid) begin
                if(key_value <= 4'h9) begin
                    if(digit_count < 3'd4) begin
                        entered_pin <= {entered_pin[11:0], key_value};
                        digit_count <= digit_count + 1'b1;
                    end
                end
                else if(key_value == 4'hE) begin
                    entered_pin <= 16'h0000;
                    digit_count <= 3'd0;
                end
                else if(key_value == 4'hD) begin
                    entered_pin <= 16'h0000;
                    digit_count <= 3'd0;
                    state       <= ADMIN_MODE;
                end
                else if(key_value == 4'hF) begin
                    if(digit_count == 3'd4)
                        state <= VERIFY;
                end
            end
        end

        VERIFY: begin
            if(entered_pin == stored_password) begin
                relay_on    <= 1'b1;
                timer_start <= 1'b1;
                leds        <= 8'b10000100;
                state       <= ACCESS_OK;
            end
            else begin
                buzzer_on <= 1'b1;
                leds      <= 8'b00001000;
                state     <= ACCESS_FAIL;
            end
        end

        ACCESS_OK: begin
            relay_on    <= 1'b1;
            timer_start <= 1'b1;
            if(timer_done) begin
                relay_on    <= 1'b0;
                timer_start <= 1'b0;
                state       <= IDLE;
            end
        end

        ACCESS_FAIL: begin
            buzzer_on   <= 1'b1;
            timer_start <= 1'b1;
            if(timer_done) begin
                buzzer_on   <= 1'b0;
                timer_start <= 1'b0;
                state       <= IDLE;
            end
        end

        ADMIN_MODE: begin
            leds <= 8'b00010000;
            if(key_valid) begin
                if(key_value <= 4'h9) begin
                    if(digit_count < 3'd4) begin
                        entered_pin <= {entered_pin[11:0], key_value};
                        digit_count <= digit_count + 1'b1;
                    end
                end
                else if(key_value == 4'hF) begin
                    if(entered_pin == 16'h9999) begin
                        entered_pin <= 16'h0000;
                        digit_count <= 3'd0;
                        state       <= NEW_PASS;
                    end
                    else
                        state <= IDLE;
                end
            end
        end

        NEW_PASS: begin
            leds <= 8'b00110000;
            if(key_valid) begin
                if(key_value <= 4'h9) begin
                    if(digit_count < 3'd4) begin
                        entered_pin <= {entered_pin[11:0], key_value};
                        digit_count <= digit_count + 1'b1;
                    end
                end
                else if(key_value == 4'hF) begin
                    if(digit_count == 3'd4) begin
                        new_password <= entered_pin;
                        write_en     <= 1'b1;
                        state        <= IDLE;
                    end
                end
            end
        end

        default: state <= IDLE;
        endcase
    end
end

endmodule