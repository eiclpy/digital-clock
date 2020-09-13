`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 09/06/2020 11:07:44 AM
// Design Name:
// Module Name: diver
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


module diver #(
    parameter integer DIVBASE = 16
)(
    input clk_i,
    input rst_n,
    output clk_o
    );
    reg [$clog2(DIVBASE+1)-1:0] cnt_p;
    reg [$clog2(DIVBASE+1)-1:0] cnt_n;
    reg clk_p;
    reg clk_n;
    assign clk_o=(DIVBASE==1)?clk_i:(DIVBASE[0])?(clk_p|clk_n):(clk_p);
    always@(posedge clk_i or negedge rst_n)
    begin
        if(!rst_n)
            cnt_p<=0;
        else if(cnt_p==(DIVBASE-1))
            cnt_p<=0;
        else
            cnt_p<=cnt_p+1;
    end
    always@(posedge clk_i or negedge rst_n)
    begin
        if(!rst_n)
            clk_p<=1;
        else if(cnt_p<(DIVBASE>>1))
            clk_p<=1;
        else
            clk_p<=0;
    end
    always@(negedge clk_i or negedge rst_n)
    begin
        if(!rst_n)
            cnt_n<=0;
        else if(cnt_n==(DIVBASE-1))
            cnt_n<=0;
        else
            cnt_n<=cnt_n+1;
    end
    always@(negedge clk_i or negedge rst_n) begin
        if(!rst_n)
            clk_n<=1;
        else if(cnt_n<(DIVBASE>>1))
            clk_n<=1;
        else
            clk_n<=0;
    end
endmodule