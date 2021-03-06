`timescale 1ns/1ps

module FinalTB();
	logic clk, rst, start;
	logic [9 : 0]x;
	logic [7 : 0]y;
	wire ready;
	wire [9 : 0]result;

	Cosinus cosinus(.clk(clk), .rst(rst), .start(start), .x(x), .y(y), .ready(ready), .result(result));

	always #100 clk = ~clk;

	initial
	begin
		clk = 0;
		rst = 0;
		start = 0;
		x = 10'b0;
		y = 10'b0;
		#200;
		start = 1;
		x = 10'b0100000000;
		y = 8'b00000001;
		#200;
		start = 0;
		#5000;
		start = 1;
		x = 10'b0110000000;
		y = 8'b0100000;
		#200;
		start = 0;
		#5000;
		start = 1;
		x = 10'b0010100100;
		y = 8'b0000100;
		#200;
		start = 0;
		#5000;
		$stop;
	end
endmodule