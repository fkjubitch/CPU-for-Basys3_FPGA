`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/30 20:53:45
// Design Name: 
// Module Name: CPU
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


// top file
module CPU(
    //input 
    CLOCK, //ϵͳʱ��
    MAIN_CLK, //�ֶ�����ʱ�ӣ�ģ��ʱ������
    PC_RST, //PC�����ź�
    DATA_SEL, //�������ѡ��
    SEG7, //�߶������
    POS //�����λѡ
//    PC_, //PC
//    IM_OUT_DATA,
//    ALU_RES, //ALU������
//    ALU_ZERO, //ALU��������λ
//    ALU_SIGN, //ALU����������λ
//    RF_REG_SRC, //RFд�Ĵ���Դѡ���ź�
//    RF_RD1, //RF��rs�õ�������
//    RF_RD2, //RF��rt�õ�������
//    RF_WR_DATA, //RFд�Ĵ�������
//    RF_WR_REG, //RFд�Ĵ���Դ
//    RF_REG_WR, //RFдʹ���ź�
//    DM_DOUT //DM�����
    );
    
    input CLOCK;
    input MAIN_CLK;
    input PC_RST;
    input DATA_SEL;
    output SEG7;
    output POS;
//    output PC_;
//    output IM_OUT_DATA;
//    output ALU_RES;
//    output ALU_ZERO;
//    output ALU_SIGN;
//    output RF_REG_SRC;
//    output RF_RD1;
//    output RF_RD2;
//    output RF_WR_DATA; //RFд�Ĵ�������
//    output RF_WR_REG; //RFд�Ĵ���Դ
//    output RF_REG_WR;
//    output DM_DOUT;
    
    //�հ����
    wire CLOCK; //ϵͳʱ��
    wire MAIN_CLK; //��ʱ��
    wire PC_RST; //PC�����ź�
    wire [1:0] DATA_SEL; //������ݵ�ѡ��
    wire [7:0] SEG7; //�߶������
    reg [3:0] POS; //�����λѡ
    reg [1:0] COUNT;
    reg [7:0] LEFT; //���������λ
    reg [7:0] RIGHT; //���������λ
    reg [3:0] CURR; //��ǰ4λ���ݣ���Ҫת����8linesȻ�󴫸�SEG7
    
    //regs
    //IM
    reg [31:0] IM_WR_DATA; //IMע��ָ��
    
    //wires
    //CLK
    wire CLK; //��Ƶ���ϵͳʱ��
    //PC
    wire [31:0] PC_;
    wire [31:0] PC4; //PC+4  
    wire [31:0] NEXT_PC; //����ָ��PC
    wire PC_EN; //PCʹ���ź�
    wire [1:0] PC_SRC; //PCԴѡ���ź�
    //IM
    wire IM_RW; //IM��(1)д(0)�ź�
    wire [31:0] IM_OUT_DATA; //IM���ָ��
    //RF
    wire RF_REG_SRC; //RFд�Ĵ���Դѡ���ź�
    wire RF_REG_WR; //RFд�Ĵ���ʹ���ź�
    wire [31:0] RF_RD1; //RF��rs�õ�������
    wire [31:0] RF_RD2; //RF��rt�õ�������
    wire [31:0] RF_WR_DATA; //RFд�Ĵ�������
    wire [4:0] RF_WR_REG; //RFд�Ĵ���Դ
    wire RF_WB; //RFд��ѡ���ź�
    //EXT
    wire EXT_SEL; //EXT��չѡ��ѡ���ź�
    wire [31:0] EXTed_DATA; //EXT��չ��������
    //ALU
    wire ALU_SRC_A; //ALU��A������Դѡ���ź�
    wire ALU_SRC_B; //ALU��B������Դѡ���ź�
    wire [31:0] ALU_OPA; //ALU A������(OP1)
    wire [31:0] ALU_OPB; //ALU B������(OP2)
    wire [4:0] ALU_OP; //ALU������
    wire [31:0] ALU_RES; //ALU������
    wire ALU_ZERO; //ALU��������λ
    wire ALU_SIGN; //ALU����������λ
    //DM
    wire DM_RD; //DM�Ķ��ź�
    wire DM_WR; //DM��д�ź�
    wire [31:0] DM_DOUT; //DM�����
    //ƫ��
    wire [31:0] BRANCH_OFFSET; //��֧ƫ����
//    wire [31:0] J_OFFSET; //��תƫ����
    
    // op IM_OUT_DATA[31:26]
    // rs IM_OUT_DATA[25:21]
    // rt IM_OUT_DATA[20:16]
    // rd IM_OUT_DATA[15:11]
    // shamt IM_OUT_DATA[10:6]
    // funct IM_OUT_DATA[5:0]
    // offset IM_OUT_DATA[15:0]
    // j_offset IM_OUT_DATA[25:0]
    
    // J_OFFSET {PC[3:0],IM_OUT_DATA[25:0],2'b00}
    // BRANCH_OFFSET {EXTed_DATA[29:0],2'b00} + PC4
    
    //��ʼ��
    initial begin
        //�հ����
        COUNT = 0;
        POS = 0;
        LEFT = 0;
        RIGHT = 0;
        CURR = 0;
        //IM
        IM_WR_DATA = 0; //IMע��ָ��
    end
    
    //CLK
    CLOCK_DIV clk_div( CLOCK , CLK ); //��Ƶʱ�ӣ�������ʱ��
    //PC
    adder pc4_adder( PC_ , 4 , PC4 ); //����PC_+4�ļӷ���
    adder pc4_offset_adder( PC4 , {EXTed_DATA[29:0],2'b00} , BRANCH_OFFSET ); // ����PC_+4+offset�ļӷ���
    MUX_2bits pc_src_mux( PC_SRC , PC4 , BRANCH_OFFSET , {PC4[31:28],IM_OUT_DATA[25:0],2'b00} , PC_ , NEXT_PC ); //����PCԴ����·ѡ����
    PC pc( MAIN_CLK , PC_RST , NEXT_PC , PC_EN , PC_ ); //����PC
    //IM
    IM im( IM_RW , PC_ , IM_WR_DATA , IM_OUT_DATA ); //����IM
    //RF
    MUX_1bit_5 rf_reg_src_mux( RF_REG_SRC , IM_OUT_DATA[20:16] , IM_OUT_DATA[15:11] , RF_WR_REG); //RFд�Ĵ���Դѡ��
    RF rf( PC_RST , MAIN_CLK , IM_OUT_DATA[25:21] , IM_OUT_DATA[20:16] , RF_WR_REG , RF_REG_WR , RF_WR_DATA , RF_RD1 , RF_RD2 ); //����RF
    MUX_1bit_32 rf_wb_src_mux( RF_WB , ALU_RES , DM_DOUT , RF_WR_DATA ); // RFд������Դѡ��
    //EXT
    EXT ext( IM_OUT_DATA[15:0] , EXT_SEL , EXTed_DATA ); //����EXT
    //ALU
    MUX_1bit_32 alu_src_a( ALU_SRC_A , RF_RD1 , {27'b0000_0000_0000_0000_0000_0000_000,IM_OUT_DATA[10:6]} , ALU_OPA ); //����ALU��OP1������Դѡ����
    MUX_1bit_32 alu_src_b( ALU_SRC_B , RF_RD2 , EXTed_DATA , ALU_OPB ); //����ALU��OP2������Դѡ����
    ALU alu( ALU_OPA , ALU_OPB , ALU_OP , ALU_SIGN , ALU_ZERO , ALU_RES ); //����ALU
    //DM
    DM dm( ALU_RES , RF_RD2 , DM_RD , DM_WR , MAIN_CLK , DM_DOUT );
    //CU
    CU ctrl_unit( IM_OUT_DATA[31:26] , IM_OUT_DATA[5:0] , ALU_ZERO , ALU_SIGN , PC_RST , IM_RW , PC_EN , EXT_SEL , RF_REG_SRC , RF_REG_WR , ALU_OP , ALU_SRC_A , ALU_SRC_B , PC_SRC , DM_RD , DM_WR , RF_WB );
    
    //�հ����
    always @(posedge CLK) begin
        COUNT <= COUNT + 1;
    end
    always @(DATA_SEL) begin
        case(DATA_SEL)
            2'b00 : {LEFT , RIGHT} <= {PC_[7:0] , NEXT_PC[7:0]};
            2'b01 : {LEFT , RIGHT} <= {3'b000 , IM_OUT_DATA[25:21] , RF_RD1[7:0]};
            2'b10 : {LEFT , RIGHT} <= {3'b000 , IM_OUT_DATA[20:16] , RF_RD2[7:0]};
            2'b11 : {LEFT , RIGHT} <= {ALU_RES[7:0] , RF_WR_DATA[7:0]};
        endcase
    end
    always @(COUNT) begin
        case(COUNT)
            2'b00 : begin
                POS = 4'b1110;
                CURR = RIGHT[3:0];
            end
            2'b01 : begin
                POS = 4'b1101;
                CURR = RIGHT[7:4];
            end
            2'b10 : begin
                POS = 4'b1011;
                CURR = LEFT[3:0];
            end
            2'b11 : begin
                POS = 4'b0111;
                CURR = LEFT[7:4];
            end
        endcase
    end
    FOUR_TO_7SEG fourTo7Seg(CURR , SEG7);
endmodule
