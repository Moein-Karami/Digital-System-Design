`timescale 1ns/1ns

module K1BarTB();
	reg clk, reset;
	reg a1, b1, e0, expected_k1_bar;
	wire k1_bar, a1_bar;
	reg [10:0] vector_ind, num_of_errors, num_of_tests;
	reg [3:0] test_vectors[1000:0];

	MyInverter my_inverter(a1, a1_bar);
	My3Nand my_3_nand(a1_bar, b1, e0, k1_bar);

	initial
	begin
		$readmemb("K1BarTV.tv", test_vectors);
		vector_ind = 0;
		num_of_errors = 0;
		num_of_tests = 112;
		reset = 1;
		#100;
		reset = 0;
	end
	
	always
	begin
		clk = 1;
		#50;
		clk = 0;
		#50;
	end

	always @(posedge clk & ~reset)
	begin 
		#1;
		{a1, b1, e0, expected_k1_bar} = test_vectors[vector_ind];
	end

	always @(negedge clk & ~reset)
	begin
		if (expected_k1_bar !== k1_bar)
		begin 
			num_of_errors = num_of_errors +1;
			$display("Wrong, Inputs: %b", {a1, b1, e0});
			$display("Outpout: %b, Expected %b", k1_bar, expected_k1_bar);
		end
		vector_ind = vector_ind + 1;
		if (vector_ind === num_of_tests)
		begin 
			$display("%d tests complited with %d errors", vector_ind, num_of_errors);
			$stop;
		end
	end
endmodule