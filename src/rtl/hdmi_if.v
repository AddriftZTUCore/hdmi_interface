/******************************************Copyright@2024**************************************
                                    AddiftCore  ALL rights reserved
                                    https://www.cnblogs.com/cnlntr/
=========================================FILE INFO.============================================
FILE Name       : hdmi_if.v
Last Update     : 2024/08/24 23:41:13
Latest Versions : 1.0
========================================AUTHOR INFO.===========================================
Created by      : AddiftCore
Create date     : 2024/08/24 23:41:13
Version         : 1.0
Description     : hdmi interface.
=======================================UPDATE HISTPRY==========================================
Modified by     : 
Modified date   : 
Version         : 
Description     : 
******************************Licensed under the GPL-3.0 License.******************************/
`include "dmt_parameter.vh"

module hdmi_if(
    /********* system clock / reset *********/
    input   wire                      clk         ,   //system clock
    input   wire                      rst_n       ,

    /********* hdmi user *********/
    output wire  [`CNT_HSYC_W -1:0]   hcount      ,
    output wire  [`CNT_VSYC_W -1:0]   vcount      ,
    output wire                       dat_rdy     ,
    input  wire  [24          -1:0]   dat_in      ,

    /********* hdmi phy *********/
    output wire  [3           -1:0]   hdmi_p_do   ,   //hdmi dat channel(r,g,b)
    output wire                       hdmi_p_co   ,   //hdmi clock channel
    output wire  [3           -1:0]   hdmi_n_do   ,   //hdmi dat channel(r,g,b)
    output wire                       hdmi_n_co       //hdmi clock channel
);

wire                clk_out1    ;
wire                clk_out2    ;
wire                rst_i       ;
wire                rst_o       ;
wire [24    -1:0]   dmt_dat_o   ;
wire                dmt_hsyc    ;
wire                dmt_vsyc    ;
wire                dmt_blk     ;

wire [3     -1:0]   hdmi_do     ;   //hdmi dat channel(r,g,b)
wire                hdmi_co     ;   //hdmi clock channel

wire [30    -1:0]   tmds_dat_o  ;

hdmi_clkgen u_hdmi_clkgen(
    .clk_out1   (clk_out1   ),
    .clk_out2   (clk_out2   ),
    .locked     (rst_i      ),
    .clk_in1    (clk        ) 
);

reset_io u0_reset_io(
    .clk        (clk_out1           ),   //system clock
    .rst_n      (rst_i && rst_n     ),   //reset signal
    .rst_o      (rst_o              )
);

dmt_ctr u1_dmt_ctr (
    .clk              (clk_out1     ),
    .rst_n            (rst_o        ),
    .data_in          (dat_in       ),
    .data_out         (dmt_dat_o    ),
    .hsyc             (dmt_hsyc     ),
    .vsyc             (dmt_vsyc     ),
    .blk              (dmt_blk      ),
    .data_count_vld   (             ),
    .data_vld         (dat_rdy      ),
    .hcount           (hcount       ),
    .vcount           (vcount       ) 
);

tmds_encode u2_tmds_encode[2:0](
    .clkin  (clk_out1               ),     // pixel clock input
    .rstin  (~rst_o                 ),     // async. reset input (active high)
    .din    (dmt_dat_o              ),     // data inputs: expect registered
    .c0     ({1'b0,1'b0,dmt_hsyc}   ),     // c0 input
    .c1     ({1'b0,1'b0,dmt_vsyc}   ),     // c1 input
    .de     ({3{dmt_blk}}           ),     // de input
    .dout   (tmds_dat_o             )      // data outputs
);

serializer_10_to_1 u3_serializer_10_to_1[3:0](
    .clk         (clk_out1              ),   //system clock
    .rst_n       (rst_o                 ),   //reset signal

    .en          (1'b1                  ),
    .serial_clk  (clk_out2              ),   //the serial side clock
    .dat_in      ({10'b1111100000,tmds_dat_o}   ),
    .dat_out     ({hdmi_co,hdmi_do}     )
);

ds_o u_ds_o(
    .dat_i   ( {hdmi_co,hdmi_do}        ),
    .dat_p_o ( {hdmi_p_co,hdmi_p_do}    ),
    .dat_n_o ( {hdmi_n_co,hdmi_n_do}    ) 
);

endmodule
