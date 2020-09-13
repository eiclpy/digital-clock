`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2020 09:12:18 AM
// Design Name: 
// Module Name: main_ctr
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


module main_ctr #(
    parameter integer FASTADJCNT=10
)(
    input clk,
    input rst,
    input single_click_up,
    input single_click_down,
    input single_click_left,
    input single_click_right,
    input single_click_center,
    input double_click_up,
    input double_click_down,
    input double_click_left,
    input double_click_right,
    input double_click_center,
    input long_press_up,
    input long_press_down,
    input long_press_left,
    input long_press_right,
    input long_press_center,
    output hour_rst,
    output minute_rst,
    output second_rst,
    output alarm_hour_rst,
    output alarm_minute_rst,
    output reg [15:0] display_ctr,
    output hour_add,
    output minute_add,
    output hour_dec,
    output minute_dec,
    output alarm_hour_add,
    output alarm_minute_add,
    output alarm_hour_dec,
    output alarm_minute_dec,
    output reg [2:0] status
    );
    reg reset_reg,add_reg,dec_reg;
    reg [$clog2(FASTADJCNT+1)-1:0] fast_add,fast_dec;
    assign second_rst=(status!=1|reset_reg)&rst;
    assign minute_rst=(status!=2|reset_reg)&rst;
    assign hour_rst=(status!=3|reset_reg)&rst;
    assign alarm_hour_rst=(status!=4|reset_reg)&rst;
    assign alarm_minute_rst=(status!=5|reset_reg)&rst;
    
    assign hour_add=status==3&add_reg;
    assign minute_add=status==2&add_reg;
    assign hour_dec=status==3&dec_reg;
    assign minute_dec=status==2&dec_reg;
    
    assign alarm_hour_add=status==5&add_reg;
    assign alarm_minute_add=status==4&add_reg;
    assign alarm_hour_dec=status==5&dec_reg;
    assign alarm_minute_dec=status==4&dec_reg;
    
//    assign display_ctr=0;
    parameter integer STATUS_MAX=5;
    always@(posedge clk or negedge rst)
    begin
        if(!rst)
        begin
            status<=0;
            reset_reg<=0;
            add_reg<=0;
            dec_reg<=0;
        end
        else if(single_click_left)
        begin
            status<=status<STATUS_MAX?status+1:0;
        end
        else if(single_click_right)
        begin
            status<=status>0?status-1:STATUS_MAX;
        end
        else if(single_click_center)
        begin
            reset_reg<=0;
        end
        else if(single_click_up)
        begin
            add_reg<=1;
        end
        else if(single_click_down)
        begin
            dec_reg<=1;
        end
        else if(long_press_up)
        begin
            add_reg<=1;
        end
        else if(long_press_down)
        begin
            dec_reg<=1;
        end
        else if(double_click_center)
        begin
            status<=0;
        end
        else if(double_click_up)
        begin
            fast_add<=FASTADJCNT;
        end
        else if(double_click_down)
        begin
            fast_dec<=FASTADJCNT;
        end
        else if(fast_add!=0)
        begin
            fast_add<=fast_add-1;
            if(fast_add[0])
                add_reg<=1;
        end
        else if(fast_dec!=0)
        begin
            fast_dec<=fast_dec-1;
            if(fast_dec[0])
                dec_reg<=1;
        end
        else
        begin
            reset_reg<=1;
            add_reg<=0;
            dec_reg<=0;
        end
    end
    always@(*)
        case(status)
            0:display_ctr<=16'b0000_0000_0000_0000;
            1:display_ctr<=16'b0000_0000_0000_0101;
            2:display_ctr<=16'b0000_0000_0101_0000;
            3:display_ctr<=16'b0000_0101_0000_0000;
            4:display_ctr<=16'b0000_0000_0101_1010;
            5:display_ctr<=16'b0000_0101_0000_1010;
        endcase
endmodule
