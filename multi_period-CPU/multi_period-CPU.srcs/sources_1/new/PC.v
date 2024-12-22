`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/04 20:32:41
// Design Name: 
// Module Name: PC
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

module PC(
    input CLOCK,
    input RST,
    input [31:0] NEXT_PC,
    input WR_ENABLE,
    output reg [31:0] CURR_PC
    );
    
    reg [31:0] INITIAL_PC = 32'h00000000; 
    
    initial begin
        CURR_PC = INITIAL_PC;
    end
    
    //写PC操作在下降沿触发
    always @(negedge CLOCK) begin
        if(RST==1) CURR_PC <= INITIAL_PC;
        else begin 
            if(WR_ENABLE==1) begin
                CURR_PC <= NEXT_PC;
            end
        end
    end
    
endmodule