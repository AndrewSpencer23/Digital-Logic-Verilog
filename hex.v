 module hex(
input wire clk,
input wire [1:0] state,
input wire [7:0] HEX0g,
input wire [7:0] HEX5g,
input wire [7:0] HEX4g,
input wire [7:0] HEX2r,
input wire [7:0] HEX5r,
input wire [7:0] HEX4r,
input wire [7:0] HEX3r,
input wire [7:0] HEX0r,
output wire [7:0] HEXf0_w,
output wire [7:0] HEXf1_w,
output wire [7:0] HEXf2_w,
output wire [7:0] HEXf3_w,
output wire [7:0] HEXf4_w,
output wire [7:0] HEXf5_w
);
	reg [7:0] HEXf0;
	reg [7:0] HEXf1;
	reg [7:0] HEXf2;
	reg [7:0] HEXf3;
	reg [7:0] HEXf4;
	reg [7:0] HEXf5;
	
	always @(posedge clk)
	begin
		case(state)
			
			2'b00: begin
				HEXf0 = 8'b01111111;			//.
				HEXf1 = 8'b10010001;			//y
				HEXf2 = 8'b10100001;			//d
				HEXf3 = 8'b10001000;			//a
				HEXf4 = 8'b10000110;			//e
				HEXf5 = 8'b10101111;			//r
			end
			
			2'b01: begin
				HEXf0 = HEX0g;         // previous guess number display to HEX
				HEXf1 = 8'b11111111;
				HEXf2 = 8'b11111111;
				HEXf3 = 8'b11111111;
				HEXf4 = HEX4g;       //if guess state then display either HI or Lo to HEX depending on logic in flag.v
				HEXf5 = HEX5g;
			end
			
			2'b10: begin
				HEXf0 = HEX0r;         //random number generated display to hex
				HEXf1 = 8'b11111111;
				HEXf2 = HEX2r;
				HEXf3 = HEX3r;       //if result state then display either Lose or yay depening on logic in hexResults.v
				HEXf4 = HEX4r;
				HEXf5 = HEX5r;
			end
			
			default: begin
				HEXf0 = 8'b01111111;
				HEXf1 = 8'b01111111; //default case all decimal points
				HEXf2 = 8'b01111111;
				HEXf3 = 8'b01111111;
				HEXf4 = 8'b01111111;
				HEXf5 = 8'b01111111;
			end
		
		endcase
	end
	
	assign HEXf0_w = HEXf0;
	assign HEXf1_w = HEXf1;
	assign HEXf2_w = HEXf2;
	assign HEXf3_w = HEXf3;
	assign HEXf4_w = HEXf4;
	assign HEXf5_w = HEXf5;
	
endmodule