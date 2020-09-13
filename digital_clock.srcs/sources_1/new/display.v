`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2020 10:52:36 PM
// Design Name: 
// Module Name: display
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


module display(
    input clk,
    input rst,
    input [63:0] display_buffer,
    input [15:0] display_ctr,
    output [7:0] segcode,
    output reg [7:0] bitcode
    );
    reg [2:0] display_idx;
    reg [7:0] segcode_reg;
    reg [8:0] bling;
    assign segcode=rst?segcode_reg:8'b11111111;
    always@(posedge clk or negedge rst)
    begin
        if(!rst)
            display_idx<=0;
        else
        begin
            display_idx<=display_idx+1;
            bling<=bling+1;
            case(display_idx)
            3'b000:begin
                segcode_reg<=display_ctr[0]?
                    (!(bling[8]&bling[7])?display_buffer[7:0]:8'b11111111):
                    (display_ctr[1]?8'b11111111:display_buffer[7:0]);
                bitcode<=8'b11111110;
            end
            3'b001:begin
                segcode_reg<=display_ctr[2]?
                    (!(bling[8]&bling[7])?display_buffer[15:8]:8'b11111111):
                    (display_ctr[3]?8'b11111111:display_buffer[15:8]);
                bitcode<=8'b11111101;
            end
            3'b010:begin
                segcode_reg<=display_ctr[4]?
                    (!(bling[8]&bling[7])?display_buffer[23:16]:8'b11111111):
                    (display_ctr[5]?8'b11111111:display_buffer[23:16]);
                bitcode<=8'b11111011;
            end
            3'b011:begin
                segcode_reg<=display_ctr[6]?
                    (!(bling[8]&bling[7])?display_buffer[31:24]:8'b11111111):
                    (display_ctr[7]?8'b11111111:display_buffer[31:24]);
                bitcode<=8'b11110111;
            end
            3'b100:begin
                segcode_reg<=display_ctr[8]?
                    (!(bling[8]&bling[7])?display_buffer[39:32]:8'b11111111):
                    (display_ctr[9]?8'b11111111:display_buffer[39:32]);
                bitcode<=8'b11101111;
            end
            3'b101:begin
                segcode_reg<=display_ctr[10]?
                    (!(bling[8]&bling[7])?display_buffer[47:40]:8'b11111111):
                    (display_ctr[11]?8'b11111111:display_buffer[47:40]);
                bitcode<=8'b11011111;
            end
            3'b110:begin
                segcode_reg<=display_ctr[12]?
                    (!(bling[8]&bling[7])?display_buffer[55:48]:8'b11111111):
                    (display_ctr[13]?8'b11111111:display_buffer[55:48]);
                bitcode<=8'b10111111;
            end
            3'b111:begin
                segcode_reg<=display_ctr[14]?
                    (!(bling[8]&bling[7])?display_buffer[63:56]:8'b11111111):
                    (display_ctr[15]?8'b11111111:display_buffer[63:56]);
                bitcode<=8'b01111111;
            end
            endcase
        end
    end
endmodule
