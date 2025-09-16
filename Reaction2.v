module Reaction2(Clock, state, flag, LEDn, Digit1, Digit0);

	input Clock;
	input [1:0] state;
	output reg flag;
	output wire [9:0] LEDn;
	output wire [6:0] Digit1, Digit0;
	
	
	parameter idle = 2'b00;
	parameter delay = 2'b01;
	parameter timing = 2'b10;
	parameter display = 2'b11;
	
	reg [9:0] led;
	reg [3:0] bcd1, bcd0;
	reg [9:0] myRand;
	reg [9:0] k;

	always @(posedge Clock)
	
		begin
			if (state == idle)
				begin
					led[9:0] <= 10'b0000000000;
					bcd1 <= 0;
					bcd0 <= 0;
					flag <= 0;
					k <= 0;
					myRand <= myRand + 11;
					
				end
			
			else if (state == delay)
				begin
					led[9:0] <= 10'b1000000000;
					bcd1 <= 0;
					bcd0 <= 0;
					myRand <= myRand;
					k <= k + 1;
					
					if (k > myRand%400) // Max of 4 seconds b/c 100 Hz
						flag <= 1;
						
					else 
						flag <= 0;
						
				end
			
			else if (state == timing)
				begin
					led[9:0] <= 10'b1111111111;
					flag <= 0;
					
					if (bcd0 == 4'b1001)
						begin
							bcd0 <= 0;
							
							if (bcd1 == 4'b1001)
								bcd1 <= 0;	
							else
								bcd1 <= bcd1 + 1;
						end
					
					else
						bcd0 <= bcd0 + 1;
					
				end
			
			else if (state == display)
				begin
					led[9:0] <= 10'b1010101010;
					bcd1 <= bcd1;
					bcd0 <= bcd0;
					flag <= 0;
					k <= 0;
					myRand <= 0;
				end
				
			else // Error state
				begin
					led[9:0] <= 10'b1111100000;
					flag <= 0;
					k <= k;
					myRand <= myRand;
					bcd1 <= 4'b1000;
					bcd0 <= 4'b1000;
				end
			
		end
		
		assign LEDn = led;
		
		seg7 seg1(bcd1, Digit1);
		seg7 seg0(bcd0, Digit0);

endmodule