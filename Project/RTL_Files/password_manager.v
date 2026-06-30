`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.06.2026 15:09:54
// Design Name: 
// Module Name: password_manager
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

module password_manager(
    input clk,
    input rst,
    input write_en,
    input [15:0] new_password,
    output reg [15:0] encrypted_password
);

parameter KEY = 16'hA5A5;

always @(posedge clk) begin
    if(rst)
        encrypted_password <= (16'h1234 ^ KEY);
    else if(write_en)
        encrypted_password <= (new_password ^ KEY);
end

endmodule
