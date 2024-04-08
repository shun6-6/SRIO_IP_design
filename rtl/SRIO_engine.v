`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/08 09:56:39
// Design Name: 
// Module Name: SRIO_engine
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//1.发送写数据报文
//2.发送一个DB报文，通知对方写完成
//3.发送一个读报文，把写的数据读出来
//4.发送一个MESSAGE，通知对方操作结束
//5.回读0~256的响应报文
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SRIO_engine(
    input               i_clk                   ,
    input               i_rst                   ,

    output              m_axis_ireq_tvalid      , 
    input               m_axis_ireq_tready      , 
    output              m_axis_ireq_tlast       , 
    output [63:0]       m_axis_ireq_tdata       , 
    output [7 :0]       m_axis_ireq_tkeep       , 
    output [31:0]       m_axis_ireq_tuser       , 
    input               s_axis_iresp_tvalid     , 
    output              s_axis_iresp_tready     , 
    input               s_axis_iresp_tlast      , 
    input  [63:0]       s_axis_iresp_tdata      , 
    input  [7 :0]       s_axis_iresp_tkeep      , 
    input  [31:0]       s_axis_iresp_tuser      , 

    input               s_axis_treq_tvalid      , 
    output              s_axis_treq_tready      , 
    input               s_axis_treq_tlast       , 
    input  [63:0]       s_axis_treq_tdata       , 
    input  [7 :0]       s_axis_treq_tkeep       , 
    input  [31:0]       s_axis_treq_tuser       , 
    output              m_axis_tresp_tvalid     , 
    input               m_axis_tresp_tready     , 
    output              m_axis_tresp_tlast      , 
    output [63:0]       m_axis_tresp_tdata      , 
    output [7 :0]       m_axis_tresp_tkeep      , 
    output [31:0]       m_axis_tresp_tuser       
);
/******************************function*****************************/

/******************************parameter****************************/

/******************************mechine******************************/
localparam              P_ST_IDLE           = 0 ,
                        P_ST_WRITE          = 1 ,
                        P_ST_DB             = 2 ,
                        P_ST_READ           = 3 ,
                        P_ST_MESSAGE        = 4 ,
                        P_ST_END            = 5 ;

reg  [7 :0]             r_st_current            ;
reg  [7 :0]             r_st_next               ;
reg  [15:0]             r_st_cnt                ;
/******************************reg**********************************/
reg                     rm_axis_ireq_tvalid     ;
reg                     rm_axis_ireq_tlast      ;
reg  [63:0]             rm_axis_ireq_tdata      ;
reg  [7 :0]             rm_axis_ireq_tkeep      ;
reg  [31:0]             rm_axis_ireq_tuser      ;
reg                     rs_axis_iresp_tready    ;
reg                     rs_axis_treq_tready     ;
reg                     rm_axis_tresp_tvalid    ;
reg                     rm_axis_tresp_tlast     ;
reg  [63:0]             rm_axis_tresp_tdata     ;
reg  [7 :0]             rm_axis_tresp_tkeep     ;
reg  [31:0]             rm_axis_tresp_tuser     ;
reg  [15:0]             r_pkt_cnt               ;
reg  [7 :0]             r_read_cmd              ;
reg                     r_read_cmd_valid        ;
reg                     r_read_triger           ;
reg  [15:0]             r_treq_cnt              ;
reg  [15:0]             r_read_cnt              ;
/******************************wire*********************************/
wire                    w_m_axis_ireq_act       ;
wire                    w_s_axis_iresp_act      ;
wire                    w_s_axis_treq_act       ;
wire                    w_m_axis_tresp_act      ;
/******************************component****************************/

/******************************assign*******************************/
assign m_axis_ireq_tvalid  = rm_axis_ireq_tvalid    ;
assign m_axis_ireq_tlast   = rm_axis_ireq_tlast     ;
assign m_axis_ireq_tdata   = rm_axis_ireq_tdata     ;
assign m_axis_ireq_tkeep   = rm_axis_ireq_tkeep     ;
assign m_axis_ireq_tuser   = rm_axis_ireq_tuser     ;
assign s_axis_iresp_tready = rs_axis_iresp_tready   ;
assign s_axis_treq_tready  = rs_axis_treq_tready    ;
assign m_axis_tresp_tvalid = rm_axis_tresp_tvalid   ;
assign m_axis_tresp_tlast  = rm_axis_tresp_tlast    ;
assign m_axis_tresp_tdata  = rm_axis_tresp_tdata    ;
assign m_axis_tresp_tkeep  = rm_axis_tresp_tkeep    ;
assign m_axis_tresp_tuser  = rm_axis_tresp_tuser    ;
assign w_m_axis_ireq_act   = m_axis_ireq_tvalid & m_axis_ireq_tready;
assign w_s_axis_iresp_act  = s_axis_iresp_tvalid & s_axis_iresp_tready;
assign w_s_axis_treq_act   = s_axis_treq_tvalid & s_axis_treq_tready;
assign w_m_axis_tresp_act  = m_axis_tresp_tvalid & m_axis_tresp_tready;
/******************************always*******************************/
always@(posedge i_clk,posedge i_rst) 
begin
    if(i_rst) 
        r_st_current <= P_ST_IDLE;
    else 
        r_st_current <= r_st_next;
end

always@(*)
begin
    case(r_st_current)
        P_ST_IDLE       :r_st_next <= r_st_cnt == 1000                          ? P_ST_WRITE    : P_ST_IDLE     ;
        P_ST_WRITE      :r_st_next <= w_m_axis_ireq_act & rm_axis_ireq_tlast    ? P_ST_DB       : P_ST_WRITE    ;
        P_ST_DB         :r_st_next <= w_m_axis_ireq_act & rm_axis_ireq_tlast    ? P_ST_READ     : P_ST_DB       ;
        P_ST_READ       :r_st_next <= w_s_axis_iresp_act & s_axis_iresp_tlast   ? P_ST_MESSAGE  : P_ST_READ     ;
        P_ST_MESSAGE    :r_st_next <= w_m_axis_ireq_act & rm_axis_ireq_tlast    ? P_ST_END      : P_ST_MESSAGE  ;
        P_ST_END        :r_st_next <= P_ST_IDLE;
        default         :r_st_next <= P_ST_IDLE;
    endcase 
end

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        r_st_cnt <= 'd0;
    else if(r_st_current != r_st_next)
        r_st_cnt <= 'd0;
    else 
        r_st_cnt <= r_st_cnt + 1;
end

//======================Initiator===========================//
//组包逻辑
always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        rs_axis_treq_tready <= 'd0;
    else 
        rs_axis_treq_tready <= 'd1;
end

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        rs_axis_iresp_tready <= 'd0;
    else 
        rs_axis_iresp_tready <= 'd1;
end

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        rm_axis_ireq_tvalid <= 'd0;
    else if(w_m_axis_ireq_act && rm_axis_ireq_tlast)
        rm_axis_ireq_tvalid <= 'd0;
    else if(r_st_current == P_ST_WRITE && r_st_cnt == 0)
        rm_axis_ireq_tvalid <= 'd1;
    else if(r_st_current == P_ST_DB && r_st_cnt == 0)
        rm_axis_ireq_tvalid <= 'd1;
    else if(r_st_current == P_ST_READ && r_st_cnt == 0)
        rm_axis_ireq_tvalid <= 'd1;
    else if(r_st_current == P_ST_MESSAGE && r_st_cnt == 0)
        rm_axis_ireq_tvalid <= 'd1;
    else 
        rm_axis_ireq_tvalid <= rm_axis_ireq_tvalid;
end

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        rm_axis_ireq_tlast <= 'd0;
    else if(w_m_axis_ireq_act && rm_axis_ireq_tlast)
        rm_axis_ireq_tlast <= 'd0;
    else if(r_st_current == P_ST_DB && r_st_cnt == 0)
        rm_axis_ireq_tlast <= 'd1;
    else if(r_st_current == P_ST_MESSAGE && w_m_axis_ireq_act)
        rm_axis_ireq_tlast <= 'd1;
    else if(r_st_current == P_ST_READ && r_st_cnt == 0)
        rm_axis_ireq_tlast <= 'd1;
    else if(r_st_current == P_ST_WRITE && r_pkt_cnt == 32 - 1)
        rm_axis_ireq_tlast <= 'd1;
    else 
        rm_axis_ireq_tlast <= rm_axis_ireq_tlast;
end

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        rm_axis_ireq_tdata <= 'd0;
    else if(r_st_current == P_ST_WRITE && r_st_cnt == 0)
        rm_axis_ireq_tdata <=  {8'd0,4'b0101,4'b0100,1'b0,2'b1,1'b0,8'd255,2'b0,34'd0};
    else if(r_st_current == P_ST_DB && r_st_cnt == 0)
        rm_axis_ireq_tdata <= {8'd0,4'b1010,4'd0,1'b0,2'b0,1'b0,8'd0,2'b0,2'b0,8'd0,8'd0,16'd0};
    else if(r_st_current == P_ST_READ && r_st_cnt == 0)
        rm_axis_ireq_tdata <= {8'd0,4'b0010,4'd4,1'b0,2'b0,1'b0,8'd255,2'b0,34'd0};
    else if(r_st_current == P_ST_MESSAGE && r_st_cnt == 0)
        rm_axis_ireq_tdata <= {4'd0,4'd0,4'b1011,4'd0,1'b0,2'b0,1'b0,8'd63,2'b0,34'd0};
    else if(w_m_axis_ireq_act)
        case(r_pkt_cnt)
            0       :rm_axis_ireq_tdata <= {4{r_pkt_cnt}};
            default :rm_axis_ireq_tdata <= {4{r_pkt_cnt}};
        endcase 
    else 
        rm_axis_ireq_tdata <= rm_axis_ireq_tdata;
end

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        r_pkt_cnt <= 'd0;
    else if(r_pkt_cnt == 32 && w_m_axis_ireq_act)
        r_pkt_cnt <= 'd0;
    else if(r_st_current == P_ST_WRITE && w_m_axis_ireq_act)
        r_pkt_cnt <= r_pkt_cnt + 1;
    else 
        r_pkt_cnt <= r_pkt_cnt;
end

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        rm_axis_ireq_tkeep <= 8'hff;
    else 
        rm_axis_ireq_tkeep <= 8'hff;
end     
 
always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        rm_axis_ireq_tuser <= 'd0;
    else 
        rm_axis_ireq_tuser <= 'd0;
end

//==================================Target===========================//
always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        r_treq_cnt <= 'd0;
    else if(w_s_axis_treq_act && s_axis_treq_tlast)
        r_treq_cnt <= 'd0;
    else if(w_s_axis_treq_act)
        r_treq_cnt <= r_treq_cnt + 1;
    else 
        r_treq_cnt <= r_treq_cnt;
end

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        r_read_cmd <= 'd0;
    else if(w_s_axis_treq_act && r_treq_cnt == 0)
        r_read_cmd <= s_axis_treq_tdata[55:48];
    else 
        r_read_cmd <= r_read_cmd;
end

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        r_read_cmd_valid <= 'd0;
    else if(w_s_axis_treq_act && r_treq_cnt == 0)
        r_read_cmd_valid <= 'd1;
    else 
        r_read_cmd_valid <= 'd0;
end


always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        r_read_triger <= 'd0;
    else if(r_read_cmd_valid && r_read_cmd == {4'b0010,4'd4})
        r_read_triger <= 'd1;
    else 
        r_read_triger <= 'd0;
end

/*----带数据的响应报文----*/
always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        rm_axis_tresp_tvalid <= 'd0;
    else if(w_m_axis_tresp_act && rm_axis_tresp_tlast)
        rm_axis_tresp_tvalid <= 'd0;
    else if(r_read_triger)
        rm_axis_tresp_tvalid <= 'd1;
    else
        rm_axis_tresp_tvalid <= rm_axis_tresp_tvalid;
end

 
always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        rm_axis_tresp_tlast <= 'd0;
    else if(w_m_axis_tresp_act && rm_axis_tresp_tlast)
        rm_axis_tresp_tlast <= 'd0;
    else if(r_read_cnt == 32 - 0)
        rm_axis_tresp_tlast <= 'd1;
    else
        rm_axis_tresp_tlast <= rm_axis_tresp_tlast;
end
 
always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        rm_axis_tresp_tdata <= 'd0;
    else if(r_read_triger)
        rm_axis_tresp_tdata <= {8'd0,4'b1101,4'b1000,1'b1,2'd1,1'b0,8'd0,2'd0,34'd0};
    else if(w_m_axis_tresp_act)
        rm_axis_tresp_tdata <= {4{r_read_cnt - 1}};
    else
        rm_axis_tresp_tdata <= rm_axis_tresp_tdata;
end

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        r_read_cnt <= 'd0;
    else if(r_read_cnt == 32 && w_m_axis_tresp_act)
        r_read_cnt <= 'd0;
    else if(r_read_triger || (r_read_cnt && w_m_axis_tresp_act))
        r_read_cnt <= r_read_cnt + 1;
    else 
        r_read_cnt <= r_read_cnt;
end

always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        rm_axis_tresp_tkeep <= 'd0;
    else
        rm_axis_tresp_tkeep <= 8'hff;
end
 
always@(posedge i_clk,posedge i_rst)
begin
    if(i_rst)
        rm_axis_tresp_tuser <= 'd0;
    else
        rm_axis_tresp_tuser <= 'd0;
end     




endmodule
