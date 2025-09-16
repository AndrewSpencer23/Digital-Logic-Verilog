 module flag(
input wire clk,
input wire fastClk,
input wire [1:0] state, 
input wire [4:0] userguess,
input wire [4:0] RnG,
input wire [2:0] triesLED,
output wire flag,
output wire [7:0] HEX5g,
output wire [7:0] HEX4g
);

	reg flag_reg;
	reg [7:0] HEX5g_reg;
	reg [7:0] HEX4g_reg;

	always @(posedge fastClk) begin
	
		if((triesLED == 3'b000 || userguess == RnG)) begin
			flag_reg = 1;
		end
			
		if((triesLED > 3'b000 || state == 2'b00) && userguess != RnG)begin
			flag_reg = 0;
			if(userguess > RnG) begin
				flag_reg = 0; 
				HEX4g_reg = 8'b11001111; //I
				HEX5g_reg = 8'b10001001; //H
			end 
		
			if(userguess < RnG)begin
				flag_reg = 0; 
				HEX4g_reg = 8'b10100011;  //o
				HEX5g_reg = 8'b11000111;  //L
			end
		end
	end
	
	assign flag = flag_reg;
	assign HEX4g = HEX4g_reg;
	assign HEX5g = HEX5g_reg;
endmodule