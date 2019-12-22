// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top (
    input CLK,		// 16MHz clock
	// inout for pullup
	input SW1,
	input SW2,
	input SW3,
	input SW4,
    output LED_USER,	// User/boot LED next to power LED
	output LED1,
	output LED2,
	output LED3,
	output LED4,
    output USBPU	// USB pull-up resistor
);
    // drive USB pull-up resistor to '0' to disable USB
    assign USBPU = 0;

    ////////
    // make a simple blink circuit
    ////////

    // keep track of time and location in blink_pattern
    reg [25:0] blink_counter;

    // pattern that will be flashed over the LED over time
    wire [31:0] blink_pattern = 32'b0101_0100_0111_0111_0111_0001_0101;

    // increment the blink_counter every clock
    always @(posedge CLK) begin
        blink_counter <= blink_counter + 1;
    end
    
    // light up the LED according to the pattern
    assign LED_USER = blink_pattern[blink_counter[25:21]];

	assign {LED1,LED2,LED3,LED4} = {SW1,SW2,SW3,SW4};

endmodule
