`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.06.2026 09:45:47
// Design Name: 
// Module Name: lcd_message
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

module lcd_message(

    input [2:0] state,

    output reg [127:0] line1,
    output reg [127:0] line2

);

localparam
IDLE         = 3'd0,
PIN_ENTRY    = 3'd1,
VERIFY       = 3'd2,
ACCESS_OK    = 3'd3,
ACCESS_FAIL  = 3'd4,
ADMIN_MODE   = 3'd5,
NEW_PASSWORD = 3'd6;

always @(*)
begin

case(state)

IDLE:
begin
line1 = " SMART ACCESS  ";
line2 = " ENTER PIN     ";
end

PIN_ENTRY:
begin
line1 = " ENTER PIN     ";
line2 = " ****          ";
end

VERIFY:
begin
line1 = " VERIFYING...  ";
line2 = " PLEASE WAIT   ";
end

ACCESS_OK:
begin
line1 = " ACCESS GRANTED";
line2 = " DOOR OPEN     ";
end

ACCESS_FAIL:
begin
line1 = " ACCESS DENIED ";
line2 = " TRY AGAIN     ";
end

ADMIN_MODE:
begin
line1 = " ADMIN MODE    ";
line2 = " ENTER ADMIN   ";
end

NEW_PASSWORD:
begin
line1 = " NEW PASSWORD  ";
line2 = " ENTER 4 DIGITS";
end

default:
begin
line1 = " SMART ACCESS  ";
line2 = " READY         ";
end

endcase

end

endmodule
