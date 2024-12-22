`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/04 20:32:41
// Design Name: 
// Module Name: MUX_2bits_32
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


module MUX_2bits_32(
    input [1:0] SELECTION,
    input [31:0] ZERO,
    input [31:0] ONE,
    input [31:0] TWO,
    input [31:0] THREE,
    output reg [31:0] OUTPUT
    );
    
    initial begin
        OUTPUT = 0;
    end
    
    always @(*) begin
        case(SELECTION)
            2'b00 : 
                OUTPUT = ZERO;
            2'b01 :
                OUTPUT = ONE;
            2'b10:
                OUTPUT = TWO;
            2'b11:
                OUTPUT = THREE;
        endcase
    end
    
endmodule
