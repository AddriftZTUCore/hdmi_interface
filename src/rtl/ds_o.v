/******************************************Copyright@2024**************************************
                                    AddiftCore  ALL rights reserved
                                    https://www.cnblogs.com/cnlntr/
=========================================FILE INFO.============================================
FILE Name       : ds_o.v
Last Update     : 2024/08/25 20:13:00
Latest Versions : 1.0
========================================AUTHOR INFO.===========================================
Created by      : AddiftCore
Create date     : 2024/08/25 20:13:00
Version         : 1.0
Description     : Single ended signal to differential signal.
=======================================UPDATE HISTPRY==========================================
Modified by     : 
Modified date   : 
Version         : 
Description     : 
*************************************Confidential. Do NOT disclose****************************/
module ds_o #(
    parameter D_W = 4
)
(
    input  wire [D_W -1:0] dat_i  ,
    output wire [D_W -1:0] dat_p_o,
    output wire [D_W -1:0] dat_n_o 
);

OBUFDS OBUFDS_inst[D_W-1:0] (
    .O  (dat_p_o ), // 1-bit output: Diff_p output (connect directly to top-level port)
    .OB (dat_n_o ), // 1-bit output: Diff_n output (connect directly to top-level port)
    .I  (dat_i   )  // 1-bit input: Buffer input
);

endmodule
