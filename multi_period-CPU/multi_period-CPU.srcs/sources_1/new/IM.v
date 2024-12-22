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
    end
    
    always @(*) begin
        if(RW_ENABLE == 1)  //¶Á
            I_DATA_OUT = {I_STORAGE[I_ADDR+3],I_STORAGE[I_ADDR+2],I_STORAGE[I_ADDR+1],I_STORAGE[I_ADDR]};
        else  //Ð´ (·ÇW)
            {I_STORAGE[I_ADDR+3],I_STORAGE[I_ADDR+2],I_STORAGE[I_ADDR+1],I_STORAGE[I_ADDR]} = {I_DATA_IN[31:24],I_DATA_IN[23:16],I_DATA_IN[15:8],I_DATA_IN[7:0]};
    end
    
endmodule