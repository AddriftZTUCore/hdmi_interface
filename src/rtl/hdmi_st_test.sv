`include "dmt_parameter.vh"

module hdmi_st_test(
    input  logic                       clk         ,

    /********* hdmi phy *********/
    output logic  [3           -1:0]   hdmi_p_do   ,   //hdmi dat channel(r,g,b)
    output logic                       hdmi_p_co   ,   //hdmi clock channel
    output logic  [3           -1:0]   hdmi_n_do   ,   //hdmi dat channel(r,g,b)
    output logic                       hdmi_n_co       //hdmi clock channel
);

logic   [12 -1:0]   hcount      ;
logic   [12 -1:0]   vcount      ;
logic               dat_rdy     ;
logic   [24 -1:0]   dat_in      ;
logic               hdmi_do     ;
logic               hdmi_co     ;


//定义颜色编码
localparam
   BLACK = 24'h000000,  //黑色
   BLUE = 24'h0000F8,   //蓝色
   RED = 24'hFF0000,    //红色
   PURPPLE =24'hFF00FF, //紫色
   GREEN = 24'h00FF00,  //绿色
   CYAN = 24'h00FFFF,   //青色
   YELLOW = 24'hFFFF00, //黄色
   WHITE = 24'hFFFFFF;  //白色

// always @(*)begin
//     if((hcount >= 0 && hcount < 400) && (vcount >= 0 && vcount < 120) && dat_rdy)
//         dat_in = RED;
//     else if((hcount >= 400 && hcount < 800) && (vcount >= 0 && vcount < 120) && dat_rdy)
//         dat_in = BLUE;
//     else if((hcount >= 0 && hcount < 400) && (vcount >= 120 && vcount < 240) && dat_rdy)
//         dat_in = BLACK;
//     else if((hcount >= 400 && hcount < 800) && (vcount >= 120 && vcount < 240) && dat_rdy)
//         dat_in = WHITE; 
//     else if((hcount >= 0 && hcount < 400) && (vcount >= 240 && vcount < 360) && dat_rdy)
//         dat_in = PURPPLE;
//     else if((hcount >= 400 && hcount < 800) && (vcount >= 240 && vcount < 360) && dat_rdy)
//         dat_in = GREEN;
//     else if((hcount >= 0 && hcount < 400) && (vcount >= 360 && vcount < 480) && dat_rdy)
//         dat_in = CYAN;
//     else if((hcount >= 400 && hcount < 800) && (vcount >= 360 && vcount < 480) && dat_rdy)
//         dat_in = YELLOW;
//     else
//         dat_in =0;
// end

always @(*)begin
    if((hcount >= 0 && hcount < `H_DATA_TIME/2) && (vcount >= 0 && vcount < 270) && dat_rdy)
        dat_in = RED;
    else if((hcount >= `H_DATA_TIME/2 && hcount < `H_DATA_TIME) && (vcount >= 0 && vcount < 270) && dat_rdy)
        dat_in = BLUE;
    else if((hcount >= 0 && hcount < `H_DATA_TIME/2) && (vcount >= 270 && vcount < 540) && dat_rdy)
        dat_in = BLACK;
    else if((hcount >= `H_DATA_TIME/2 && hcount < `H_DATA_TIME) && (vcount >= 270 && vcount < 540) && dat_rdy)
        dat_in = WHITE; 
    else if((hcount >= 0 && hcount < `H_DATA_TIME/2) && (vcount >= 540 && vcount < 810) && dat_rdy)
        dat_in = PURPPLE;
    else if((hcount >= `H_DATA_TIME/2 && hcount < `H_DATA_TIME) && (vcount >= 540 && vcount < 810) && dat_rdy)
        dat_in = GREEN;
    else if((hcount >= 0 && hcount < `H_DATA_TIME/2) && (vcount >= 810 && vcount < 1080) && dat_rdy)
        dat_in = CYAN;
    else if((hcount >= `H_DATA_TIME/2 && hcount < `H_DATA_TIME) && (vcount >= 810 && vcount < 1080) && dat_rdy)
        dat_in = YELLOW;
    else
        dat_in =0;
end

hdmi_if u_hdmi_if(
    .clk         (clk       ),   //system clock
    .rst_n       (1'b1      ),

    .hcount      (hcount    ),
    .vcount      (vcount    ),
    .dat_rdy     (dat_rdy   ),
    .dat_in      (dat_in    ),

    .hdmi_p_do   (hdmi_p_do ),   //hdmi dat channel(r,g,b)
    .hdmi_p_co   (hdmi_p_co ),   //hdmi clock channel
    .hdmi_n_do   (hdmi_n_do ),   //hdmi dat channel(r,g,b)
    .hdmi_n_co   (hdmi_n_co )    //hdmi clock channel
);

endmodule
