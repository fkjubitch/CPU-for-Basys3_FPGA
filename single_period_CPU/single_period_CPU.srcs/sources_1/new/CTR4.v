`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/01 03:01:46
// Design Name: 
// Module Name: CTR4
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


module CTR4(
    CLOCK,
    COUNT,
    OUT
    );
    input CLOCK;
    output COUNT;
    output OUT;
    wire CLOCK;
    reg [1:0] COUNT;
    reg [3:0] OUT;
    
    initial begin
        COUNT = 0;
        OUT = 0;
    end
    
    always @(posedge CLOCK) begin
        COUNT = COUNT + 1;
    end
    
    always @(COUNT) begin
        case(COUNT)
            2'b00 : OUT = 4'b1110;
            2'b01 : OUT = 4'b1101;
            2'b10 : OUT = 4'b1011;
            2'b11 : OUT = 4'b0111;
        endcase
    end
endmodule
