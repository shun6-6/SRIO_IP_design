`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/24 11:54:14
// Design Name: 
// Module Name: SIM_tb_TB
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


module SIM_tb_TB(

);

reg             i_sys_clk_p     ;
wire            i_sys_clk_n     ;
reg             i_gtref_clk_p   ;
wire            i_gtref_clk_n   ;

wire [1 :0]     w_gtref_tx_p    ;   
wire [1 :0]     w_gtref_tx_n    ;   

assign i_sys_clk_n = ~i_sys_clk_p;
assign i_gtref_clk_n = ~i_gtref_clk_p;

always
begin
    i_sys_clk_p = 'd0;
    #5;
    i_sys_clk_p = 'd1;
    #5;
end

always
begin
    i_gtref_clk_p = 'd0;
    #3.2;
    i_gtref_clk_p = 'd1;
    #3.2;
end

XC7Z100 XC7Z100_U0(
    .i_sys_clk_p            (i_sys_clk_p    ),
    .i_sys_clk_n            (i_sys_clk_n    ),
    .i_gt_refclk_p          (i_gtref_clk_p  ),
    .i_gt_refclk_n          (i_gtref_clk_n  ),

    .o_srio_txn            (w_gtref_tx_p   ),
    .o_srio_txp            (w_gtref_tx_n   ),
    .i_srio_rxn            (w_gtref_tx_p   ),
    .i_srio_rxp            (w_gtref_tx_n   )
);

endmodule
