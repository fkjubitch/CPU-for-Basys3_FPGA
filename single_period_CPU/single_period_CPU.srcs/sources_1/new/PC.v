`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/30 20:53:45
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
    input ENABLE,
    output reg [31:0] CURR_PC
    );
    
    reg [31:0] INITIAL_PC = 32'h00000000; 
    
    initial begin
        CURR_PC = INITIAL_PC;
    end
    
    always @(posedge CLOCK) begin
        if(RST==1) CURR_PC <= INITIAL_PC;
        else begin 
            if(ENABLE==1) begin
                CURR_PC <= NEXT_PC;
            end
        end
    end
    
endmodule
