module led_map_block (
	input [3:0] switch,
	output [3:0] led,
);

	assign led = switch;

endmodule