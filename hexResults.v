 module hexResults(
input wire fastClk,
input wire clk,
input wire [1:0] state,
input wire [4:0] guess,
input wire [4:0] RnG,
output wire [7:0] hex5R,
output wire [7:0] hex4R,
output wire [7:0] hex3R,
output wire [7:0] hex2R,
output wire [7:0] hex0R,
output wire [6:0] led
);

	wire [6:0] led_scrollW;
	wire [7:0] RnGHex;
	reg [7:0] hex5R_reg;
	reg [7:0] hex4R_reg;
	reg [7:0] hex3R_reg;
	reg [7:0] hex2R_reg;
	reg [7:0] hex0R_reg;
	reg [6:0] led_reg;
	reg [6:0] led_scroll;
	
	led_scroller MUTled(.clk(fastClk), .leds(led_scrollW));
	
	
	always @(posedge clk) begin
	
		if(state == 2'b00)
			led_reg = 7'b1111111;
			
			if(state == 2'b01)
			led_reg = 7'b0000000;
			
		if(state == 2'b10) begin
			if(guess == RnG)begin
				led_scroll = led_scrollW;
				led_reg = led_scroll;
				hex5R_reg = 8'b10010001;  //y
				hex4R_reg = 8'b10001000;  //A
				hex3R_reg = 8'b10010001;  //Y
				hex2R_reg = 8'b01111101;  //!
				hex0R_reg = RnGHex;
				
			end
			else begin
			
				led_reg = 7'b0000000;
				hex5R_reg = 8'b11000111;  //L
				hex4R_reg = 8'b10100011;  //o
				hex3R_reg = 8'b10010010;  //s
				hex2R_reg = 8'b10000110;  //e
				hex0R_reg = RnGHex;
				
			end
		end
	end
	
	sevenSeg MUT(.num(RnG), .seg(RnGHex));
	
	assign hex0R = hex0R_reg;
	assign hex2R = hex2R_reg;
	assign hex3R = hex3R_reg;
	assign hex4R = hex4R_reg;
	assign hex5R = hex5R_reg;
	assign led = led_reg;
	
endmodule