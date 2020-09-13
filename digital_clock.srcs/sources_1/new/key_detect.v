`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/09/2020 08:51:58 PM
// Design Name: 
// Module Name: key_detect
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


module key_detect(
    input clk,
    input rst,
    input pulse_8ms,
    input key,
    output reg s,
    output reg d,
    output reg l
    );
    parameter integer click_delta=20,long_press_low=85,long_press_high=100,val_limit=200;
    reg [7:0] key_up,key_down;
    wire [7:0] next_key_up,next_key_down;
    assign next_key_up=key==0&&key_up<val_limit?key_up+1:key_up;
    assign next_key_down=key==1&&key_down<val_limit?key_down+1:key_down;
    always@(posedge clk or negedge rst)
        if(!rst)
        begin
            s<=0;
            d<=0;
            l<=0;
            key_up<=val_limit;
            key_down<=0;
        end
        else if(pulse_8ms)
        begin
            if(next_key_down==2)
            begin
                if(next_key_up<click_delta)
                begin
                    key_up<=0;
                    key_down<=long_press_high+10;
                    d<=1;
                end
                else
                begin
                    key_up<=0;
                    key_down<=next_key_down;
                end
            end
            else if(next_key_down==long_press_high)
            begin
                key_down<=long_press_low;
                key_up<=next_key_up;
                l<=1;
            end
            else if(next_key_up==2)
            begin
                if(next_key_down>=long_press_low)
                begin
                    key_up<=50;
                    key_down<=0;
                end
                else
                begin
                    key_up<=next_key_up;
                    key_down<=0;
                end
            end
            else if(next_key_up==click_delta)
            begin
                s<=1;
                key_up<=next_key_up;
                key_down<=next_key_down;
            end
            else
            begin
                key_up<=next_key_up;
                key_down<=next_key_down;
            end
        end
        else
        begin
            s<=0;
            d<=0;
            l<=0;
        end
endmodule
