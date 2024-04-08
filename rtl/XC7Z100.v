`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/07 21:59:21
// Design Name: 
// Module Name: XC7Z100
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


module XC7Z100#(
    parameter               P_LINE_NUM = 2          
)(
    input                   i_gt_refclk_p       ,
    input                   i_gt_refclk_n       ,

    input                   i_sys_clk_p         ,
    input                   i_sys_clk_n         ,

    output [P_LINE_NUM-1:0] o_srio_txn          ,
    output [P_LINE_NUM-1:0] o_srio_txp          ,
    input  [P_LINE_NUM-1:0] i_srio_rxn          ,         
    input  [P_LINE_NUM-1:0] i_srio_rxp          ,

    output [P_LINE_NUM-1:0] o_sfp_disable       

);
assign o_sfp_disable = 2'b00;

wire            w_gt_refclk             ;
wire            w_1_gtrx_disperr_or     ; 
wire            w_1_gtrx_notintable_or  ; 
wire            w_1_port_error          ; 
(* MARK_DEBUG = "TRUE" *)wire            s_1_axis_ireq_tvalid    ; 
(* MARK_DEBUG = "TRUE" *)wire            s_1_axis_ireq_tready    ; 
(* MARK_DEBUG = "TRUE" *)wire            s_1_axis_ireq_tlast     ; 
(* MARK_DEBUG = "TRUE" *)wire [63:0]     s_1_axis_ireq_tdata     ; 
(* MARK_DEBUG = "TRUE" *)wire [7 :0]     s_1_axis_ireq_tkeep     ; 
(* MARK_DEBUG = "TRUE" *)wire [31:0]     s_1_axis_ireq_tuser     ; 
(* MARK_DEBUG = "TRUE" *)wire            m_1_axis_iresp_tvalid   ; 
(* MARK_DEBUG = "TRUE" *)wire            m_1_axis_iresp_tready   ; 
(* MARK_DEBUG = "TRUE" *)wire            m_1_axis_iresp_tlast    ; 
(* MARK_DEBUG = "TRUE" *)wire [63:0]     m_1_axis_iresp_tdata    ; 
(* MARK_DEBUG = "TRUE" *)wire [7 :0]     m_1_axis_iresp_tkeep    ; 
(* MARK_DEBUG = "TRUE" *)wire [31:0]     m_1_axis_iresp_tuser    ; 
(* MARK_DEBUG = "TRUE" *)wire            m_1_axis_treq_tvalid    ; 
(* MARK_DEBUG = "TRUE" *)wire            m_1_axis_treq_tready    ; 
(* MARK_DEBUG = "TRUE" *)wire            m_1_axis_treq_tlast     ; 
(* MARK_DEBUG = "TRUE" *)wire [63:0]     m_1_axis_treq_tdata     ; 
(* MARK_DEBUG = "TRUE" *)wire [7 :0]     m_1_axis_treq_tkeep     ; 
(* MARK_DEBUG = "TRUE" *)wire [31:0]     m_1_axis_treq_tuser     ; 
(* MARK_DEBUG = "TRUE" *)wire            s_1_axis_tresp_tvalid   ; 
(* MARK_DEBUG = "TRUE" *)wire            s_1_axis_tresp_tready   ; 
(* MARK_DEBUG = "TRUE" *)wire            s_1_axis_tresp_tlast    ; 
(* MARK_DEBUG = "TRUE" *)wire [63:0]     s_1_axis_tresp_tdata    ; 
(* MARK_DEBUG = "TRUE" *)wire [7 :0]     s_1_axis_tresp_tkeep    ; 
(* MARK_DEBUG = "TRUE" *)wire [31:0]     s_1_axis_tresp_tuser    ; 
wire            w_1_log_clk             ; 
wire            w_1_log_rst             ; 
wire            w_1_port_initialized    ; 
wire            w_2_gtrx_disperr_or     ; 
wire            w_2_gtrx_notintable_or  ; 
wire            w_2_port_error          ; 
wire            s_2_axis_ireq_tvalid    ; 
wire            s_2_axis_ireq_tready    ; 
wire            s_2_axis_ireq_tlast     ; 
wire [63:0]     s_2_axis_ireq_tdata     ; 
wire [7 :0]     s_2_axis_ireq_tkeep     ; 
wire [31:0]     s_2_axis_ireq_tuser     ; 
wire            m_2_axis_iresp_tvalid   ; 
wire            m_2_axis_iresp_tready   ; 
wire            m_2_axis_iresp_tlast    ; 
wire [63:0]     m_2_axis_iresp_tdata    ; 
wire [7 :0]     m_2_axis_iresp_tkeep    ; 
wire [31:0]     m_2_axis_iresp_tuser    ; 
wire            m_2_axis_treq_tvalid    ; 
wire            m_2_axis_treq_tready    ; 
wire            m_2_axis_treq_tlast     ; 
wire [63:0]     m_2_axis_treq_tdata     ; 
wire [7 :0]     m_2_axis_treq_tkeep     ; 
wire [31:0]     m_2_axis_treq_tuser     ; 
wire            s_2_axis_tresp_tvalid   ; 
wire            s_2_axis_tresp_tready   ; 
wire            s_2_axis_tresp_tlast    ; 
wire [63:0]     s_2_axis_tresp_tdata    ; 
wire [7 :0]     s_2_axis_tresp_tkeep    ; 
wire [31:0]     s_2_axis_tresp_tuser    ; 
wire            w_2_log_clk             ; 
wire            w_2_log_rst             ; 
wire            w_2_port_initialized    ; 
wire            w_sys_clk               ;
wire            w_sys_rst               ;

IBUFDS #(
    .DIFF_TERM                      ("FALSE"                ),
    .IBUF_LOW_PWR                   ("TRUE"                 ),
    .IOSTANDARD                     ("DEFAULT"              ) 
)               
IBUFDS_U0 (             
    .O                              (w_sys_clk              ),
    .I                              (i_sys_clk_p            ),
    .IB                             (i_sys_clk_n            ) 
);

rst_gen_module#(
    .P_RST_CYCLE                    (50                     )   
)                   
rst_gen_module_u0                   
(                   
    .i_clk                          (w_sys_clk              ),
    .o_rst                          (w_sys_rst              )
);


IBUFDS_GTE2 u_refclk_ibufds(
    .O      (w_gt_refclk    ),
    .I      (i_gt_refclk_p  ),
    .IB     (i_gt_refclk_n  ),
    .CEB    (1'b0),
    .ODIV2  ()
);

SRIO_engine SRIO_engine_u0(
    .i_clk                          (w_1_log_clk            ),
    .i_rst                          (w_1_log_rst | ~w_1_port_initialized ),

    .m_axis_ireq_tvalid             (s_1_axis_ireq_tvalid   ), 
    .m_axis_ireq_tready             (s_1_axis_ireq_tready   ), 
    .m_axis_ireq_tlast              (s_1_axis_ireq_tlast    ), 
    .m_axis_ireq_tdata              (s_1_axis_ireq_tdata    ), 
    .m_axis_ireq_tkeep              (s_1_axis_ireq_tkeep    ), 
    .m_axis_ireq_tuser              (s_1_axis_ireq_tuser    ), 
    .s_axis_iresp_tvalid            (m_1_axis_iresp_tvalid  ), 
    .s_axis_iresp_tready            (m_1_axis_iresp_tready  ), 
    .s_axis_iresp_tlast             (m_1_axis_iresp_tlast   ), 
    .s_axis_iresp_tdata             (m_1_axis_iresp_tdata   ), 
    .s_axis_iresp_tkeep             (m_1_axis_iresp_tkeep   ), 
    .s_axis_iresp_tuser             (m_1_axis_iresp_tuser   ), 
    .s_axis_treq_tvalid             (m_1_axis_treq_tvalid   ), 
    .s_axis_treq_tready             (m_1_axis_treq_tready   ), 
    .s_axis_treq_tlast              (m_1_axis_treq_tlast    ), 
    .s_axis_treq_tdata              (m_1_axis_treq_tdata    ), 
    .s_axis_treq_tkeep              (m_1_axis_treq_tkeep    ), 
    .s_axis_treq_tuser              (m_1_axis_treq_tuser    ), 
    .m_axis_tresp_tvalid            (s_1_axis_tresp_tvalid  ), 
    .m_axis_tresp_tready            (s_1_axis_tresp_tready  ), 
    .m_axis_tresp_tlast             (s_1_axis_tresp_tlast   ), 
    .m_axis_tresp_tdata             (s_1_axis_tresp_tdata   ), 
    .m_axis_tresp_tkeep             (s_1_axis_tresp_tkeep   ), 
    .m_axis_tresp_tuser             (s_1_axis_tresp_tuser   ) 
);

SRIO_engine SRIO_engine_u1(
    .i_clk                          (w_2_log_clk            ),
    .i_rst                          (w_2_log_rst | ~w_2_port_initialized),

    .m_axis_ireq_tvalid             (s_2_axis_ireq_tvalid   ), 
    .m_axis_ireq_tready             (s_2_axis_ireq_tready   ), 
    .m_axis_ireq_tlast              (s_2_axis_ireq_tlast    ), 
    .m_axis_ireq_tdata              (s_2_axis_ireq_tdata    ), 
    .m_axis_ireq_tkeep              (s_2_axis_ireq_tkeep    ), 
    .m_axis_ireq_tuser              (s_2_axis_ireq_tuser    ), 
    .s_axis_iresp_tvalid            (m_2_axis_iresp_tvalid  ), 
    .s_axis_iresp_tready            (m_2_axis_iresp_tready  ), 
    .s_axis_iresp_tlast             (m_2_axis_iresp_tlast   ), 
    .s_axis_iresp_tdata             (m_2_axis_iresp_tdata   ), 
    .s_axis_iresp_tkeep             (m_2_axis_iresp_tkeep   ), 
    .s_axis_iresp_tuser             (m_2_axis_iresp_tuser   ), 
    .s_axis_treq_tvalid             (m_2_axis_treq_tvalid   ), 
    .s_axis_treq_tready             (m_2_axis_treq_tready   ), 
    .s_axis_treq_tlast              (m_2_axis_treq_tlast    ), 
    .s_axis_treq_tdata              (m_2_axis_treq_tdata    ), 
    .s_axis_treq_tkeep              (m_2_axis_treq_tkeep    ), 
    .s_axis_treq_tuser              (m_2_axis_treq_tuser    ), 
    .m_axis_tresp_tvalid            (s_2_axis_tresp_tvalid  ), 
    .m_axis_tresp_tready            (s_2_axis_tresp_tready  ), 
    .m_axis_tresp_tlast             (s_2_axis_tresp_tlast   ), 
    .m_axis_tresp_tdata             (s_2_axis_tresp_tdata   ), 
    .m_axis_tresp_tkeep             (s_2_axis_tresp_tkeep   ), 
    .m_axis_tresp_tuser             (s_2_axis_tresp_tuser   ) 
);


SRIO_module#(
    .P_LINE_NUM                 (P_LINE_NUM             )          
)SRIO_module(
    .i_gtref_clk                (w_gt_refclk            ),
    .i_rst                      (w_sys_rst),
    .i_sim_train_en             (0),

    .o_srio_txn                 (o_srio_txn             ),
    .o_srio_txp                 (o_srio_txp             ),
    .i_srio_rxn                 (i_srio_rxn             ),
    .i_srio_rxp                 (i_srio_rxp             ), 

    .o_1_gtrx_disperr_or        (w_1_gtrx_disperr_or    ),
    .o_1_gtrx_notintable_or     (w_1_gtrx_notintable_or ),
    .o_1_port_error             (w_1_port_error         ),
    .s_1_axis_ireq_tvalid       (s_1_axis_ireq_tvalid   ), 
    .s_1_axis_ireq_tready       (s_1_axis_ireq_tready   ), 
    .s_1_axis_ireq_tlast        (s_1_axis_ireq_tlast    ), 
    .s_1_axis_ireq_tdata        (s_1_axis_ireq_tdata    ), 
    .s_1_axis_ireq_tkeep        (s_1_axis_ireq_tkeep    ), 
    .s_1_axis_ireq_tuser        (s_1_axis_ireq_tuser    ), 
    .m_1_axis_iresp_tvalid      (m_1_axis_iresp_tvalid  ), 
    .m_1_axis_iresp_tready      (m_1_axis_iresp_tready  ), 
    .m_1_axis_iresp_tlast       (m_1_axis_iresp_tlast   ), 
    .m_1_axis_iresp_tdata       (m_1_axis_iresp_tdata   ), 
    .m_1_axis_iresp_tkeep       (m_1_axis_iresp_tkeep   ), 
    .m_1_axis_iresp_tuser       (m_1_axis_iresp_tuser   ), 
    .m_1_axis_treq_tvalid       (m_1_axis_treq_tvalid   ), 
    .m_1_axis_treq_tready       (m_1_axis_treq_tready   ), 
    .m_1_axis_treq_tlast        (m_1_axis_treq_tlast    ), 
    .m_1_axis_treq_tdata        (m_1_axis_treq_tdata    ), 
    .m_1_axis_treq_tkeep        (m_1_axis_treq_tkeep    ), 
    .m_1_axis_treq_tuser        (m_1_axis_treq_tuser    ), 
    .s_1_axis_tresp_tvalid      (s_1_axis_tresp_tvalid  ), 
    .s_1_axis_tresp_tready      (s_1_axis_tresp_tready  ), 
    .s_1_axis_tresp_tlast       (s_1_axis_tresp_tlast   ), 
    .s_1_axis_tresp_tdata       (s_1_axis_tresp_tdata   ), 
    .s_1_axis_tresp_tkeep       (s_1_axis_tresp_tkeep   ), 
    .s_1_axis_tresp_tuser       (s_1_axis_tresp_tuser   ), 
    .o_1_log_clk                (w_1_log_clk            ),
    .o_1_log_rst                (w_1_log_rst            ),
    .o_1_port_initialized       (w_1_port_initialized   ),
    .o_2_gtrx_disperr_or        (w_2_gtrx_disperr_or    ),
    .o_2_gtrx_notintable_or     (w_2_gtrx_notintable_or ),
    .o_2_port_error             (w_2_port_error         ),
    .s_2_axis_ireq_tvalid       (s_2_axis_ireq_tvalid   ), 
    .s_2_axis_ireq_tready       (s_2_axis_ireq_tready   ), 
    .s_2_axis_ireq_tlast        (s_2_axis_ireq_tlast    ), 
    .s_2_axis_ireq_tdata        (s_2_axis_ireq_tdata    ), 
    .s_2_axis_ireq_tkeep        (s_2_axis_ireq_tkeep    ), 
    .s_2_axis_ireq_tuser        (s_2_axis_ireq_tuser    ), 
    .m_2_axis_iresp_tvalid      (m_2_axis_iresp_tvalid  ), 
    .m_2_axis_iresp_tready      (m_2_axis_iresp_tready  ), 
    .m_2_axis_iresp_tlast       (m_2_axis_iresp_tlast   ), 
    .m_2_axis_iresp_tdata       (m_2_axis_iresp_tdata   ), 
    .m_2_axis_iresp_tkeep       (m_2_axis_iresp_tkeep   ), 
    .m_2_axis_iresp_tuser       (m_2_axis_iresp_tuser   ), 
    .m_2_axis_treq_tvalid       (m_2_axis_treq_tvalid   ), 
    .m_2_axis_treq_tready       (m_2_axis_treq_tready   ), 
    .m_2_axis_treq_tlast        (m_2_axis_treq_tlast    ), 
    .m_2_axis_treq_tdata        (m_2_axis_treq_tdata    ), 
    .m_2_axis_treq_tkeep        (m_2_axis_treq_tkeep    ), 
    .m_2_axis_treq_tuser        (m_2_axis_treq_tuser    ), 
    .s_2_axis_tresp_tvalid      (s_2_axis_tresp_tvalid  ), 
    .s_2_axis_tresp_tready      (s_2_axis_tresp_tready  ), 
    .s_2_axis_tresp_tlast       (s_2_axis_tresp_tlast   ), 
    .s_2_axis_tresp_tdata       (s_2_axis_tresp_tdata   ), 
    .s_2_axis_tresp_tkeep       (s_2_axis_tresp_tkeep   ), 
    .s_2_axis_tresp_tuser       (s_2_axis_tresp_tuser   ),
    .o_2_log_clk                (w_2_log_clk            ),
    .o_2_log_rst                (w_2_log_rst            ),
    .o_2_port_initialized       (w_2_port_initialized   )  
);



endmodule
