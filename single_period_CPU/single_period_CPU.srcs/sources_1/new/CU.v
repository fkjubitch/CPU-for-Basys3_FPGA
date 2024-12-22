`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/30 20:53:45
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
    input [5:0] OP,
    input [5:0] FUNCT,
    input ZERO,
    input SIGN,
    input PC_RST,
    output reg IM_RW,
    output reg PC_EN,
    output reg EXT_SEL,
    output reg REG_SRC, //RFµÄÐ´¼Ä´æÆ÷Ô´
    output reg REG_WR,
    output reg [4:0] ALUop,
    output reg ALU_SRC_A,
    output reg ALU_SRC_B,
    output reg [1:0] PC_SRC,
    output reg DM_RD,
    output reg DM_WR,
    output reg RF_WD_SRC
    );
    
    initial begin
        {IM_RW,PC_EN,EXT_SEL,REG_SRC,REG_WR,ALUop,ALU_SRC_A,ALU_SRC_B,PC_SRC,DM_RD,DM_WR,RF_WD_SRC}=17'b1_1_1_1_0_10000_0_0_00_1_0_1;
    end
    
    /*
    ------
    R-Type: OP 000000
    funct:
    000000 : add
    000010 : sub
    000100 : sll
    000110 : srl
    001000 : or
    001010 : and
    001100 : slt
    001101 : sltu
    001110 : xor
    ------
    I-Type: 
    OP: 000001
    funct:
    000000 : addi
    000010 : subi
    000100 : slli
    000110 : srli
    001000 : ori
    001010 : andi
    001100 : slti
    001101 : sltiu
    001110 : xori
    OP: 000010 lw
    OP: 000011 sw
    OP: 000100 beq
    OP: 000101 bne
    ------
    J-Type:
    OP: 000110 j
    OP: 111111 halt
    ------
    Other Type:
    OP: 000111 jal
    OP: 001000 jr
    ------
    */
    
    always @(*) begin
        if(PC_RST == 1) begin
            {IM_RW,PC_EN,EXT_SEL,REG_SRC,REG_WR,ALUop,ALU_SRC_A,ALU_SRC_B,PC_SRC,DM_RD,DM_WR,RF_WD_SRC}=17'b1_1_1_1_0_10000_0_0_00_1_0_1;
        end
        case(OP)
        //R-Type
        6'b000000: begin
            {IM_RW,PC_EN,REG_SRC,REG_WR,ALU_SRC_B,PC_SRC,DM_WR,RF_WD_SRC}=9'b1_1_1_1_0_00_0_0;
            case(FUNCT)
            6'b000000:{ALUop,ALU_SRC_A}=6'b10000_0; //add
            6'b000010:{ALUop,ALU_SRC_A}=6'b10001_0; //sub
            6'b000100:{ALUop,ALU_SRC_A}=6'b10010_1; //sll
            6'b000110:{ALUop,ALU_SRC_A}=6'b10011_1; //srl
            6'b001000:{ALUop,ALU_SRC_A}=6'b10100_0; //or
            6'b001010:{ALUop,ALU_SRC_A}=6'b10101_0; //and
            6'b001100:{ALUop,ALU_SRC_A}=6'b10110_0; //slt
            6'b001101:{ALUop,ALU_SRC_A}=6'b00111_0; //sltu
            6'b001110:{ALUop,ALU_SRC_A}=6'b11000_0; //xor
            endcase
        end 
        
        //I-Type immi
        6'b000010:begin
            {IM_RW,PC_EN,REG_SRC,REG_WR,ALU_SRC_B,PC_SRC,DM_WR,RF_WD_SRC}=9'b1_1_0_1_1_00_0_0;
            {ALUop,EXT_SEL,ALU_SRC_A}=7'b10000_1_0; //addi
        end
        6'b000011:begin
            {IM_RW,PC_EN,REG_SRC,REG_WR,ALU_SRC_B,PC_SRC,DM_WR,RF_WD_SRC}=9'b1_1_0_1_1_00_0_0;
            {ALUop,EXT_SEL,ALU_SRC_A}=7'b00000_1_0; //addiu
        end
        6'b000100:begin
            {IM_RW,PC_EN,REG_SRC,REG_WR,ALU_SRC_B,PC_SRC,DM_WR,RF_WD_SRC}=9'b1_1_0_1_1_00_0_0;
            {ALUop,EXT_SEL,ALU_SRC_A}=7'b10001_1_0; //subi
        end
        6'b000110:begin
            {IM_RW,PC_EN,REG_SRC,REG_WR,ALU_SRC_B,PC_SRC,DM_WR,RF_WD_SRC}=9'b1_1_0_1_1_00_0_0;
            {ALUop,EXT_SEL,ALU_SRC_A}=7'b10010_1_1; //slli
        end
        6'b001000:begin
            {IM_RW,PC_EN,REG_SRC,REG_WR,ALU_SRC_B,PC_SRC,DM_WR,RF_WD_SRC}=9'b1_1_0_1_1_00_0_0;
            {ALUop,EXT_SEL,ALU_SRC_A}=7'b10011_1_1; //srli
        end
        6'b001010:begin
            {IM_RW,PC_EN,REG_SRC,REG_WR,ALU_SRC_B,PC_SRC,DM_WR,RF_WD_SRC}=9'b1_1_0_1_1_00_0_0;
            {ALUop,EXT_SEL,ALU_SRC_A}=7'b10100_1_0; //ori
        end
        6'b001100:begin
            {IM_RW,PC_EN,REG_SRC,REG_WR,ALU_SRC_B,PC_SRC,DM_WR,RF_WD_SRC}=9'b1_1_0_1_1_00_0_0;
            {ALUop,EXT_SEL,ALU_SRC_A}=7'b10101_1_0; //andi
        end
        6'b001110:begin
            {IM_RW,PC_EN,REG_SRC,REG_WR,ALU_SRC_B,PC_SRC,DM_WR,RF_WD_SRC}=9'b1_1_0_1_1_00_0_0;
            {ALUop,EXT_SEL,ALU_SRC_A}=7'b10110_1_0; //slti
        end
        6'b001111:begin
            {IM_RW,PC_EN,REG_SRC,REG_WR,ALU_SRC_B,PC_SRC,DM_WR,RF_WD_SRC}=9'b1_1_0_1_1_00_0_0;
            {ALUop,EXT_SEL,ALU_SRC_A}=7'b00111_1_0; //sltiu
        end
        6'b010000:begin
            {IM_RW,PC_EN,REG_SRC,REG_WR,ALU_SRC_B,PC_SRC,DM_WR,RF_WD_SRC}=9'b1_1_0_1_1_00_0_0;
            {ALUop,EXT_SEL,ALU_SRC_A}=7'b11000_1_0; //xori
        end
        //lw
        6'b010010:{IM_RW,PC_EN,EXT_SEL,REG_SRC,REG_WR,ALUop,ALU_SRC_A,ALU_SRC_B,PC_SRC,DM_RD,DM_WR,RF_WD_SRC}=17'b1_1_1_0_1_10000_0_1_00_1_0_1;
        //sw
        6'b010011:{IM_RW,PC_EN,EXT_SEL,REG_WR,ALUop,ALU_SRC_A,ALU_SRC_B,PC_SRC,DM_WR}=14'b1_1_1_0_10000_0_1_00_1;
        //beq
        6'b010100:begin
            {IM_RW,PC_EN,EXT_SEL,REG_WR,ALUop,ALU_SRC_A,ALU_SRC_B,DM_WR}=12'b1_1_1_0_10001_0_0_0;
            if(ZERO==1) begin
                PC_SRC=2'b01;
            end
            else begin
                PC_SRC=2'b00;
            end
        end
        //bne
        6'b010101:begin
            {IM_RW,PC_EN,EXT_SEL,REG_WR,ALUop,ALU_SRC_A,ALU_SRC_B,DM_WR}=12'b1_1_1_0_10001_0_0_0;
            if(ZERO==0) begin
                PC_SRC=2'b01;
            end
            else begin
                PC_SRC=2'b00;
            end
        end
        //blez
        6'b010110:begin
            {IM_RW,PC_EN,EXT_SEL,REG_WR,ALUop,ALU_SRC_A,ALU_SRC_B,DM_WR}=12'b1_1_1_0_10000_0_0_0;
            if(SIGN == 0 && ZERO == 0) begin
                PC_SRC = 2'b00;
            end
            else begin
                PC_SRC = 2'b01;
            end
        end
        //J-Type
        //j
        6'b010111:{IM_RW,PC_EN,EXT_SEL,REG_WR,PC_SRC,DM_WR}=7'b1_1_1_0_10_0;
        
        //Other Type
        //halt
        6'b111111:{PC_EN,PC_SRC,REG_WR,DM_WR} = 4'b0_11_0_0;
        endcase
    end
    
//{IM_RW,PC_EN,EXT_SEL,REG_SRC,REG_WR,ALUop,ALU_SRC_A,ALU_SRC_B,PC_SRC,DM_RD,DM_WR,RF_WD_SRC}
    
endmodule
