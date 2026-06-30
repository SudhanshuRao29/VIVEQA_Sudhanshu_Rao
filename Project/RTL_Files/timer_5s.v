// timer_5s.v  -  fixed for 24 MHz clock
// 5 seconds = 24,000,000 * 5 = 120,000,000 cycles
// Counter needs 27 bits (2^27 = 134,217,728 > 120,000,000)

module timer_5s(
    input  wire clk,
    input  wire rst,
    input  wire start,
    output reg  done
);

reg [26:0] count;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        count <= 0;
        done  <= 0;
    end
    else if(start) begin
        if(count == 27'd119_999_999) begin   // 5s @ 24 MHz
            count <= 0;
            done  <= 1;
        end
        else begin
            count <= count + 1;
            done  <= 0;
        end
    end
    else begin
        count <= 0;
        done  <= 0;
    end
end

endmodule