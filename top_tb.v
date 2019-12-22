
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
			$dumpvars(0, top_tb);
		end

		tb_sw = 4'b0000;

		repeat (20) @(posedge tb_clk);

		$display("starting.");
		repeat (16) begin
			repeat (10) @(posedge tb_clk);
			tb_sw = (1 + tb_sw);
		end 

		repeat (20) @(posedge tb_clk);
		$display("done!");
		$finish;
	end

endmodule