`timescale 1ns/1ns

module BCSBasedComparator(input [7 : 0] a, [7 : 0] b, output EQ, GT);
	wire [8 : 0] e, g;
	assign e[8] = 1;
	assign g[8] = 0;
	assign EQ = e[0];
	assign GT = g[0];
	genvar i;
	generate
		for (i = 7; i >= 0; i--) begin : Comparator
			GateLevelBCS XX (a[i], b[i], e[i + 1]
					, g[i + 1], e[i], g[i]);
		end
	endgenerate
endmodule