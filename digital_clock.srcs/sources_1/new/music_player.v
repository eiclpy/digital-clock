`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2020 02:54:04 PM
// Design Name: 
// Module Name: music_player
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


module music_player #(
    parameter FILEPATH="C:\\Users\\lpy\\Desktop\\digitalcircuit\\digital_clock2\\alarm.txt",
    integer FILESIZE=48000
)(
    input clk,
    input rst,
    input play_pulse,
    input play_ctr,
    output pwm_out
    );
    reg play_sta;
    reg [7:0] cnter;
    reg [$clog2(FILESIZE+1)-1:0] play_idx;
    reg [7:0] play_memory[0:FILESIZE-1];
    assign pwm_out=(play_memory[play_idx]>cnter)&play_sta;
    initial
        $readmemh(FILEPATH,play_memory,0,FILESIZE-1);
    always@(posedge clk or negedge rst)
    begin
        if(!rst)
        begin
            cnter<=0;
            play_idx<=0;
            play_sta<=0;
        end
        else if(play_pulse)
        begin
            cnter<=cnter+1;
            play_idx<=cnter==255?(play_idx<FILESIZE-1?play_idx+1:0):play_idx;
        end
        else if(play_ctr)
        begin
            if(play_sta==0)
            begin
                cnter<=0;
                play_idx<=0;
                play_sta<=1;
            end
        end
        else
        begin
            play_sta<=0;
        end
    end
endmodule
