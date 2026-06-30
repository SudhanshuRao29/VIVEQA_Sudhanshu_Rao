`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.06.2026 15:26:01
// Design Name: 
// Module Name: keypad_decoder
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


module keypad_decoder(

    input key0,
    input key1,
    input key2,
    input key3,
    input key4,
    input key5,
    input key6,
    input key7,
    input key8,
    input key9,

    input keyA,
    input keyB,
    input keyC,
    input keyD,
    input keyE,
    input keyF,

    output reg valid,
    output reg [3:0] key_value

);

always @(*) begin

    valid = 1'b0;
    key_value = 4'h0;

    if(key0) begin valid=1; key_value=4'h0; end
    else if(key1) begin valid=1; key_value=4'h1; end
    else if(key2) begin valid=1; key_value=4'h2; end
    else if(key3) begin valid=1; key_value=4'h3; end
    else if(key4) begin valid=1; key_value=4'h4; end
    else if(key5) begin valid=1; key_value=4'h5; end
    else if(key6) begin valid=1; key_value=4'h6; end
    else if(key7) begin valid=1; key_value=4'h7; end
    else if(key8) begin valid=1; key_value=4'h8; end
    else if(key9) begin valid=1; key_value=4'h9; end
    else if(keyA) begin valid=1; key_value=4'hA; end
    else if(keyB) begin valid=1; key_value=4'hB; end
    else if(keyC) begin valid=1; key_value=4'hC; end
    else if(keyD) begin valid=1; key_value=4'hD; end
    else if(keyE) begin valid=1; key_value=4'hE; end
    else if(keyF) begin valid=1; key_value=4'hF; end

end

endmodule
