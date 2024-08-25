/******************************************Copyright@2024**************************************
                                    AddiftCore  ALL rights reserved
                                    https://www.cnblogs.com/cnlntr/
=========================================FILE INFO.============================================
FILE Name       : serializer_10_to_1.v
Last Update     : 2024/08/24 20:04:01
Latest Versions : 1.0
========================================AUTHOR INFO.===========================================
Created by      : AddiftCore
Create date     : 2024/08/24 20:04:01
Version         : 1.0
Description     : Used for parallel data to serial data.
=======================================UPDATE HISTPRY==========================================
Modified by     : 
Modified date   : 
Version         : 
Description     : 
*************************************Confidential. Do NOT disclose****************************/
`include "top_define.vh"

module serializer_10_to_1 #(
    parameter DATA_W = 10
)
(
    /********* system clock / reset *********/
    input   wire                    clk         ,   //system clock
    input   wire                    rst_n       ,   //reset signal

    /********* data *********/
    input   wire                    en          ,
    input   wire                    serial_clk  ,   //the serial side clock
    input   wire    [DATA_W-1:0]    dat_in      ,
    output  wire                    dat_out     
);

`ifdef FPGA_K7
    wire shiftout1;
    wire shiftout2;

    OSERDESE2 #(
        .DATA_RATE_OQ("DDR"),   // DDR, SDR
        .DATA_RATE_TQ("DDR"),   // DDR, BUF, SDR
        .DATA_WIDTH(DATA_W),         // Parallel data width (2-8,10,14)
        .INIT_OQ(1'b0),         // Initial value of OQ output (1'b0,1'b1)
        .INIT_TQ(1'b0),         // Initial value of TQ output (1'b0,1'b1)
        .SERDES_MODE("MASTER"), // MASTER, SLAVE
        .SRVAL_OQ(1'b0),        // OQ output value when SR is used (1'b0,1'b1)
        .SRVAL_TQ(1'b0),        // TQ output value when SR is used (1'b0,1'b1)
        .TBYTE_CTL("FALSE"),    // Enable tristate byte operation (FALSE, TRUE)
        .TBYTE_SRC("FALSE"),    // Tristate byte source (FALSE, TRUE)
        .TRISTATE_WIDTH(1)      // 3-state converter width (1,4)
    )
    OSERDESE2_0 (
        .OFB(),             // 1-bit output: Feedback path for data
        .OQ(dat_out),               // 1-bit output: Data path output
        // SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
        .SHIFTOUT1(),
        .SHIFTOUT2(),
        .TBYTEOUT(),         // 1-bit output: Byte group tristate
        .TFB(),             // 1-bit output: 3-state control
        .TQ(),               // 1-bit output: 3-state control
        .CLK(serial_clk),             // 1-bit input: High speed clock
        .CLKDIV(clk),       // 1-bit input: Divided clock
        // D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
        .D1(dat_in[0]),
        .D2(dat_in[1]),
        .D3(dat_in[2]),
        .D4(dat_in[3]),
        .D5(dat_in[4]),
        .D6(dat_in[5]),
        .D7(dat_in[6]),
        .D8(dat_in[7]),
        .OCE(en),             // 1-bit input: Output data clock enable
        .RST(~rst_n),             // 1-bit input: Reset
        // SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
        .SHIFTIN1(shiftout1),
        .SHIFTIN2(shiftout2),
        // T1 - T4: 1-bit (each) input: Parallel 3-state inputs
        .T1(1'b0),
        .T2(1'b0),
        .T3(1'b0),
        .T4(1'b0),
        .TBYTEIN(1'b0),     // 1-bit input: Byte group tristate
        .TCE(1'b0)              // 1-bit input: 3-state clock enable
    );// End of OSERDESE2_inst instantiation

    OSERDESE2 #(
        .DATA_RATE_OQ("DDR"),   // DDR, SDR
        .DATA_RATE_TQ("DDR"),   // DDR, BUF, SDR
        .DATA_WIDTH(DATA_W),         // Parallel data width (2-8,10,14)
        .INIT_OQ(1'b0),         // Initial value of OQ output (1'b0,1'b1)
        .INIT_TQ(1'b0),         // Initial value of TQ output (1'b0,1'b1)
        .SERDES_MODE("SLAVE"), // MASTER, SLAVE
        .SRVAL_OQ(1'b0),        // OQ output value when SR is used (1'b0,1'b1)
        .SRVAL_TQ(1'b0),        // TQ output value when SR is used (1'b0,1'b1)
        .TBYTE_CTL("FALSE"),    // Enable tristate byte operation (FALSE, TRUE)
        .TBYTE_SRC("FALSE"),    // Tristate byte source (FALSE, TRUE)
        .TRISTATE_WIDTH(1)      // 3-state converter width (1,4)
    )
    OSERDESE2_1 (
        .OFB(),             // 1-bit output: Feedback path for data
        .OQ(OQ),               // 1-bit output: Data path output
        // SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
        .SHIFTOUT1(shiftout1),
        .SHIFTOUT2(shiftout2),
        .TBYTEOUT(),   // 1-bit output: Byte group tristate
        .TFB(),             // 1-bit output: 3-state control
        .TQ(),               // 1-bit output: 3-state control
        .CLK(serial_clk),             // 1-bit input: High speed clock
        .CLKDIV(clk),       // 1-bit input: Divided clock
        // D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
        .D1(1'b0),
        .D2(1'b0),
        .D3(dat_in[8]),
        .D4(dat_in[9]),
        .D5(1'b0),
        .D6(1'b0),
        .D7(1'b0),
        .D8(1'b0),
        .OCE(en),             // 1-bit input: Output data clock enable
        .RST(~rst_n),             // 1-bit input: Reset
        // SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
        .SHIFTIN1(1'b0),
        .SHIFTIN2(1'b0),
        // T1 - T4: 1-bit (each) input: Parallel 3-state inputs
        .T1(1'b0),
        .T2(1'b0),
        .T3(1'b0),
        .T4(1'b0),
        .TBYTEIN(1'b0),     // 1-bit input: Byte group tristate
        .TCE(1'b0)              // 1-bit input: 3-state clock enable
    );// End of OSERDESE2_inst instantiation
`endif

endmodule

