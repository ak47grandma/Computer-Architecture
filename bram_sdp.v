`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/04 16:18:52
// Design Name: 
// Module Name: bram_sdp
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
//  Xilinx Simple Dual Port Single Clock RAM
//  This code implements a parameterizable SDP single clock memory.
//  If a reset or enable is not necessary, it may be tied off or removed from the code.

module bram_sdp #(
    parameter RAM_WIDTH = 8,                       // Specify RAM data width
    parameter RAM_DEPTH = 128,                      // Specify RAM depth (number of entries)
    parameter INIT_FILE = ""                        // Specify name/location of RAM initialization file if using one (leave blank if not)
    ) (
    input i_clk,
    input start, 
    //input ena,
    //input wea,
    //input [clogb2(RAM_DEPTH-1)-1:0] addra, 
    //input [RAM_WIDTH-1:0] dina, 
    //input enb,
    input [clogb2(RAM_DEPTH-1)-1:0] addrb,                                                                          
    output [RAM_WIDTH-1:0] doutb         
    );
    // (* ram_style = "block" *)에 해당하는 pragma는 block ram (BRAM)을 쓸것인지 FPGA를 구성하는 LUT를 쓸것인지 선택할 수 있음
    // ex) (* ram_style = "block" *) : Instructs the tool to infer Block RAM type components.
    // (* ram_style = "distributed" *) : Instructs the tool to infer distributed LUT RAMs.
    
    (* ram_style = "block" *) reg [RAM_WIDTH-1:0] BRAM [RAM_DEPTH-1:0];
    reg [RAM_WIDTH-1:0] ram_data = {RAM_WIDTH{1'b0}};
    
    wire enb;
    // ena, wea가 high일때 입력된 어드레스에 dina가 저장됨.
    /*always @(posedge i_clk) begin
    if (ena) begin
        if (wea)
            BRAM[addra] <= dina;
        end
    end
*/    

    assign enb = (start==1) ? 1 : 0;
    
    always @(posedge i_clk) begin
        if (enb) begin
            ram_data <= BRAM[addrb];
        end
    end

    assign doutb = ram_data;
    
    // 이런식으로 function 구성하면 log2 함수를 사용할 수 있음.
    function integer clogb2;
    input integer depth;
        for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
    endfunction

endmodule	