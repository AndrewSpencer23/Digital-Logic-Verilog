// Module that creates a 100 hz clock

module ClockDivider100(clk, clk100Hz);
	input clk;
	output reg clk100Hz;
	
	reg [27:0] counter = 28'd0;
	parameter cnew = 500000; // 50 MHz / 500k = 100Hz
	
	always @(posedge clk)
		begin
			counter <= counter + 28'd1;
			
			if (counter >= (cnew - 1))
				counter <= 28'd0;
			
			clk100Hz <= (counter < cnew/2) ? 1'b1 : 1'b0;
		end

endmodule