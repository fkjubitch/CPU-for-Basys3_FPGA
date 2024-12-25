`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/19 17:48:16
// Design Name: 
// Module Name: DFF_FOR_CU
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

//CU的有限状态机,主体是DFF(D触发器)
module DFF_FOR_CU(
    input RESET,
    input CLOCK,
    input [5:0] OP,
    output reg [2:0] CURR_STATUS
    );
    
    reg [2:0] DFF;
    
    initial begin
        CURR_STATUS = 3'b101;
        DFF = 3'b001;
    end
    
    always @(posedge CLOCK) begin
        if(RESET==1) begin
            DFF = 3'b101;
        end
        CURR_STATUS = DFF;
        case(CURR_STATUS) 
            3'b000:begin
                DFF = 3'b001;
            end
            3'b001:begin
                if(OP == 6'b111111 || OP == 6'b000111 || OP == 6'b001000 || OP == 6'b001001) DFF = 3'b000;
                else DFF = 3'b010;
            end
            3'b010:begin
                if(OP == 6'b000101 || OP == 6'b000110) DFF = 3'b011;
                else if(OP == 6'b000010 || OP == 6'b000011 || OP == 6'b000100) DFF = 3'b000;
                else DFF = 3'b100;
            end
            3'b011:begin
                if(OP == 6'b000101) DFF = 3'b000;
                else DFF = 3'b100;
            end
            3'b100:begin
                DFF = 3'b000;
            end
            3'b101:begin // Initial Status
                DFF = 3'b001;
            end
        endcase
    end
    
endmodule
