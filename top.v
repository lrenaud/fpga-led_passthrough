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
    // Make a simple counter
    ////////

    // keep track of time and location in blink_pattern
    reg [(30-1):0] mag_counter;
	wire [(16-1):0] brightness;
	wire [(16-1):0] fast_clock;

	wire LED_0;
	wire LED_1;
	wire LED_2;
	wire LED_3;

	assign brightness[3:0]		= mag_counter[(30-7):(30-10)];
	assign brightness[7:4]		= mag_counter[(30-5):(30-8)];
	assign brightness[11:8]		= mag_counter[(30-3):(30-6)];
	assign brightness[15:12]	= mag_counter[(30-1):(30-4)];
	
	// Fast clock should cycle fully >60Hz
	// 16MHz / 60Hz = 266,666.6 = 2^18.024
	// So let's use the bottom 16 bits to 
	assign fast_clock[(16-1):0] = mag_counter[(16-1):0];
	
	wire [3:0] sw_pwm = fast_clock[15:12];
	assign LED_0 = (brightness[ 3: 0] > sw_pwm) & SW[0];
	assign LED_1 = (brightness[ 7: 4] > sw_pwm) & SW[1];
	assign LED_2 = (brightness[11: 8] > sw_pwm) & SW[2];
	assign LED_3 = (brightness[15:12] > sw_pwm) & SW[3];

    // pattern that will be flashed over the LED over time
    wire [30:0] blink_pattern = 30'b0101_0100_0111_0111_0111_0001_0101;

	initial begin
		mag_counter <= 0;
	end

    // increment the blink_counter every clock
    always @(posedge CLK) begin
        mag_counter <= mag_counter + 1;
    end
    
    // light up the LED according to the pattern
    assign LED_USER = blink_pattern[mag_counter[25:21]];

	/**************************************************************************/
	/**************************************************************************/

	led_map U_BUS_ASSIGNMENT(
		{LED_0, LED_1, LED_2, LED_3},
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
