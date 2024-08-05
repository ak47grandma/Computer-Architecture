`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/01 23:39:35
// Design Name: 
// Module Name: block
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
module block(inp_north, inp_west, clk, rst, outp_south, outp_east, result);
	input clk, rst;
	input [7:0] inp_north, inp_west;
	output reg [7:0] outp_south, outp_east;
	output reg [15:0] result;
	wire [15:0] multi;
	always @(posedge clk) begin
		if(!rst) begin
			result <= 0;
			outp_east <= 0;
			outp_south <= 0;
		end
		else begin
			result <= result + multi;
			outp_east <= inp_west;
			outp_south <= inp_north;
		end
	end
	assign multi = inp_north*inp_west;
endmodule