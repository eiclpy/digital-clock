`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2020 08:54:26 AM
// Design Name: 
// Module Name: counter
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


module counter #(
    parameter integer BASE=60
)(
    input clk,
    input rst,
    input clk_pulse,
    input add_pulse,
    input dec_pulse,
    output reg [$clog2(BASE+1)-1:0] Q,
    output reg CO
    );
    always@(posedge clk or negedge rst)
    begin
        if(!rst)
        begin
            Q<=0;
            CO<=0;
        end
        else if(clk_pulse)
            if(Q==BASE-1)
            begin
                Q<=0;
                CO<=1;
            end
            else
            begin
                Q<=Q+1;
                CO<=0;
            end
        else if(add_pulse)
            if(Q==BASE-1)
                Q<=0;
            else
                Q<=Q+1;
        else if(dec_pulse)
            if(Q==0)
                Q<=BASE-1;
            else
                Q<=Q-1;
        else
            CO<=0;
    end
    
endmodule
