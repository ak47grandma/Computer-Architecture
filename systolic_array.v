`define ROWS 4
`define COLS 4
`define WEST_DW 8
`define NORTH_DW 8

module systolic_array(
    // common signals
    input    clk,
    input    rst,
    // input activations from shared buffer
    input    [`WEST_DW-1:0] west_in [`ROWS-1:0],
    // weights (index) from external
    input    [`NORTH_DW-1:0] north_in[`COLS-1:0],
    // output partial sums
    output   [15:0] psu_out[`COLS-1:0]
    );
	

	wire [15:0] result[0:`ROWS-1][0:`COLS-1];
	
	    // connections for PE
    wire [`WEST_DW-1:0] row_connections[`ROWS-1:0][`COLS-1:0];
    wire [`NORTH_DW-1:0] col_connections[`ROWS-1:0][`COLS-1:0];
	
    genvar r, c;
    generate
        // systolic PEs
        for (r = 0; r < `ROWS; r = r + 1) begin
            for (c = 0; c < `COLS; c = c + 1) begin
                if ((r == 0) && (c == 0)) begin
                    // left top
                    block dsp_pe_lt_inst (
                        .clk       (clk),
                        .rst       (rst),
                        .inp_north   (north_in[r]),
                        .inp_west    (west_in[c]),
                        .outp_east (row_connections[r][c]),
                        .outp_south(col_connections[r][c]),
                        .result(result[r][c])
                    );
                end else if (c == 0) begin
                    // first column
                    block dsp_pe_fc_inst (
                        .clk       (clk),
                        .rst       (rst),
                        .inp_north   (north_in[r]),
                        .inp_west    (col_connections[r-1][c]),
                        .outp_east (row_connections[r][c]),
                        .outp_south(col_connections[r][c]),
                        .result(result[r][c])
                    );
                end else if (r == 0) begin
                    // first row
                    block dsp_pe_fr_inst (
                        .clk       (clk),
                        .rst       (rst),
                        .inp_north   (row_connections[r][c-1]),
                        .inp_west    (west_in[c]),
                        .outp_east (row_connections[r][c]),
                        .outp_south(col_connections[r][c]),
                        .result(result[r][c])
                    );
                end else begin
                    // normal PE
                    block dsp_pe_nm_inst (
                        .clk       (clk),
                        .rst       (rst),
                        .inp_north   (row_connections[r][c-1]),
                        .inp_west    (col_connections[r-1][c]),
                        .outp_east (row_connections[r][c]),
                        .outp_south(col_connections[r][c]),
                        .result(result[r][c])
                    );
                end
            end
        end
    endgenerate

    generate
        for (c = 0; c < `COLS; c=c+1) begin
            assign psu_out[c] = result[`ROWS-1][c];
        end
    endgenerate
	
		      
endmodule
