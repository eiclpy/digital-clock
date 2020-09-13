`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/09/2020 07:58:15 PM
// Design Name: 
// Module Name: top_module
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


module top_module(
    input clk100m,
    input rst,
    input sel12_24,
    input alarm_open,
    input BTNC,
    input BTNU,
    input BTNL,
    input BTNR,
    input BTND,
    input fast_clock,
    output [7:0] segcode,
    output [7:0] bitcode,
    output AUD_PWM,
    output baoshi
    );
    wire clk_1ms,pulse_8ms,pulse_1s,pulse_2m,clk_1s,pulse_100ms,pulse_second;
    wire [63:0] buffer;
    wire [55:0] clock_buffer,alarm_buffer;
    wire [15:0] display_ctr;
    wire [5:0] seconds,minutes,alarm_minute;
    wire [4:0] hours,show_hours,alarm_hour,show_alarm_hour;
    wire [3:0] second_h,second_l,minute_h,minute_l,hour_h,hour_l;
    wire [3:0] alarm_minute_h,alarm_minute_l,alarm_hour_h,alarm_hour_l;
    wire second_co,minute_co,hour_co;
    wire minute_add,minute_dec,hour_add,hour_dec;
    wire alarm_hour_add,alarm_minute_add,alarm_hour_dec,alarm_minute_dec;
    wire hour_rst,minute_rst,second_rst,alarm_hour_rst,alarm_minute_rst;
    wire alarm_status;
    wire single_click_center,double_click_center,long_press_center,
        single_click_up,double_click_up,long_press_up,
        single_click_down,double_click_down,long_press_down,
        single_click_left,double_click_left,long_press_left,
        single_click_right,double_click_right,long_press_right;
    wire [2:0] ctr_status;
    
    assign pulse_second=fast_clock?pulse_1s:pulse_100ms;
    
    assign show_hours=sel12_24&&hours>12?hours-12:(sel12_24&&hours==0?12:hours);
    assign clock_buffer[55:48]=sel12_24?(hours>=12?8'b00110001:8'b00010001):8'b11111111;
    assign second_h=seconds/10;
    assign second_l=seconds%10;
    assign minute_h=minutes/10;
    assign minute_l=minutes%10;
    assign hour_h=show_hours/10;
    assign hour_l=show_hours%10;
    
    assign baoshi=(minutes==59&&seconds>=60-hours-1)&clk_1s;
    
    assign show_alarm_hour=sel12_24&&alarm_hour>12?alarm_hour-12:(sel12_24&&hours==0?12:hours);
    assign alarm_buffer[55:48]=sel12_24?(alarm_hour>=12?8'b00110001:8'b00010001):8'b11111111;
    assign alarm_minute_h=alarm_minute/10;
    assign alarm_minute_l=alarm_minute%10;
    assign alarm_hour_h=alarm_hour/10;
    assign alarm_hour_l=alarm_hour%10;
    
    assign buffer[55:0]=ctr_status[2]?alarm_buffer:clock_buffer;
    
    num_decoder decoder_hour_h(hour_h,clock_buffer[47:40]);
    num_decoder decoder_hour_l(hour_l,clock_buffer[39:32]);
    num_decoder decoder_minute_h(minute_h,clock_buffer[31:24]);
    num_decoder decoder_minute_l(minute_l,clock_buffer[23:16]);
    num_decoder decoder_second_h(second_h,clock_buffer[15:8]);
    num_decoder decoder_second_l(second_l,clock_buffer[7:0]);
    
    num_decoder decoder_alarm_hour_h(alarm_hour_h,alarm_buffer[47:40]);
    num_decoder decoder_alarm_hour_l(alarm_hour_l,alarm_buffer[39:32]);
    num_decoder decoder_alarm_minute_h(alarm_minute_h,alarm_buffer[31:24]);
    num_decoder decoder_alarm_minute_l(alarm_minute_l,alarm_buffer[23:16]);
    
    num_decoder decoder_ctr_status({1'b0,ctr_status},buffer[63:56]);
    
    diver #(100000) div_1ms(clk100m,rst,clk_1ms);
    diver #(100000000) div_1s(clk100m,rst,clk_1s);
    pulse_clk #(100000000) pulse_1s_obj(clk100m,rst,pulse_1s);
    pulse_clk #(10000000) pulse_100ms_obj(clk100m,rst,pulse_100ms);
    pulse_clk #(800000) pulse_8ms_obj(clk100m,rst,pulse_8ms);
    pulse_clk #(25) pulse_2m_obj(clk100m,rst,pulse_2m);
    display displayer(clk_1ms,rst,buffer,display_ctr,segcode,bitcode);
    
    counter #(60) (clk100m,second_rst,pulse_second,0,0,seconds,second_co);
    counter #(60) (clk100m,minute_rst,second_co,minute_add,minute_dec,minutes,minute_co);
    counter #(24) (clk100m,hour_rst,minute_co,hour_add,hour_dec,hours,hour_co);
    
    key_detect key_center(clk100m,rst,pulse_8ms,BTNC,single_click_center,double_click_center,long_press_center);
    key_detect key_up(clk100m,rst,pulse_8ms,BTNU,single_click_up,double_click_up,long_press_up);
    key_detect key_down(clk100m,rst,pulse_8ms,BTND,single_click_down,double_click_down,long_press_down);
    key_detect key_left(clk100m,rst,pulse_8ms,BTNL,single_click_left,double_click_left,long_press_left);
    key_detect key_right(clk100m,rst,pulse_8ms,BTNR,single_click_right,double_click_right,long_press_right);
    
    main_ctr main_control(clk100m,rst,
        single_click_up,single_click_down,single_click_left,single_click_right,single_click_center,
        double_click_up,double_click_down,double_click_left,double_click_right,double_click_center,
        long_press_up,long_press_down,long_press_left,long_press_right,long_press_center,
        hour_rst,minute_rst,second_rst,alarm_hour_rst,alarm_minute_rst,
        display_ctr,hour_add,minute_add,hour_dec,minute_dec,
        alarm_hour_add,alarm_minute_add,alarm_hour_dec,alarm_minute_dec,ctr_status);
    
    alarm alarm_obj(clk100m,rst,alarm_open,hours,minutes,
        alarm_hour_add,alarm_minute_add,alarm_hour_dec,alarm_minute_dec,
        alarm_hour,alarm_minute,alarm_status);
        
    music_player player(clk100m,rst,pulse_2m,alarm_status,AUD_PWM);
endmodule
