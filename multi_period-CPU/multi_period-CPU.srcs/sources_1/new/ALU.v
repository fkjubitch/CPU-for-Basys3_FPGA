`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/04 20:32:41
// Design Name: 
// Module Name: ALU
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

module ALU(
    input [31:0] OP1,
    input [31:0] OP2,
    input [3:0] ALUop, // ALUop[3]确定是否为带符号还是不带符号
    output reg SIGN,
    output reg ZERO,
    output reg [31:0] RESULT
    );
    
    initial begin
        SIGN = 0;
        ZERO = 1;
        RESULT = 0;
    end
    
    always @(*) begin
        case(ALUop[2:0])
            3'b000 : begin // 加
                RESULT = OP1 + OP2;
            end
            3'b001 : begin // 减
                RESULT = OP1 - OP2;
            end
            3'b010 : begin // 左移
                RESULT = OP2 << OP1;
            end
            3'b011 : begin // 或
                RESULT = OP1 | OP2;
            end
            3'b100 : begin // 与
                RESULT = OP1 & OP2;
            end
            3'b101 : begin // 无符号比较
                RESULT = OP1 < OP2;
            end
            3'b110 : begin // 有符号比较
                if(OP1[31]==0 && OP2[31]==0)
                    RESULT = OP1 < OP2;
                else if(OP1[31]==0 && OP2[31]==1)
                    RESULT = 0;
                else if(OP1[31]==1 && OP2[31]==0)
                    RESULT = 1;
                else
                    RESULT = OP1 > OP2;
            end
            3'b111 : begin // 异或
                RESULT = OP1 ^ OP2;
            end
        endcase
        // 符号和零判断
        if(ALUop[3] == 1 && RESULT[31] == 1)
            SIGN = 1;
        else
            SIGN = 0;
        if(RESULT == 0)
            ZERO = 1;
        else
            ZERO = 0;
    end
endmodule
