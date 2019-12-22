`include "library/led_map.v"

// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top (
    input CLK,		// 16MHz clock
	// inout for pullup
	input [3:0] SW,
    output LED_USER,	// User/boot LED next to power LED
	output [3:0] LED_BUS,
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

	/**************************************************************************/
	/**************************************************************************/

	led_map_block U_BUS_ASSIGNMENT(
		SW,
		LED_BUS
	);

	//assign LED_BUS[0] = | SW_BUS;
	//assign LED_BUS[1] = & SW_BUS;
	//assign LED_BUS[2] = ^ SW_BUS;
	//assign LED_BUS[3] = SW_BUS[3];

	//assign LED_BUS = SW_BUS;

	//assign {LED1,LED2,LED3,LED4} = {SW1,SW2,SW3,SW4};
	
	/**************************************************************************/
	/**************************************************************************/

endmodule
