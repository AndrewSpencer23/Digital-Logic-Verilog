module ButtonCounter(

    // CLOCK
    input           ADC_CLK_10,
    input           MAX10_CLK1_50,
    input           MAX10_CLK2_50,

    // SEG7
    output  [7:0]   HEX0,
    output  [7:0]   HEX1,
    output  [7:0]   HEX2,
    output  [7:0]   HEX3,
    output  [7:0]   HEX4,
    output  [7:0]   HEX5,

    // KEY
    input   [1:0]   KEY,

    // LED
    output  [9:0]   LEDR,

    // SW
    input   [9:0]   SW,

    // Accelerometer
    output          GSENSOR_CS_N,
    input   [2:1]   GSENSOR_INT,
    output          GSENSOR_SCLK,
    inout           GSENSOR_SDI,
    inout           GSENSOR_SDO
);

// REG/WIRE declarations
reg [1:0] StateReg;
reg increment_button_stable;  // Declare as reg
reg lock_button_stable;       // Declare as reg
wire clk1Hz;                 // 100Hz clock signal
wire [7:0] Digit0;            // wire to capture the 7-segment display output

parameter IncrementButton = 2'b00;
parameter DisplayNumber = 2'b01;
parameter LockNumber = 2'b10;

always @(posedge clk1Hz) begin
    StateReg <= StateReg;
    case (StateReg)
        IncrementButton: 
            if (KEY[1]) 
                StateReg <= IncrementButton;
        LockNumber:     
            if (KEY[0]) 
                StateReg <= LockNumber;
        
        default:         
            StateReg <= IncrementButton;
    endcase
end

// Clock Divider module instance
ClockDivider100 Clock_MUT(
    .clk(clk1Hz),
    .clk1Hz(clk1Hz)
);

// Button increment module instance
ButtonIncrement IncrementButtonMUT(
    .clk(clk1Hz),
    .state(StateReg),
	 .button(KEY),
    .Digit0(Digit0)             // Only wire Digit0 if Button0 and Button1 are not needed
);

// Hex display logic
assign HEX0 = Digit0;  // Drive the lower 7 bits for HEX0
assign HEX1 = 8'b11111111;
assign HEX2 = 8'b11111111;
assign HEX3 = 8'b11111111;
assign HEX4 = 8'b11111111;
assign HEX5 = 8'b11111111;

endmodule
