`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/27 20:30:50
// Design Name: 
// Module Name: test
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

// Verilog 1995 style port declaration
module design_ip  ( addr,
                    wdata,
                    write,
                    sel,
                    rdata);

     parameter  BUS_WIDTH    = 32,
                DATA_WIDTH   = 64,
                FIFO_DEPTH   = 512;

     input addr;
     input wdata;
     input write;
     input sel;
     output rdata;

     wire [BUS_WIDTH-1:0] addr;
     wire [DATA_WIDTH-1:0] wdata;
     reg  [DATA_WIDTH-1:0] rdata;


     // Design code goes here ...
endmodule

