`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/06 20:01:46
// Design Name: 
// Module Name: MUX_1bit
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


module MUX_1bit_32(
    input SELECTION,
    input [31:0] ZERO,
    input [31:0] ONE,
    output reg [31:0] OUTPUT
    );
    
    initial begin
        OUTPUT = 0;
    end
    
    always @(*) begin
        if(SELECTION == 0)
            OUTPUT = ZERO;
        else
            OUTPUT = ONE;
    end
    
endmodule
