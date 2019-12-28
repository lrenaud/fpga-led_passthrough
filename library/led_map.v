module led_map (
	input [3:0] switch,
	output [3:0] led
);

	assign led = switch;

endmodule