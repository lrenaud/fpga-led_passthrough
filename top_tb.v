`timescale 100ps/1ps
//`include "top.v"

module top_tb;

	reg tb_clk;
	always #5 tb_clk = (tb_clk === 1'b0);

	reg [3:0] tb_sw;
	wire user_led;
	wire [3:0] tb_leds;
	wire user_usb;

	top U_top (
		tb_clk,
		tb_sw,
		user_led,
		tb_leds,
		user_usb
	);

	reg [4095:0] vcdfile;
	initial begin
		if ($value$plusargs("vcd=%s", vcdfile)) begin
			$dumpfile(vcdfile);
			$dumpvars(1, U_top.SW, U_top.LED_USER, U_top.brightness, U_top.LED_0, U_top.LED_1, U_top.LED_2, U_top.LED_3);
		end

		tb_sw = 4'b1111;

		repeat (20) @(posedge tb_clk);

		$display("starting.");
		repeat (1_10) begin
			repeat (1_1000) begin
				repeat (16) @(posedge tb_clk);
			end 
			//$display(".");
		end

		$display("done!");
		$finish;
	end

endmodule