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
    input [3:0] ALUop, // ALUop[3]ȷ���Ƿ�Ϊ�����Ż��ǲ�������
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
            3'b000 : begin // ��
                RESULT = OP1 + OP2;
            end
            3'b001 : begin // ��
                RESULT = OP1 - OP2;
            end
            3'b010 : begin // ����
                RESULT = OP2 << OP1;
            end
            3'b011 : begin // ��
                RESULT = OP1 | OP2;
            end
            3'b100 : begin // ��
                RESULT = OP1 & OP2;
            end
            3'b101 : begin // �޷��űȽ�
                RESULT = OP1 < OP2;
            end
            3'b110 : begin // �з��űȽ�
                if(OP1[31]==0 && OP2[31]==0)
                    RESULT = OP1 < OP2;
                else if(OP1[31]==0 && OP2[31]==1)
                    RESULT = 0;
                else if(OP1[31]==1 && OP2[31]==0)
                    RESULT = 1;
                else
                    RESULT = OP1 > OP2;
            end
            3'b111 : begin // ���
                RESULT = OP1 ^ OP2;
            end
        endcase
        // ���ź����ж�
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
