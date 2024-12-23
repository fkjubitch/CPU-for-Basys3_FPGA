`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/04 20:32:41
// Design Name: 
// Module Name: IM
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


module IM(
    input RW_ENABLE,
    input [31:0] I_ADDR,
    input [31:0] I_DATA_IN,
    output reg [31:0] I_DATA_OUT
    );
    
    reg [7:0] I_STORAGE[255:0];
    
    initial begin
        I_DATA_OUT = 0;
        {I_STORAGE[19],I_STORAGE[18],I_STORAGE[17],I_STORAGE[16],I_STORAGE[15],I_STORAGE[14],I_STORAGE[13],I_STORAGE[12],I_STORAGE[11],I_STORAGE[10],I_STORAGE[9],I_STORAGE[8],I_STORAGE[7],I_STORAGE[6],I_STORAGE[5],I_STORAGE[4],I_STORAGE[3],I_STORAGE[2],I_STORAGE[1],I_STORAGE[0]}=160'b0011000000000001000000000000100001001000000000100000000000000010010011000100001100000000000010000000000001100001001000000000001000000000100000100010100000001000;
        {I_STORAGE[23],I_STORAGE[22],I_STORAGE[21],I_STORAGE[20]}=32'b11111100000000000000000000000000;
    end
    
    always @(*) begin
        if(RW_ENABLE == 1)  //��
            I_DATA_OUT = {I_STORAGE[I_ADDR+3],I_STORAGE[I_ADDR+2],I_STORAGE[I_ADDR+1],I_STORAGE[I_ADDR]};
        else  //д (��W)
            {I_STORAGE[I_ADDR+3],I_STORAGE[I_ADDR+2],I_STORAGE[I_ADDR+1],I_STORAGE[I_ADDR]} = {I_DATA_IN[31:24],I_DATA_IN[23:16],I_DATA_IN[15:8],I_DATA_IN[7:0]};
    end
    
endmodule