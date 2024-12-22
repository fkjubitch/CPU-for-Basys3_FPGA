`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/04 20:52:55
// Design Name: 
// Module Name: CLOCK_DIV
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


module CLOCK_DIV(
    input CLOCK,
    output reg DIV_CLOCK
    );
    
    integer COUNT;
    
    initial begin
        DIV_CLOCK = 0;
        COUNT = 0;
    end
    
    always @(posedge CLOCK) begin
        COUNT <= COUNT + 1;
        if(COUNT >= 1) begin //·ÂÕæÓÃ
//        if(COUNT >= 1000) begin
            DIV_CLOCK = ~DIV_CLOCK;
        end
    end
    
endmodule
