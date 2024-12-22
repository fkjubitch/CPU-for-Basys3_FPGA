`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/04 20:32:41
// Design Name: 
// Module Name: EXT
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


module EXT(
    input [15:0] IMMI,
    input EXT_OPT,
    output reg [31:0] EXT_IMMI
    );
    
    initial begin
        EXT_IMMI = 0;
    end
    
    always @(*) begin
        if(EXT_OPT==0||(EXT_OPT==1 && IMMI[15]==0))
            EXT_IMMI = {16'h0000,IMMI}; //高位补0
        else
            EXT_IMMI = {16'hffff,IMMI}; //高位补1
    end
endmodule
