`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/04 20:10:10
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


module CPU(
    CLOCK, //ϵͳʱ��
    MAIN_CLK_RAW, //�ֶ�����ʱ�ӣ�ģ��ʱ������
    PC_RST, //PC�����ź�
    DATA_SEL, //�������ѡ��
    SEG7, //�߶������
    POS //�����λѡ
    );
    
    input CLOCK;
    input MAIN_CLK_RAW;
    input PC_RST;
    input DATA_SEL;
    output SEG7;
    output POS;
    
    //�հ����
    wire CLOCK; //ϵͳʱ��
    wire MAIN_CLK_RAW; //��ʱ��
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
    reg [31:0] IM_WR_DATA; //IMע��ָ������
    
    //wires
    //CLK
    wire CLK; //��Ƶ���ϵͳʱ��
    wire MAIN_CLK; //��������ʱ��
    //PC
    wire [31:0] PC_;
    wire [31:0] PC4; //PC+4  
    wire [31:0] NEXT_PC; //����ָ��PC
    wire PC_EN; //PCʹ���ź�
    wire [1:0] PC_SRC; //PCԴѡ���ź�
    wire [31:0] BRANCH_OFFSET; //��֧ƫ����
    //IM
    wire IM_RW; //IM��(1)д(0)�ź�
    wire [31:0] IM_OUT_DATA; //IM���ָ��
    //IR
    wire IR_WR_EN; //IRдʹ���ź�
    wire [31:0] IR_OUT_DATA; //IR���
    //RF
    wire [1:0] RF_REG_SRC; //RFд�Ĵ���Դѡ���ź�
    wire RF_WR_DATA_SRC; //RFд�Ĵ�������Դѡ���ź�
    wire RF_REG_WR; //RFд�Ĵ���ʹ���ź�
    wire [31:0] RF_RD1; //RF��rs�õ�������
    wire [31:0] RF_RD2; //RF��rt�õ�������
    wire [31:0] RF_WR_DATA; //RFд�Ĵ�������
    wire [4:0] RF_WR_REG; //RFд�Ĵ���Դ
    wire [31:0] ADR_OUT; //rs�Ĵ�����ȡ�������ݴ�ļĴ������
    wire [31:0] BDR_OUT; //rt�Ĵ�����ȡ�������ݴ�ļĴ������
    //EXT
    wire EXT_SEL; //EXT��չѡ��ѡ���ź�
    wire [31:0] EXTed_DATA; //EXT��չ��������
    //ALU
    wire ALU_SRC_A; //ALU��A������Դѡ���ź�
    wire ALU_SRC_B; //ALU��B������Դѡ���ź�
    wire [31:0] ALU_OPA; //ALU A������(OP1)
    wire [31:0] ALU_OPB; //ALU B������(OP2)
    wire [3:0] ALU_OP; //ALU������
    wire [31:0] ALU_RES; //ALU������
    wire ALU_ZERO; //ALU��������λ
    wire ALU_SIGN; //ALU����������λ
    wire [31:0] ALU_RES_DR; //ALU�������ݴ�Ĵ������
    //DM
    wire DM_RD; //DM�Ķ��ź�
    wire DM_WR; //DM��д�ź�
    wire [31:0] DM_DOUT; //DM�����
    wire DB_SRC; //��������ѡ���ź�
    wire [31:0] DB_MUX_DATA; //��������ѡ�������
    wire [31:0] DB_DATA_DR; //�������������ݴ�Ĵ������
    
    //��ʼ��
    initial begin
        //�հ����
        COUNT = 0;
        POS = 0;
        LEFT = 0;
        RIGHT = 0;
        CURR = 0;
        //IM
        IM_WR_DATA = 0;
    end
    
    /*
        ָ��ֶΣ�
         op IR_OUT_DATA[31:26]
         rs IR_OUT_DATA[25:21]
         rt IR_OUT_DATA[20:16]
         rd IR_OUT_DATA[15:11]
         shamt IR_OUT_DATA[10:6]
         funct IR_OUT_DATA[5:0]
         immi/offset IR_OUT_DATA[15:0]
         j_offset IR_OUT_DATA[25:0]
        
         J_OFFSET {PC4[31:28],IR_OUT_DATA[25:0],2'b00}
         BRANCH_OFFSET {EXTed_DATA[29:0],2'b00} + PC4
    */
    
    //������ֺ�����
    //CLK
    CLOCK_DIV clock_div( CLOCK , CLK ); //��Ƶʱ��
    //DEB
    DEBOUNCER deb( MAIN_CLK_RAW , CLOCK , MAIN_CLK ); //������
    //PC
    PC pc( MAIN_CLK , PC_RST , NEXT_PC , PC_EN , PC_ ); //PC������
    Adder adder_for_pc4( PC_ , 4 , PC4 ); //PC+4��adder
    Adder adder_for_offset( PC4 , {EXTed_DATA[29:0] , 2'b00} , BRANCH_OFFSET ); //PC+4+4*offset��adder
    MUX_2bits_32 mux_for_pc_src( PC_SRC , PC4 , BRANCH_OFFSET , RF_RD1 , {PC4[31:28] , 2'b00 , IR_OUT_DATA[25:0]} , NEXT_PC ); //PCԴ��ѡ����
    //IM
    IM ins_mem( IM_RW , PC_ , IM_WR_DATA , IM_OUT_DATA ); //ָ��洢��
    //IR
    DFF ir( IR_WR_EN , MAIN_CLK , IM_OUT_DATA , IR_OUT_DATA ); //ָ���ݴ�Ĵ���
    //RF
    MUX_2bits_5 mux_for_rf_write_reg( RF_REG_SRC , 31 , IR_OUT_DATA[20:16] , IR_OUT_DATA[15:11] , 0 ,RF_WR_REG  ); //RFд�Ĵ���Դ��ѡ����
    MUX_1bit_32 mux_for_rf_write_data( RF_WR_DATA_SRC , PC4 , DB_DATA_DR , RF_WR_DATA ); //RFд����Դ��ѡ����
    RF rf( PC_RST , MAIN_CLK , IR_OUT_DATA[25:21] , IR_OUT_DATA[20:16] , RF_WR_REG , RF_REG_WR , RF_WR_DATA , RF_RD1 , RF_RD2 ); //�Ĵ�����
    DFF adr( 1 , MAIN_CLK , RF_RD1 , ADR_OUT ); //rs�Ĵ��������ݵ��ݴ�Ĵ���
    DFF bdr( 1 , MAIN_CLK , RF_RD2 , BDR_OUT ); //rt�Ĵ��������ݵ��ݴ�Ĵ���
    //EXT
    EXT ext( IR_OUT_DATA[15:0] , EXT_SEL , EXTed_DATA ); //��������չ��
    //ALU
    MUX_1bit_32 opa( ALU_SRC_A , ADR_OUT , { 27'b000000000_000000000_000000000 , IR_OUT_DATA[10:6] } , ALU_OPA ); //ALU�������
    MUX_1bit_32 opb( ALU_SRC_B , BDR_OUT , EXTed_DATA , ALU_OPB ); //�Ҳ�����
    ALU alu( ALU_OPA , ALU_OPB , ALU_OP , ALU_SIGN , ALU_ZERO , ALU_RES ); //���㵥Ԫ
    DFF dff_for_alu_res( 1 , MAIN_CLK , ALU_RES , ALU_RES_DR ); //ALU����ݴ�Ĵ���
    //DM
    DM dm( ALU_RES_DR , BDR_OUT , DM_RD , DM_WR , MAIN_CLK , DM_DOUT  ); //���ݴ洢��
    MUX_1bit_32 mux_for_db_data( DB_SRC , ALU_RES , DM_DOUT , DB_MUX_DATA ); //������������Դѡ��
    DFF dff_for_db( 1 , MAIN_CLK , DB_MUX_DATA , DB_DATA_DR ); //�����������ݵ��ݴ�Ĵ���
    //CU
    CU ctrl_unit( MAIN_CLK , PC_RST , ALU_ZERO , ALU_SIGN , IM_OUT_DATA[31:26] , IM_OUT_DATA[5:0] , IM_RW , PC_EN , IR_WR_EN , EXT_SEL , RF_REG_SRC
     , RF_REG_WR , ALU_OP , ALU_SRC_A , ALU_SRC_B , PC_SRC , DM_RD , DM_WR , DB_SRC , RF_WR_DATA_SRC ); //���Ƶ�Ԫ
    
    //�հ����(�������ʾ)
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
