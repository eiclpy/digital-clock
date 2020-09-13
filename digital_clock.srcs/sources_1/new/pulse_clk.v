`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/09/2020 11:09:08 PM
// Design Name: 
// Module Name: pulse_clk
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


module pulse_clk #(
    parameter integer DIVBASE=32
)(
    input clk,
    input rst,
    output reg pulse
    );
    reg [$clog2(DIVBASE+1)-1:0] cnter;
    always@(posedge clk or negedge rst)
    begin
        if(!rst)
        begin
            cnter<=0;
        end
        else
        begin
            if(cnter==0)
            begin
                pulse<=1;
                cnter<=DIVBASE-1;
            end
            else
            begin
                pulse<=0;
                cnter<=cnter-1;
            end
        end
    end
endmodule
