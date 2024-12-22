`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/04 20:32:41
// Design Name: 
// Module Name: RF
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

module RF(
    input RST,
    input CLOCK,
    input [4:0] RS,
    input [4:0] RT,
    input [4:0] WRITE_REG,
    input WR_ENABLE,
    input [31:0] WRITE_DATA,
    output reg [31:0] RSDATA,
    output reg [31:0] RTDATA
    );
    
    reg [31:0] REGs[31:0];
    reg [5:0] TEMP;
    
    initial begin
        RSDATA = 0;
        RTDATA = 0;
        for(TEMP = 0;TEMP <= 6'b011111;TEMP = TEMP + 1) begin
            REGs[TEMP[4:0]] = 0;
        end
    end
    
    // 读操作一直保持着
    always @(*) begin
        RSDATA = REGs[RS];
        RTDATA = REGs[RT];
    end
    
    // 写操作只有在时钟下降才会触发
    always @(negedge CLOCK) begin
        if(WR_ENABLE == 1) begin
            REGs[WRITE_REG] <= WRITE_DATA;
        end
        if(RST) begin
            for(TEMP = 0;TEMP <= 6'b011111;TEMP = TEMP + 1) begin
                REGs[TEMP[4:0]] = 0;
            end
        end
    end
    
endmodule