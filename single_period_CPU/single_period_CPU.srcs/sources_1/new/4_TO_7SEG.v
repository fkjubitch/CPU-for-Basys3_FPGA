`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/01 02:35:50
// Design Name: 
// Module Name: 4_TO_7SEG
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


module FOUR_TO_7SEG(
    input [3:0] IN,
    output reg [7:0] OUT
    );
    
always @(*) begin
    case(IN)
        4'b0000:OUT=8'b1100_0000;
        4'b0001:OUT=8'b1111_1001;
        4'b0010:OUT=8'b1010_0100;
        4'b0011:OUT=8'b1011_0000;
        4'b0100:OUT=8'b1001_1001;
        4'b0101:OUT=8'b1001_0010;
        4'b0110:OUT=8'b1000_0010;
        4'b0111:OUT=8'b1101_1000;
        4'b1000:OUT=8'b1000_0000;
        4'b1001:OUT=8'b1001_0000;
        4'b1010:OUT=8'b1000_1000;
        4'b1011:OUT=8'b1000_0011;
        4'b1100:OUT=8'b1100_0110;
        4'b1101:OUT=8'b1010_0001;
        4'b1110:OUT=8'b1000_0110; 
        4'b1111:OUT=8'b1000_1110; 
        default:OUT=8'b0000_0000;
    endcase
end

endmodule
