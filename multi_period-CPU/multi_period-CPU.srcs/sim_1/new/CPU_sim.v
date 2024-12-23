`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/23 20:31:53
// Design Name: 
// Module Name: CPU_sim
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

module CPU_sim();

reg [2:0] count;
reg CLOCK;
reg MAIN_CLK;
reg PC_RST;
reg [1:0] DATA_SEL;
wire [7:0] SEG7;
wire [3:0] POS;

initial begin
    count = 0;
    CLOCK = 0;
    MAIN_CLK = 0;
    PC_RST = 0;
    DATA_SEL = 0;
    #50;
    while(1) begin
        for(count = 0 ; count < 4 ; count = count + 1) begin
            DATA_SEL = DATA_SEL + 1;
            #30;
        end
        MAIN_CLK = 1;
        #30;
        MAIN_CLK = 0;
    end
end

always #1 CLOCK = ~CLOCK;

CPU cpu(
    CLOCK,
    MAIN_CLK,
    PC_RST,
    DATA_SEL,
    SEG7,
    POS
);

endmodule
