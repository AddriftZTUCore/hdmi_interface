/******************************************Copyright@2024**************************************
                                    AddiftCore  ALL rights reserved
                                    https://www.cnblogs.com/cnlntr/
=========================================FILE INFO.============================================
FILE Name       : dmt_ctrl.v
Last Update     : 2024/08/24 21:54:20
Latest Versions : 1.0
========================================AUTHOR INFO.===========================================
Created by      : AddiftCore
Create date     : 2024/08/24 21:54:20
Version         : 1.0
Description     : dmt control.
=======================================UPDATE HISTPRY==========================================
Modified by     : 
Modified date   : 
Version         : 
Description     : 
*************************************Confidential. Do NOT disclose****************************/

`include "dmt_parameter.vh"

module dmt_ctr #(
   parameter DATA_W        = 24,
   parameter CNT_HSYC_W    = `CNT_HSYC_W,
   parameter CNT_VSYC_W    = `CNT_VSYC_W 
)(
   input  wire                     clk              ,
   input  wire                     rst_n            ,
   input  wire [DATA_W     -1:0]   data_in          ,
   output reg  [DATA_W     -1:0]   data_out         ,
   output reg                      hsyc             ,
   output reg                      vsyc             ,
   output reg                      blk              ,
   output reg                      data_count_vld   ,
   output reg                      data_vld         ,
   output reg  [CNT_HSYC_W -1:0]   hcount           ,
   output reg  [CNT_VSYC_W -1:0]   vcount            
);



localparam H_SYNC_END   =  `H_SYNC_TIME;
//数据开始设置在数据左黑边过去之后，而不是时序图上的数据开始
localparam H_DATA_BEGIN =  `H_SYNC_TIME + `H_BACK_PORCH + `H_LEFT_BORDER;
//数据结束设置在数据右黑边来到之前，而不是时序图上的数据结束               
localparam H_DATA_END   =  `H_SYNC_TIME + `H_BACK_PORCH + `H_LEFT_BORDER + `H_DATA_TIME;                 
localparam H_SYNC_BEGIN =  `H_SYNC_TIME + `H_BACK_PORCH + `H_LEFT_BORDER + `H_DATA_TIME + `H_RIGHT_BORDER + `H_FRONT_PORCH;

localparam V_SYNC_END   =  `V_SYNC_TIME;
//数据开始设置在数据左黑边过去之后，而不是时序图上的数据开始
localparam V_DATA_BEGIN =  `V_SYNC_TIME + `V_BACK_PORCH + `V_TOP_BORDER;
//数据结束设置在数据右黑边来到之前，而不是时序图上的数据结束 
localparam V_DATA_END   =  `V_SYNC_TIME + `V_BACK_PORCH + `V_TOP_BORDER + `V_DATA_TIME;
localparam V_SYNC_BEGIN =  `V_SYNC_TIME + `V_BACK_PORCH + `V_TOP_BORDER + `V_DATA_TIME + `V_BOTTOM_BORDER + `V_FRONT_PORCH;


//计数器
localparam CNT_HSYC_N   =  `H_TOTAL_TIME;
localparam CNT_VSYC_N   =  `V_TOTAL_TIME;

//计数器
reg      [CNT_HSYC_W-1:0]  cnt_hsyc;
wire                       add_cnt_hsyc;
wire                       end_cnt_hsyc;
reg      [CNT_VSYC_W-1:0]  cnt_vsyc;
wire                       add_cnt_vsyc;
wire                       end_cnt_vsyc;


//行同步计数器
always @(posedge clk or negedge rst_n)begin
   if(!rst_n)
      cnt_hsyc <= 0;
   else if(add_cnt_hsyc)begin
      if(end_cnt_hsyc)
         cnt_hsyc <= 0;
      else
         cnt_hsyc <= cnt_hsyc + 1'b1;
   end
end
assign add_cnt_hsyc = 1;
assign end_cnt_hsyc = add_cnt_hsyc && cnt_hsyc == CNT_HSYC_N - 1;


//场同步计数器
always @(posedge clk or negedge rst_n)begin
   if(!rst_n)
      cnt_vsyc <= 0;
   else if(add_cnt_vsyc)begin
      if(end_cnt_vsyc)
         cnt_vsyc <= 0;
      else
         cnt_vsyc <= cnt_vsyc + 1'b1;
   end
end
assign add_cnt_vsyc = end_cnt_hsyc;
assign end_cnt_vsyc = add_cnt_vsyc && cnt_vsyc == CNT_VSYC_N - 1;

//输出比输入慢一拍，hcount,vcount要先于输出一拍产生数据
//行有效数据计数器
always @(posedge clk or negedge rst_n)begin
   if(!rst_n)
      hcount <= 0;
   else if(data_count_vld)
      hcount <= (cnt_hsyc - (H_DATA_BEGIN - 2));
end

//场有效数据计数器
always @(posedge clk or negedge rst_n)begin
   if(!rst_n)
      vcount <= 0;
   else if(data_count_vld)
      vcount <= cnt_vsyc - V_DATA_BEGIN;
end

//行同步信号
always @(posedge clk or negedge rst_n)begin
   if(!rst_n)
      hsyc <= 0;
   else if(cnt_hsyc == H_SYNC_END - 1 && add_cnt_hsyc)
      hsyc <= ~ `HPOSITIVE;
   else if(cnt_hsyc == H_SYNC_BEGIN -1 && add_cnt_hsyc)
      hsyc <=   `HPOSITIVE;
end

//场同步信号
always @(posedge clk or negedge rst_n)begin
   if(!rst_n)
      vsyc <= 0;
   else if(cnt_vsyc == V_SYNC_END - 1 && add_cnt_vsyc)
      vsyc <= ~ `VPOSITIVE;
   else if(cnt_vsyc == V_SYNC_BEGIN - 1 && add_cnt_vsyc)
      vsyc <= `VPOSITIVE;
end

//数据传输标志位
always @(posedge clk or negedge rst_n)begin
   if(!rst_n) 
      blk <= 0;
   else if(data_vld)
      blk <= 1;
   else
      blk <= 0;
end

//数据传输使能信号，比blk提前一拍，为了数据传输与blk同步
always @(posedge clk or negedge rst_n)begin
   if(!rst_n)
      data_vld <= 0;
   else if(data_count_vld)
      data_vld <= 1;
   else
      data_vld <= 0;
end

//有效数据指示信号
always @(posedge clk or negedge rst_n)begin
   if(!rst_n)
      data_count_vld <= 0;
   else if((cnt_hsyc >= H_DATA_BEGIN - 3 && cnt_hsyc < H_DATA_END - 3) && (cnt_vsyc >= V_DATA_BEGIN && cnt_vsyc < V_DATA_END))
      data_count_vld <= 1;
   else
      data_count_vld <= 0;
end

//数据传输
always @(posedge clk or negedge rst_n)begin
   if(!rst_n)
      data_out <= 0;
   else if(data_vld)
      data_out <= data_in;
   else
      data_out <= 0;
end

endmodule

