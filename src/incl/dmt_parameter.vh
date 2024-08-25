// `ifdef __DMT_PARAMETER_VH
// `define __DMT_PARAMETER_VH 1

   `define resolution_1920x1080;

   `ifdef resolution_800x480
      `define H_RIGHT_BORDER  12'd0
      `define H_FRONT_PORCH   12'd40
      `define H_SYNC_TIME     12'd128
      `define H_BACK_PORCH    12'd88
      `define H_LEFT_BORDER   12'd0
      `define H_DATA_TIME     12'd800
      `define H_TOTAL_TIME    12'd1056
      `define V_BOTTOM_BORDER 12'd8
      `define V_FRONT_PORCH   12'd2
      `define V_SYNC_TIME     12'd2
      `define V_BACK_PORCH    12'd25
      `define V_TOP_BORDER    12'd8
      `define V_DATA_TIME     12'd480
      `define V_TOTAL_TIME    12'd525

      `define CNT_HSYC_W      11
      `define CNT_VSYC_W      10
      `define HPOSITIVE       0
      `define VPOSITIVE       0
   `endif

   `ifdef resolution_1920x1080
      `define H_RIGHT_BORDER  12'd0
      `define H_FRONT_PORCH   12'd88
      `define H_SYNC_TIME     12'd44
      `define H_BACK_PORCH    12'd148
      `define H_LEFT_BORDER   12'd0
      `define H_DATA_TIME     12'd1920
      `define H_TOTAL_TIME    12'd2200
      `define V_BOTTOM_BORDER 12'd0
      `define V_FRONT_PORCH   12'd4
      `define V_SYNC_TIME     12'd5
      `define V_BACK_PORCH    12'd36
      `define V_TOP_BORDER    12'd0
      `define V_DATA_TIME     12'd1080
      `define V_TOTAL_TIME    12'd1125

      `define CNT_HSYC_W      12
      `define CNT_VSYC_W      11
      `define HPOSITIVE       1
      `define VPOSITIVE       1
   `endif

// `endif

