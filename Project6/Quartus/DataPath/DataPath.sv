module DataPath(input [9 : 0]x, input [7 : 0]y, input clk, rst, cnt_en, cnt_init0, sel_rom, sel_x,
		reg_x_ld, reg_y_ld, reg_tmp_ld, invert, minus, reg_res_ld, reg_tmp_init1, reg_res_init1,
		output [9 : 0]result, output parity, stop_sign);

		wire [9 : 0]rom_out;
		wire [9 : 0]mult_x;
		wire [9 : 0]my_x;
		wire [9 : 0]sel_data;
		wire [9 : 0]my_y;
		wire [9 : 0]nxt_tmp;
		wire [9 : 0]tmp;
		wire [9 : 0]iter;
		wire [9 : 0]nxt_res;

	MyData my_data(.clk(clk), .rst(rst), .en(cnt_en), .init0(cnt_init0), .parity(parity), .out(rom_out));
	Mux mux(.in_rom(rom_out), .in_x(my_x), .sel_rom(sel_rom), .sel_x(sel_x), .sel_data(sel_data));
	Mult mult1(.a(x), .b(x), .ans(mult_x));
	Reg reg_x(.clk(clk), .rst(rst), .ld(reg_x_ld), .in(mult_x), .out(my_x));
	Mult mult2(.a(sel_data), .b(tmp), .ans(nxt_tmp));
	Reg reg_y(.clk(clk), .rst(rst), .ld(reg_y_ld), .in({1'b0, 1'b0, y}), .out(my_y));
	Inverter inverter(.in(tmp), .invert(invert), .out(iter));
	Cmp cmp(.a(tmp), .b(my_y), .lt(stop_sign));
	RegWithInit1 reg_tmp(.clk(clk), .rst(rst), .ld(reg_tmp_ld), .init1(reg_tmp_init1), .in(nxt_tmp), .out(tmp));
	RegWithInit1 reg_res(.clk(clk), .rst(rst), .ld(reg_res_ld), .init1(reg_res_init1), .in(nxt_res), .out(result));
	Adder adder(.a(iter), .b(result), .cin(minus), .ans(nxt_res));
endmodule

module MyData(input clk, rst, en, init0, output parity, output [9 : 0]out);
	wire [1 : 0]cnt_out;
	assign parity = cnt_out[0];
	Counter counter(.clk(clk), .rst(rst), .en(en), .init0(init0), .out(cnt_out));
	Rom rom(.clock(clk), .address(cnt_out), .q(out[7 : 0]));
	assign out[9 : 8] = {1'b0, 1'b0};
endmodule

module Counter(input clk, rst, en, init0, output logic [1 : 0]out);
	always @(posedge clk, posedge rst)
	begin
		if (rst === 1'b1)
			out <= 2'b00;
		else
		begin
			if (init0 === 1'b1)
				out <= 2'b00;
			else if(en)
			begin
				case(out)
					2'b00: out <= 2'b01;
					2'b01: out <= 2'b10;
					2'b10: out <= 2'b11;
					2'b11: out <= 2'b00;
				endcase
			end
		end
	end
endmodule

module Mult(input [9 : 0]a, input [9 : 0]b, output [9 : 0]ans);
	wire [19 : 0]tmp;
	assign tmp = a * b;
	assign ans = tmp[17 : 8];
endmodule

module Reg(input clk, rst, ld, input [9 : 0]in, output logic [9 : 0]out);
	always @(posedge clk, posedge rst)
	begin
		if (rst === 1'b1)
			out <= 10'b0;
		else
			out <= in;
	end
endmodule

module RegWithInit1(input clk, rst, ld, init1, input [9 : 0]in, output logic [9 : 0]out);
	always @(posedge clk, posedge rst)
	begin
		if (rst === 1'b1)
			out <= 10'b0000000000;
		else
		begin
			if (init1 === 1'b1)
				out <= 10'b0100000000;
			else
				out <= ld ? in : out;
		end
	end
endmodule

module Mux(input sel_rom, sel_x, input [9 : 0]in_rom, input [9 : 0]in_x, output logic [9 : 0]sel_data);
	always @(sel_rom, sel_x)
	begin
		sel_data <= 10'b0;
		if (sel_rom === 1'b1)
			sel_data <= in_rom;
		else if (sel_x === 1'b1)
			sel_data <= in_x;
	end
endmodule

module Cmp(input [9 : 0]a, input[9 : 0]b, output lt);
	assign lt = (a < b) ? 1'b1 : 1'b0;
endmodule

module Inverter(input [9 : 0]in, input invert, output [9 : 0]out);
	genvar i;
	generate
		for (i = 0 ; i < 10; i++) begin : Invert
			assign out[i] = in[i] ^ invert;
		end
	endgenerate
endmodule

module Adder(input [9 : 0]a, input [9 : 0]b, input cin, output[9 : 0]ans);
	assign ans = a + b + cin;
endmodule
