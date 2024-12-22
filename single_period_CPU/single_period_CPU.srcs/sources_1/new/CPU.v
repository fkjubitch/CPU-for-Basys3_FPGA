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
    CLOCK, //系统时钟
    MAIN_CLK, //手动开关时钟，模拟时钟周期
    PC_RST, //PC重置信号
    DATA_SEL, //输出数据选择
    SEG7, //七段数码管
    POS //数码管位选
//    PC_, //PC
//    IM_OUT_DATA,
//    ALU_RES, //ALU计算结果
//    ALU_ZERO, //ALU计算结果零位
//    ALU_SIGN, //ALU计算结果符号位
//    RF_REG_SRC, //RF写寄存器源选择信号
//    RF_RD1, //RF读rs得到的内容
//    RF_RD2, //RF读rt得到的内容
//    RF_WR_DATA, //RF写寄存器数据
//    RF_WR_REG, //RF写寄存器源
//    RF_REG_WR, //RF写使能信号
//    DM_DOUT //DM读输出
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
//    output RF_WR_DATA; //RF写寄存器数据
//    output RF_WR_REG; //RF写寄存器源
//    output RF_REG_WR;
//    output DM_DOUT;
    
    //烧板相关
    wire CLOCK; //系统时钟
    wire MAIN_CLK; //主时钟
    wire PC_RST; //PC重置信号
    wire [1:0] DATA_SEL; //输出数据的选择
    wire [7:0] SEG7; //七段数码管
    reg [3:0] POS; //数码管位选
    reg [1:0] COUNT;
    reg [7:0] LEFT; //数码管左两位
    reg [7:0] RIGHT; //数码管右两位
    reg [3:0] CURR; //当前4位数据，需要转换成8lines然后传给SEG7
    
    //regs
    //IM
    reg [31:0] IM_WR_DATA; //IM注入指令
    
    //wires
    //CLK
    wire CLK; //分频后的系统时钟
    //PC
    wire [31:0] PC_;
    wire [31:0] PC4; //PC+4  
    wire [31:0] NEXT_PC; //下条指令PC
    wire PC_EN; //PC使能信号
    wire [1:0] PC_SRC; //PC源选择信号
    //IM
    wire IM_RW; //IM读(1)写(0)信号
    wire [31:0] IM_OUT_DATA; //IM输出指令
    //RF
    wire RF_REG_SRC; //RF写寄存器源选择信号
    wire RF_REG_WR; //RF写寄存器使能信号
    wire [31:0] RF_RD1; //RF读rs得到的内容
    wire [31:0] RF_RD2; //RF读rt得到的内容
    wire [31:0] RF_WR_DATA; //RF写寄存器数据
    wire [4:0] RF_WR_REG; //RF写寄存器源
    wire RF_WB; //RF写回选择信号
    //EXT
    wire EXT_SEL; //EXT扩展选项选择信号
    wire [31:0] EXTed_DATA; //EXT扩展过的数据
    //ALU
    wire ALU_SRC_A; //ALU的A操作数源选择信号
    wire ALU_SRC_B; //ALU的B操作数源选择信号
    wire [31:0] ALU_OPA; //ALU A操作数(OP1)
    wire [31:0] ALU_OPB; //ALU B操作数(OP2)
    wire [4:0] ALU_OP; //ALU操作码
    wire [31:0] ALU_RES; //ALU计算结果
    wire ALU_ZERO; //ALU计算结果零位
    wire ALU_SIGN; //ALU计算结果符号位
    //DM
    wire DM_RD; //DM的读信号
    wire DM_WR; //DM的写信号
    wire [31:0] DM_DOUT; //DM读输出
    //偏移
    wire [31:0] BRANCH_OFFSET; //分支偏移量
//    wire [31:0] J_OFFSET; //跳转偏移量
    
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
    
    //初始化
    initial begin
        //烧板相关
        COUNT = 0;
        POS = 0;
        LEFT = 0;
        RIGHT = 0;
        CURR = 0;
        //IM
        IM_WR_DATA = 0; //IM注入指令
    end
    
    //CLK
    CLOCK_DIV clk_div( CLOCK , CLK ); //分频时钟，生成主时钟
    //PC
    adder pc4_adder( PC_ , 4 , PC4 ); //创建PC_+4的加法器
    adder pc4_offset_adder( PC4 , {EXTed_DATA[29:0],2'b00} , BRANCH_OFFSET ); // 创建PC_+4+offset的加法器
    MUX_2bits pc_src_mux( PC_SRC , PC4 , BRANCH_OFFSET , {PC4[31:28],IM_OUT_DATA[25:0],2'b00} , PC_ , NEXT_PC ); //创建PC源的四路选择器
    PC pc( MAIN_CLK , PC_RST , NEXT_PC , PC_EN , PC_ ); //创建PC
    //IM
    IM im( IM_RW , PC_ , IM_WR_DATA , IM_OUT_DATA ); //创建IM
    //RF
    MUX_1bit_5 rf_reg_src_mux( RF_REG_SRC , IM_OUT_DATA[20:16] , IM_OUT_DATA[15:11] , RF_WR_REG); //RF写寄存器源选择
    RF rf( PC_RST , MAIN_CLK , IM_OUT_DATA[25:21] , IM_OUT_DATA[20:16] , RF_WR_REG , RF_REG_WR , RF_WR_DATA , RF_RD1 , RF_RD2 ); //创建RF
    MUX_1bit_32 rf_wb_src_mux( RF_WB , ALU_RES , DM_DOUT , RF_WR_DATA ); // RF写回数据源选择
    //EXT
    EXT ext( IM_OUT_DATA[15:0] , EXT_SEL , EXTed_DATA ); //创建EXT
    //ALU
    MUX_1bit_32 alu_src_a( ALU_SRC_A , RF_RD1 , {27'b0000_0000_0000_0000_0000_0000_000,IM_OUT_DATA[10:6]} , ALU_OPA ); //创建ALU的OP1操作数源选择器
    MUX_1bit_32 alu_src_b( ALU_SRC_B , RF_RD2 , EXTed_DATA , ALU_OPB ); //创建ALU的OP2操作数源选择器
    ALU alu( ALU_OPA , ALU_OPB , ALU_OP , ALU_SIGN , ALU_ZERO , ALU_RES ); //创建ALU
    //DM
    DM dm( ALU_RES , RF_RD2 , DM_RD , DM_WR , MAIN_CLK , DM_DOUT );
    //CU
    CU ctrl_unit( IM_OUT_DATA[31:26] , IM_OUT_DATA[5:0] , ALU_ZERO , ALU_SIGN , PC_RST , IM_RW , PC_EN , EXT_SEL , RF_REG_SRC , RF_REG_WR , ALU_OP , ALU_SRC_A , ALU_SRC_B , PC_SRC , DM_RD , DM_WR , RF_WB );
    
    //烧板相关
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
