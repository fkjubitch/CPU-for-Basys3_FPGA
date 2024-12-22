`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/27 20:14:08
// Design Name: 
// Module Name: MUX_1bit_5
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


module MUX_1bit_5(
    input SELECTION,
    input [4:0] ZERO,
    input [4:0] ONE,
    output reg [4:0] OUTPUT
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