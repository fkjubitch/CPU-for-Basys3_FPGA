`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/04 20:32:41
// Design Name: 
// Module Name: CU
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


module CU(
    input CLOCK,
    input RESET,
    input ZERO,
    input SIGN,
    input [5:0] OP,
    input [5:0] FUNCT,
    output reg IM_RW,
    output reg PC_EN,
    output reg IR_WR_EN,
    output reg EXT_SEL,
    output reg [1:0] RF_WR_REG_SRC, //RF的写寄存器源
    output reg RF_WR_EN,
    output reg [3:0] ALUop,
    output reg ALU_SRC_A,
    output reg ALU_SRC_B,
    output reg [1:0] PC_SRC,
    output reg DM_RD,
    output reg DM_WR,
    output reg DB_SRC,
    output reg RF_WR_DATA_SRC
    );
    
    wire [2:0] STATUS;
    
    initial begin
        {IM_RW,PC_EN,IR_WR_EN,EXT_SEL,RF_WR_REG_SRC,RF_WR_EN,ALUop,ALU_SRC_A,ALU_SRC_B,PC_SRC,DM_RD,DM_WR,DB_SRC,RF_WR_DATA_SRC}
        =19'b1_0_0_0_00_0_0000_0_0_00_0_0_0_0;
    end
    
    DFF_FOR_CU dff( RESET , CLOCK , OP , STATUS );
    
    //一些通用的信号
    always @(*) begin
        DM_RD = 1;
        PC_EN = ~STATUS[2] & ~STATUS[1] & ~STATUS[0];
        IM_RW = 1;
        RF_WR_EN = STATUS[2] & ~STATUS[1] & ~STATUS[0];
        IR_WR_EN = ~STATUS[2] & ~STATUS[1] & STATUS[0];
    end
    
    //其他信号，在特定情况下特定考虑
    always @(*) begin
        case(OP)
            6'b000000: begin 
                //R-Type不需要操作EXT_SEL
                {PC_SRC,DM_WR,DB_SRC,RF_WR_DATA_SRC,RF_WR_REG_SRC,ALU_SRC_B} = 8'b00_0_0_1_10_0;
                case(FUNCT)
                    6'b000000: {ALUop,ALU_SRC_A} = 5'b1000_0; //add
                    6'b000001: {ALUop,ALU_SRC_A} = 5'b0000_0; //addu
                    6'b000010: {ALUop,ALU_SRC_A} = 5'b1001_0; //sub
                    6'b000011: {ALUop,ALU_SRC_A} = 5'b0001_0; //subu
                    6'b000110: {ALUop,ALU_SRC_A} = 5'b1110_0; //slt
                    6'b000111: {ALUop,ALU_SRC_A} = 5'b0101_0; //sltu
                    6'b001000: {ALUop,ALU_SRC_A} = 5'b0100_0; //and
                    6'b001001: {ALUop,ALU_SRC_A} = 5'b0011_0; //or
                    6'b001000: {ALUop,ALU_SRC_A} = 5'b0111_0; //xor
                endcase
            end
            6'b000010:begin
                //beq
                {DM_WR,ALU_SRC_A,ALU_SRC_B,EXT_SEL,ALUop} = 8'b0_0_0_1_1001;
                if(ZERO == 1) PC_SRC = 2'b01;
                else PC_SRC = 2'b00;
            end
            6'b000011:begin
                //bne
                {DM_WR,ALU_SRC_A,ALU_SRC_B,EXT_SEL,ALUop} = 8'b0_0_0_1_1001;
                if(ZERO == 0) PC_SRC = 2'b01;
                else PC_SRC = 2'b00;
            end
            6'b000100:begin
                //blez
                {DM_WR,ALU_SRC_A,ALU_SRC_B,EXT_SEL,ALUop} = 8'b0_0_0_1_1000;
                if(SIGN == 1 || ZERO == 1) PC_SRC = 2'b01;
                else PC_SRC = 2'b00;
            end
            6'b000101:begin
                //sw
                {PC_SRC,ALU_SRC_A,ALU_SRC_B,EXT_SEL,ALUop} = 9'b00_0_1_1_0000;
                DM_WR=~STATUS[2] & STATUS[1] & STATUS[0];
            end
            6'b000110:begin
                //lw
                {PC_SRC,ALU_SRC_A,ALU_SRC_B,EXT_SEL,ALUop,DM_WR,DB_SRC,RF_WR_DATA_SRC,RF_WR_REG_SRC} = 14'b00_0_1_1_0000_0_1_1_01;
            end
            6'b000111:begin
                //j
                {DM_WR,PC_SRC} = 3'b0_11;
            end
            6'b001000:begin
                //jal
                {DM_WR,PC_SRC,RF_WR_DATA_SRC,RF_WR_REG_SRC} = 6'b0_11_0_00;
            end
            6'b001001:begin
                //jr
                {DM_WR,PC_SRC} = 3'b0_10;
            end
            6'b001010:begin
                //sll
                {PC_SRC,DM_WR,DB_SRC,RF_WR_DATA_SRC,RF_WR_REG_SRC,ALU_SRC_B} = 8'b00_0_0_1_10_0;
                {ALUop,ALU_SRC_A} = 5'b0010_1;
            end
            //I-Type的运算部分
            6'b001011:begin
                {PC_SRC,DM_WR,DB_SRC,RF_WR_DATA_SRC,RF_WR_REG_SRC,ALU_SRC_B,EXT_SEL} = 9'b00_0_0_1_01_1_1;
                {ALUop,ALU_SRC_A} = 5'b1000_0; //addi
            end
            6'b001100:begin
                {PC_SRC,DM_WR,DB_SRC,RF_WR_DATA_SRC,RF_WR_REG_SRC,ALU_SRC_B,EXT_SEL} = 9'b00_0_0_1_01_1_1;
                {ALUop,ALU_SRC_A} = 5'b0000_0; //addiu
            end
            6'b001101:begin
                {PC_SRC,DM_WR,DB_SRC,RF_WR_DATA_SRC,RF_WR_REG_SRC,ALU_SRC_B,EXT_SEL} = 9'b00_0_0_1_01_1_1;
                {ALUop,ALU_SRC_A} = 5'b1001_0; //subi
            end
            6'b001110:begin
                {PC_SRC,DM_WR,DB_SRC,RF_WR_DATA_SRC,RF_WR_REG_SRC,ALU_SRC_B,EXT_SEL} = 9'b00_0_0_1_01_1_1;
                {ALUop,ALU_SRC_A} = 5'b0001_0; //subiu
            end
            6'b001111:begin
                {PC_SRC,DM_WR,DB_SRC,RF_WR_DATA_SRC,RF_WR_REG_SRC,ALU_SRC_B,EXT_SEL} = 9'b00_0_0_1_01_1_1;
                {ALUop,ALU_SRC_A} = 5'b1110_0; //slti
            end
            6'b010000:begin
                {PC_SRC,DM_WR,DB_SRC,RF_WR_DATA_SRC,RF_WR_REG_SRC,ALU_SRC_B,EXT_SEL} = 9'b00_0_0_1_01_1_1;
                {ALUop,ALU_SRC_A} = 5'b0101_0; //sltiu
            end
            6'b010001:begin
                {PC_SRC,DM_WR,DB_SRC,RF_WR_DATA_SRC,RF_WR_REG_SRC,ALU_SRC_B,EXT_SEL} = 9'b00_0_0_1_01_1_1;
                {ALUop,ALU_SRC_A} = 5'b0100_0; //andi
            end
            6'b010010:begin
                {PC_SRC,DM_WR,DB_SRC,RF_WR_DATA_SRC,RF_WR_REG_SRC,ALU_SRC_B,EXT_SEL} = 9'b00_0_0_1_01_1_1;
                {ALUop,ALU_SRC_A} = 5'b0011_0; //ori
            end
            6'b010011:begin
                {PC_SRC,DM_WR,DB_SRC,RF_WR_DATA_SRC,RF_WR_REG_SRC,ALU_SRC_B,EXT_SEL} = 9'b00_0_0_1_01_1_1;
                {ALUop,ALU_SRC_A} = 5'b0111_0; //xori
            end
            6'b111111:begin
                //halt
                DM_WR = 0;
            end
        endcase
    end
    
    /*
    使用的指令:
    OP:000000
        FUNCT:
        000000: add
        000001: addu
        000010: sub
        000011: subu
        000110: slt
        000111: sltu
        001000: and
        001001: or
        001010: xor
    OP:000010: beq
    OP:000011: bne
    OP:000100: blex
    OP:000101: sw
    OP:000110: lw
    OP:000111: j
    OP:001000: jal
    OP:001001: jr
    OP:001010: sll
    OP:001011: addi
    OP:001100: addiu
    OP:001101: subi
    OP:001110: subiu
    OP:001111: slti
    OP:010000: sltiu
    OP:010001: andi
    OP:010010: ori
    OP:010011: xori
    OP:111111: halt
    */
    
endmodule
