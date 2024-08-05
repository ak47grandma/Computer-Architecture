`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/04 22:40:29
// Design Name: 
// Module Name: top
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

`define RAM_WIDTH  8                       // Specify RAM data width
`define RAM_DEPTH 128
`define ROWS 4
`define COLS 4
`define WEST_DW 8
`define NORTH_DW 8

module top(
    input clk,
    input rst,
    input start,
    input [clogb2(`RAM_DEPTH-1)-1:0] addrb_w[0:`ROWS-1],
    input [clogb2(`RAM_DEPTH-1)-1:0] addrb_n[0:`COLS-1],
    output [`RAM_WIDTH-1:0] psu_out[0:3]
    );
    
    wire [8-1:0] west_in [4-1:0];
    wire [8-1:0] north_in[4-1:0];
    
    genvar i;
    generate
        for (i = 0; i < `ROWS; i = i + 1) begin : bram_west
            bram_sdp BW (
                .i_clk(clk),
                .start(start),
                .addrb(addrb_w[i]),
                .doutb(west_in[i])
            );
        end
    endgenerate

    generate
        for (i = 0; i < `COLS; i = i + 1) begin : bram_north
            bram_sdp BN (
                .i_clk(clk),
                .start(start),
                .addrb(addrb_n[i]),
                .doutb(north_in[i])
            );
        end
    endgenerate

    function integer clogb2;
        input integer depth;
        for (clogb2=0; depth>0; clogb2=clogb2+1)
             depth = depth >> 1;
    endfunction
    
    systolic_array uut(.clk(clk), .rst(rst), .west_in(west_in), .north_in(north_in), .psu_out(psu_out));
    
endmodule
