module led_scroller(
    input clk,    
    output reg [6:0] leds
);

	reg [3:0] counter;

	reg [6:0] led_pattern;

	initial begin
		led_pattern = 7'b0000001;  
		counter = 4'b0000; 
	end
	
	always @(posedge clk) begin
	
		if (counter == 4'b1111) begin
			led_pattern <= {led_pattern[5:0], led_pattern[6]};
			counter <= 4'b0000; 
		end else begin
			counter <= counter + 1;
		end
		
		leds <= led_pattern;
end

endmodule