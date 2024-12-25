`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/25 20:18:51
// Design Name: 
// Module Name: DEBOUNCER
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


module DEBOUNCER(
    input IN,
    input CLOCK,
    output reg OUT
    );
    
    always @(IN) begin
        #20;
        //#1; //ทยีๆ
        OUT = IN;
    end
    
endmodule
