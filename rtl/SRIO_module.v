`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/07 21:59:21
// Design Name: 
// Module Name: SRIO_module
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


module SRIO_module#(
    parameter               P_LINE_NUM = 2          
)(
    input                   i_gtref_clk             ,
    input                   i_rst                   ,
    input                   i_sim_train_en          ,

    output [P_LINE_NUM-1:0] o_srio_txn              ,
    output [P_LINE_NUM-1:0] o_srio_txp              ,
    input  [P_LINE_NUM-1:0] i_srio_rxn              ,         
    input  [P_LINE_NUM-1:0] i_srio_rxp              , 

    output                  o_1_gtrx_disperr_or     ,
    output                  o_1_gtrx_notintable_or  ,
    output                  o_1_port_error          ,     
    input                   s_1_axis_ireq_tvalid    , 
    output                  s_1_axis_ireq_tready    , 
    input                   s_1_axis_ireq_tlast     , 
    input  [63:0]           s_1_axis_ireq_tdata     , 
    input  [7 :0]           s_1_axis_ireq_tkeep     , 
    input  [31:0]           s_1_axis_ireq_tuser     , 
    output                  m_1_axis_iresp_tvalid   , 
    input                   m_1_axis_iresp_tready   , 
    output                  m_1_axis_iresp_tlast    , 
    output [63:0]           m_1_axis_iresp_tdata    , 
    output [7 :0]           m_1_axis_iresp_tkeep    , 
    output [31:0]           m_1_axis_iresp_tuser    , 
    output                  m_1_axis_treq_tvalid    , 
    input                   m_1_axis_treq_tready    , 
    output                  m_1_axis_treq_tlast     , 
    output [63:0]           m_1_axis_treq_tdata     , 
    output [7 :0]           m_1_axis_treq_tkeep     , 
    output [31:0]           m_1_axis_treq_tuser     , 
    input                   s_1_axis_tresp_tvalid   , 
    output                  s_1_axis_tresp_tready   , 
    input                   s_1_axis_tresp_tlast    , 
    input  [63:0]           s_1_axis_tresp_tdata    , 
    input  [7 :0]           s_1_axis_tresp_tkeep    , 
    input  [31:0]           s_1_axis_tresp_tuser    , 
    output                  o_1_log_clk             ,
    output                  o_1_log_rst             ,
    output                  o_1_port_initialized    ,

    output                  o_2_gtrx_disperr_or     ,
    output                  o_2_gtrx_notintable_or  ,
    output                  o_2_port_error          ,    
    input                   s_2_axis_ireq_tvalid    , 
    output                  s_2_axis_ireq_tready    , 
    input                   s_2_axis_ireq_tlast     , 
    input  [63:0]           s_2_axis_ireq_tdata     , 
    input  [7 :0]           s_2_axis_ireq_tkeep     , 
    input  [31:0]           s_2_axis_ireq_tuser     , 
    output                  m_2_axis_iresp_tvalid   , 
    input                   m_2_axis_iresp_tready   , 
    output                  m_2_axis_iresp_tlast    , 
    output [63:0]           m_2_axis_iresp_tdata    , 
    output [7 :0]           m_2_axis_iresp_tkeep    , 
    output [31:0]           m_2_axis_iresp_tuser    , 
    output                  m_2_axis_treq_tvalid    , 
    input                   m_2_axis_treq_tready    , 
    output                  m_2_axis_treq_tlast     , 
    output [63:0]           m_2_axis_treq_tdata     , 
    output [7 :0]           m_2_axis_treq_tkeep     , 
    output [31:0]           m_2_axis_treq_tuser     , 
    input                   s_2_axis_tresp_tvalid   , 
    output                  s_2_axis_tresp_tready   , 
    input                   s_2_axis_tresp_tlast    , 
    input  [63:0]           s_2_axis_tresp_tdata    , 
    input  [7 :0]           s_2_axis_tresp_tkeep    , 
    input  [31:0]           s_2_axis_tresp_tuser    ,
    output                  o_2_log_clk             ,
    output                  o_2_log_rst             ,
    output                  o_2_port_initialized      
);

wire                    gt0_qpll_clk_out        ;
wire                    gt0_qpll_out_refclk_out ;
wire                    gt0_qpll_lock_out       ;

srio_gen2_0_k7_v7_gtxe2_common   k7_v7_gtxe2_common_inst
(
    .gt0_gtrefclk0_common_in    (i_gtref_clk                ),
    .gt0_qplllockdetclk_in      (0                          ),
    .gt0_qpllreset_in           (0                          ),
    .qpll_clk_out               (gt0_qpll_clk_out           ),
    .qpll_out_refclk_out        (gt0_qpll_out_refclk_out    ),
    .gt0_qpll_lock_out          (gt0_qpll_lock_out          ) 
);  

SRIO_channel SRIO_channel_u0(   
    .i_gtref_clk                (i_gtref_clk                ),
    .i_rst                      (i_rst                      ),
    .gt0_qpll_clk_in            (gt0_qpll_clk_out           ),
    .gt0_qpll_out_refclk_in     (gt0_qpll_out_refclk_out    ),
    .gt0_qpll_lock_in           (gt0_qpll_lock_out          ),
    .i_sim_train_en             (i_sim_train_en             ),
    .o_gtrx_disperr_or          (o_1_gtrx_disperr_or        ),
    .o_gtrx_notintable_or       (o_1_gtrx_notintable_or     ),
    .o_port_error               (o_1_port_error             ),
    .o_srio_txn0                (o_srio_txn[0]              ),
    .o_srio_txp0                (o_srio_txp[0]              ),
    .i_srio_rxn0                (i_srio_rxn[0]              ),
    .i_srio_rxp0                (i_srio_rxp[0]              ),

    .s_axis_ireq_tvalid         (s_1_axis_ireq_tvalid       ), 
    .s_axis_ireq_tready         (s_1_axis_ireq_tready       ), 
    .s_axis_ireq_tlast          (s_1_axis_ireq_tlast        ), 
    .s_axis_ireq_tdata          (s_1_axis_ireq_tdata        ), 
    .s_axis_ireq_tkeep          (s_1_axis_ireq_tkeep        ), 
    .s_axis_ireq_tuser          (s_1_axis_ireq_tuser        ), 
    .m_axis_iresp_tvalid        (m_1_axis_iresp_tvalid      ), 
    .m_axis_iresp_tready        (m_1_axis_iresp_tready      ), 
    .m_axis_iresp_tlast         (m_1_axis_iresp_tlast       ), 
    .m_axis_iresp_tdata         (m_1_axis_iresp_tdata       ), 
    .m_axis_iresp_tkeep         (m_1_axis_iresp_tkeep       ), 
    .m_axis_iresp_tuser         (m_1_axis_iresp_tuser       ), 

    .m_axis_treq_tvalid         (m_1_axis_treq_tvalid       ), 
    .m_axis_treq_tready         (m_1_axis_treq_tready       ), 
    .m_axis_treq_tlast          (m_1_axis_treq_tlast        ), 
    .m_axis_treq_tdata          (m_1_axis_treq_tdata        ), 
    .m_axis_treq_tkeep          (m_1_axis_treq_tkeep        ), 
    .m_axis_treq_tuser          (m_1_axis_treq_tuser        ), 
    .s_axis_tresp_tvalid        (s_1_axis_tresp_tvalid      ), 
    .s_axis_tresp_tready        (s_1_axis_tresp_tready      ), 
    .s_axis_tresp_tlast         (s_1_axis_tresp_tlast       ), 
    .s_axis_tresp_tdata         (s_1_axis_tresp_tdata       ), 
    .s_axis_tresp_tkeep         (s_1_axis_tresp_tkeep       ), 
    .s_axis_tresp_tuser         (s_1_axis_tresp_tuser       ),
    .o_log_clk                  (o_1_log_clk                ),
    .o_log_rst                  (o_1_log_rst                ),
    .o_port_initialized         (o_1_port_initialized       )
);

SRIO_channel SRIO_channel_u1(
    .i_gtref_clk                (i_gtref_clk                ),
    .i_rst                      (i_rst                      ),
    .gt0_qpll_clk_in            (gt0_qpll_clk_out           ),
    .gt0_qpll_out_refclk_in     (gt0_qpll_out_refclk_out    ),
    .gt0_qpll_lock_in           (gt0_qpll_lock_out          ),
    .i_sim_train_en             (i_sim_train_en             ),
    .o_gtrx_disperr_or          (o_2_gtrx_disperr_or        ),
    .o_gtrx_notintable_or       (o_2_gtrx_notintable_or     ),
    .o_port_error               (o_2_port_error             ),
    .o_srio_txn0                (o_srio_txn[1]              ),
    .o_srio_txp0                (o_srio_txp[1]              ),
    .i_srio_rxn0                (i_srio_rxn[1]              ),
    .i_srio_rxp0                (i_srio_rxp[1]              ),

    .s_axis_ireq_tvalid         (s_2_axis_ireq_tvalid       ), 
    .s_axis_ireq_tready         (s_2_axis_ireq_tready       ), 
    .s_axis_ireq_tlast          (s_2_axis_ireq_tlast        ), 
    .s_axis_ireq_tdata          (s_2_axis_ireq_tdata        ), 
    .s_axis_ireq_tkeep          (s_2_axis_ireq_tkeep        ), 
    .s_axis_ireq_tuser          (s_2_axis_ireq_tuser        ), 
    .m_axis_iresp_tvalid        (m_2_axis_iresp_tvalid      ), 
    .m_axis_iresp_tready        (m_2_axis_iresp_tready      ), 
    .m_axis_iresp_tlast         (m_2_axis_iresp_tlast       ), 
    .m_axis_iresp_tdata         (m_2_axis_iresp_tdata       ), 
    .m_axis_iresp_tkeep         (m_2_axis_iresp_tkeep       ), 
    .m_axis_iresp_tuser         (m_2_axis_iresp_tuser       ), 

    .m_axis_treq_tvalid         (m_2_axis_treq_tvalid       ), 
    .m_axis_treq_tready         (m_2_axis_treq_tready       ), 
    .m_axis_treq_tlast          (m_2_axis_treq_tlast        ), 
    .m_axis_treq_tdata          (m_2_axis_treq_tdata        ), 
    .m_axis_treq_tkeep          (m_2_axis_treq_tkeep        ), 
    .m_axis_treq_tuser          (m_2_axis_treq_tuser        ), 
    .s_axis_tresp_tvalid        (s_2_axis_tresp_tvalid      ), 
    .s_axis_tresp_tready        (s_2_axis_tresp_tready      ), 
    .s_axis_tresp_tlast         (s_2_axis_tresp_tlast       ), 
    .s_axis_tresp_tdata         (s_2_axis_tresp_tdata       ), 
    .s_axis_tresp_tkeep         (s_2_axis_tresp_tkeep       ), 
    .s_axis_tresp_tuser         (s_2_axis_tresp_tuser       ),
    .o_log_clk                  (o_2_log_clk                ),
    .o_log_rst                  (o_2_log_rst                ),
    .o_port_initialized         (o_2_port_initialized       )
);

endmodule
