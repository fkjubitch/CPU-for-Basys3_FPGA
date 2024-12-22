`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/04 20:32:41
// Design Name: 
// Module Name: DM
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


module DM(
    input [31:0] ADDR,
    input [31:0] DATA,
    input RD,
    input WR,
    input CLOCK,
    output reg [31:0] DATA_OUT
    );
    
    reg [7:0] MEMORYs [255:0];
    reg [8:0] i;
    
    initial begin
        DATA_OUT = 0;
        for(i = 0;i <= 255;i=i+1) begin
            MEMORYs[i] = 0;
        end
    end
    
    // 读操作一直保持着
    always @(*) begin
        if(RD == 1) begin
            DATA_OUT = {MEMORYs[ADDR+3],MEMORYs[ADDR+2],MEMORYs[ADDR+1],MEMORYs[ADDR]};
        end
    end
    
    // 写操作只有在时钟下降才触发
    always @(negedge CLOCK) begin
        if(WR == 1) begin
            {MEMORYs[ADDR+3],MEMORYs[ADDR+2],MEMORYs[ADDR+1],MEMORYs[ADDR]} <= {DATA[31:24],DATA[23:16],DATA[15:8],DATA[7:0]};
        end
    end
    
endmodule
