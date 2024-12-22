`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/30 20:53:45
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
    input [4:0] ALUop, // ALUop[4]确定是否为带符号还是不带符号
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
        case(ALUop[3:0])
            4'b0000 : begin // 加
                RESULT = OP1 + OP2;
            end
            4'b0001 : begin // 减
                RESULT = OP1 - OP2;
            end
            4'b0010 : begin // 左移
                RESULT = OP2 << OP1;
            end
            4'b0011 : begin // 右移
                RESULT = OP2 >> OP1;
            end
            4'b0100 : begin // 或
                RESULT = OP1 | OP2;
            end
            4'b0101 : begin // 与
                RESULT = OP1 & OP2;
            end
            4'b0110 : begin // 无符号比较
                RESULT = OP1 < OP2;
            end
            4'b0111 : begin // 有符号比较
                if(OP1[31]==0 && OP2[31]==0)
                    RESULT = OP1 < OP2;
                else if(OP1[31]==0 && OP2[31]==1)
                    RESULT = 0;
                else if(OP1[31]==1 && OP2[31]==0)
                    RESULT = 1;
                else
                    RESULT = OP1 > OP2;
            end
            4'b1000 : begin // 异或
                RESULT = OP1 ^ OP2;
            end
        endcase
        // 符号和零判断
        if(ALUop[4] == 1 && RESULT[31] == 1)
            SIGN = 1;
        else
            SIGN = 0;
        if(RESULT == 0)
            ZERO = 1;
        else
            ZERO = 0;
    end
endmodule
