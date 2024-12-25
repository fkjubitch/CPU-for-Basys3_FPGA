`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/04 20:51:14
// Design Name: 
// Module Name: DFF
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

//D-Flip-Flop
module DFF(
    input EN,
    input CLOCK,
    input [31:0] D_IN,
    output reg [31:0] D_OUT
    );
    
    initial D_OUT = 0;
    
    always @(posedge CLOCK) begin
        if(EN) D_OUT = D_IN;
    end
    
endmodule
