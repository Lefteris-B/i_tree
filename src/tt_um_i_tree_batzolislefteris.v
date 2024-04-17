/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

module tt_um_i_tree_batzolislefteris(
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

	assign uio_oe  = 8'b0000_0000;
	assign uio_out = 8'b0000_0000;
	assign uo_out[7:1] = 7'b0000_000;
	

	i_tree i_tree_inst(
	    .clk(clk),
	    .reset(rst_n),
	    .sensor_data(ui_in[0]),
	    .anomaly_detected(uo_out[0])
	);

endmodule
