 module makeGuess(
input wire clk,
input wire buttonInc,
input wire buttonSel, 
input wire [1:0]state,
output wire [2:0]triesLED, 
output wire [7:0]HEX0g,
output wire [4:0]userguess
);
	
	reg [4:0] userguess_reg;
	reg [7:0] HEX0g_reg;
	reg [4:0] hex0;
	reg [1:0] tries;
	wire [7:0] HEX0gw;
	reg [2:0] triesLED_reg;
	
	always@(posedge clk)begin
		HEX0g_reg = HEX0gw;
		
		if(state == 2'b00)begin
			userguess_reg = 5'b11111;
			hex0 = 0;
			triesLED_reg = 3'b111;
			tries = 2'b11;
		end
		
		if(state == 2'b01)begin
		 
			if(buttonInc)begin
				if(hex0 == 5'd9)begin
					hex0 = 0;		
				end else begin
					hex0 = hex0 + 1;
				end
			end
			
			if(buttonSel)begin
				userguess_reg = hex0;
				hex0 = 0;
				tries = tries - 1;
			end
		end

		case(tries)
			2'b11:
				triesLED_reg = 3'b111;
			2'b10:
				triesLED_reg = 3'b011;
			2'b01:
				triesLED_reg = 3'b001;
			2'b00:
				triesLED_reg = 3'b000;
		endcase
		
	end
	
	assign triesLED = triesLED_reg;
	assign HEX0g = HEX0g_reg;
	assign userguess = userguess_reg;
	
	sevenSeg M1(.num(hex0), .seg(HEX0gw));
	
endmodule