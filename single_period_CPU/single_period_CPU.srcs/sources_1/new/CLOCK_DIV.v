`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/20 19:45:22
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
    output reg DIVed_CLOCK
    );
    
    integer count;
    
    initial begin
        DIVed_CLOCK = 0;
        count = 0;
    end
    
    always @(posedge CLOCK) begin
        count <= count + 1;
        if(count == 1) begin //·ÂÕæÓÃ
//        if(count == 1000) begin
            DIVed_CLOCK = ~DIVed_CLOCK;
            count <= 0;
        end
    end
    
endmodule
