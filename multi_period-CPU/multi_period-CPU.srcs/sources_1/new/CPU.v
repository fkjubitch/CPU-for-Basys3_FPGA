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
    CLOCK, //系统时钟
    MAIN_CLK_RAW, //手动开关时钟，模拟时钟周期
    PC_RST, //PC重置信号
    DATA_SEL, //输出数据选择
    SEG7, //七段数码管
    POS //数码管位选
    );
    
    input CLOCK;
    input MAIN_CLK_RAW;
    input PC_RST;
    input DATA_SEL;
    output SEG7;
    output POS;
    
    //烧板相关
    wire CLOCK; //系统时钟
    wire MAIN_CLK_RAW; //主时钟
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
    reg [31:0] IM_WR_DATA; //IM注入指令数据
    
    //wires
    //CLK
    wire CLK; //分频后的系统时钟
    wire MAIN_CLK; //减震后的主时钟
    //PC
    wire [31:0] PC_;
    wire [31:0] PC4; //PC+4  
    wire [31:0] NEXT_PC; //下条指令PC
    wire PC_EN; //PC使能信号
    wire [1:0] PC_SRC; //PC源选择信号
    wire [31:0] BRANCH_OFFSET; //分支偏移量
    //IM
    wire IM_RW; //IM读(1)写(0)信号
    wire [31:0] IM_OUT_DATA; //IM输出指令
    //IR
    wire IR_WR_EN; //IR写使能信号
    wire [31:0] IR_OUT_DATA; //IR输出
    //RF
    wire [1:0] RF_REG_SRC; //RF写寄存器源选择信号
    wire RF_WR_DATA_SRC; //RF写寄存器数据源选择信号
    wire RF_REG_WR; //RF写寄存器使能信号
    wire [31:0] RF_RD1; //RF读rs得到的内容
    wire [31:0] RF_RD2; //RF读rt得到的内容
    wire [31:0] RF_WR_DATA; //RF写寄存器数据
    wire [4:0] RF_WR_REG; //RF写寄存器源
    wire [31:0] ADR_OUT; //rs寄存器读取的数据暂存的寄存器输出
    wire [31:0] BDR_OUT; //rt寄存器读取的数据暂存的寄存器输出
    //EXT
    wire EXT_SEL; //EXT扩展选项选择信号
    wire [31:0] EXTed_DATA; //EXT扩展过的数据
    //ALU
    wire ALU_SRC_A; //ALU的A操作数源选择信号
    wire ALU_SRC_B; //ALU的B操作数源选择信号
    wire [31:0] ALU_OPA; //ALU A操作数(OP1)
    wire [31:0] ALU_OPB; //ALU B操作数(OP2)
    wire [3:0] ALU_OP; //ALU操作码
    wire [31:0] ALU_RES; //ALU计算结果
    wire ALU_ZERO; //ALU计算结果零位
    wire ALU_SIGN; //ALU计算结果符号位
    wire [31:0] ALU_RES_DR; //ALU运算结果暂存寄存器输出
    //DM
    wire DM_RD; //DM的读信号
    wire DM_WR; //DM的写信号
    wire [31:0] DM_DOUT; //DM读输出
    wire DB_SRC; //数据总线选择信号
    wire [31:0] DB_MUX_DATA; //数据总线选择器输出
    wire [31:0] DB_DATA_DR; //数据总线数据暂存寄存器输出
    
    //初始化
    initial begin
        //烧板相关
        COUNT = 0;
        POS = 0;
        LEFT = 0;
        RIGHT = 0;
        CURR = 0;
        //IM
        IM_WR_DATA = 0;
    end
    
    /*
        指令分段：
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
    
    //创建组分和连接
    //CLK
    CLOCK_DIV clock_div( CLOCK , CLK ); //分频时钟
    //DEB
    DEBOUNCER deb( MAIN_CLK_RAW , CLOCK , MAIN_CLK ); //减震器
    //PC
    PC pc( MAIN_CLK , PC_RST , NEXT_PC , PC_EN , PC_ ); //PC计数器
    Adder adder_for_pc4( PC_ , 4 , PC4 ); //PC+4的adder
    Adder adder_for_offset( PC4 , {EXTed_DATA[29:0] , 2'b00} , BRANCH_OFFSET ); //PC+4+4*offset的adder
    MUX_2bits_32 mux_for_pc_src( PC_SRC , PC4 , BRANCH_OFFSET , RF_RD1 , {PC4[31:28] , 2'b00 , IR_OUT_DATA[25:0]} , NEXT_PC ); //PC源的选择器
    //IM
    IM ins_mem( IM_RW , PC_ , IM_WR_DATA , IM_OUT_DATA ); //指令存储器
    //IR
    DFF ir( IR_WR_EN , MAIN_CLK , IM_OUT_DATA , IR_OUT_DATA ); //指令暂存寄存器
    //RF
    MUX_2bits_5 mux_for_rf_write_reg( RF_REG_SRC , 31 , IR_OUT_DATA[20:16] , IR_OUT_DATA[15:11] , 0 ,RF_WR_REG  ); //RF写寄存器源的选择器
    MUX_1bit_32 mux_for_rf_write_data( RF_WR_DATA_SRC , PC4 , DB_DATA_DR , RF_WR_DATA ); //RF写数据源的选择器
    RF rf( PC_RST , MAIN_CLK , IR_OUT_DATA[25:21] , IR_OUT_DATA[20:16] , RF_WR_REG , RF_REG_WR , RF_WR_DATA , RF_RD1 , RF_RD2 ); //寄存器堆
    DFF adr( 1 , MAIN_CLK , RF_RD1 , ADR_OUT ); //rs寄存器读数据的暂存寄存器
    DFF bdr( 1 , MAIN_CLK , RF_RD2 , BDR_OUT ); //rt寄存器读数据的暂存寄存器
    //EXT
    EXT ext( IR_OUT_DATA[15:0] , EXT_SEL , EXTed_DATA ); //立即数拓展器
    //ALU
    MUX_1bit_32 opa( ALU_SRC_A , ADR_OUT , { 27'b000000000_000000000_000000000 , IR_OUT_DATA[10:6] } , ALU_OPA ); //ALU左操作数
    MUX_1bit_32 opb( ALU_SRC_B , BDR_OUT , EXTed_DATA , ALU_OPB ); //右操作数
    ALU alu( ALU_OPA , ALU_OPB , ALU_OP , ALU_SIGN , ALU_ZERO , ALU_RES ); //运算单元
    DFF dff_for_alu_res( 1 , MAIN_CLK , ALU_RES , ALU_RES_DR ); //ALU结果暂存寄存器
    //DM
    DM dm( ALU_RES_DR , BDR_OUT , DM_RD , DM_WR , MAIN_CLK , DM_DOUT  ); //数据存储器
    MUX_1bit_32 mux_for_db_data( DB_SRC , ALU_RES , DM_DOUT , DB_MUX_DATA ); //数据总线数据源选择
    DFF dff_for_db( 1 , MAIN_CLK , DB_MUX_DATA , DB_DATA_DR ); //数据总线数据的暂存寄存器
    //CU
    CU ctrl_unit( MAIN_CLK , PC_RST , ALU_ZERO , ALU_SIGN , IM_OUT_DATA[31:26] , IM_OUT_DATA[5:0] , IM_RW , PC_EN , IR_WR_EN , EXT_SEL , RF_REG_SRC
     , RF_REG_WR , ALU_OP , ALU_SRC_A , ALU_SRC_B , PC_SRC , DM_RD , DM_WR , DB_SRC , RF_WR_DATA_SRC ); //控制单元
    
    //烧板相关(数码管显示)
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
