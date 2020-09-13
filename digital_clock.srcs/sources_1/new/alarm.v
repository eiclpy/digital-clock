`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2020 10:20:35 AM
// Design Name: 
// Module Name: alarm
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


module alarm(
    input clk,
    input rst,
    input alarm_open,
    input [4:0] hour,
    input [5:0] minute,
    input alarm_hour_add,
    input alarm_minute_add,
    input alarm_hour_dec,
    input alarm_minute_dec,
    output reg [4:0] alarm_hour,
    output reg [5:0] alarm_minute,
    output reg alarm_status
    );
    always@(posedge clk or negedge rst)
    begin
        if(!rst)
        begin
            alarm_hour<=0;
            alarm_minute<=0;
        end
        else if(alarm_hour_add)
        begin
            alarm_hour<=alarm_hour+1;
        end
        else if(alarm_hour_dec)
        begin
            alarm_hour<=alarm_hour-1;
        end
        else if(alarm_minute_add)
        begin
            alarm_minute<=alarm_minute+1;
        end
        else if(alarm_minute_dec)
        begin
            alarm_minute<=alarm_minute-1;
        end
        else if(alarm_hour==hour&&alarm_minute==minute&&alarm_open)
        begin
            alarm_status<=1;
        end
        else
        begin
            alarm_status<=0;
        end
    end
endmodule
