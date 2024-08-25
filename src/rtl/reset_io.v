/******************************************Copyright@2024**************************************
                                    AddiftCore  ALL rights reserved
                                    https://www.cnblogs.com/cnlntr/
=========================================FILE INFO.============================================
FILE Name       : reset_io.v
Last Update     : 2024/08/24 23:49:43
Latest Versions : 1.0
========================================AUTHOR INFO.===========================================
Created by      : AddiftCore
Create date     : 2024/08/24 23:49:43
Version         : 1.0
Description     : Asynchronous reset synchronous release.
=======================================UPDATE HISTPRY==========================================
Modified by     : 
Modified date   : 
Version         : 
Description     : 
*************************************Confidential. Do NOT disclose****************************/
`include "top_define.vh"

module reset_io(
    /********* system clock / reset *********/
    input   wire            clk         ,   //system clock
    input   wire            rst_n       ,   //reset signal
    /********* var *********/
    output  wire            rst_o       
);

reg _rst_o;
reg __rst_o;

generate 
    if(`RST_POSITIVE == 0)begin
        always @(posedge clk or negedge rst_n)begin
            if(`rst)begin
                __rst_o <= 'd0;
                _rst_o  <= 'd0;
            end
            else begin
                __rst_o <= 1'b1;
                _rst_o  <= __rst_o;
            end
        end 
    end
    else begin
        always @(posedge clk or negedge rst_n)begin
            if(`rst)begin
                __rst_o <= 'd1;
                _rst_o  <= 'd1;
            end
            else begin
                __rst_o <= 1'b0;
                _rst_o  <= __rst_o;
            end
        end 
    end
endgenerate


assign rst_o = _rst_o;

endmodule
