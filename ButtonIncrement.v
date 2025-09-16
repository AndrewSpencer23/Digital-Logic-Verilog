module ButtonIncrement(
    input clk,              // Declare clk as input
    input [1:0] state,      // Declare state as input [1:0] to match the state machine
    input [1:0] button,     // Button signals (e.g., increment, lock)
    output [6:0] Digit0     // Declare Digit0 as output [6:0] for 7-segment display (now a wire)
);

    reg [3:0] bcd0;            // BCD for current number (4 bits)
    reg state_reg;             // State register
    reg [3:0] CurrentNumber;   // Current number for display
    reg [3:0] LockedNumber;    // Locked number

    parameter IncrementButton = 2'b00;
    parameter LockNumber = 2'b01;

    // Initialize registers
    initial begin
        state_reg = IncrementButton;
        CurrentNumber = 4'b0000;   // Start at 0
        LockedNumber = 4'b0000;    // Start locked at 0
        bcd0 = 4'b0000;            // Start at 0
    end

    // State machine for button increment and lock
    always @(posedge clk) begin
        state_reg <= state;

        case (state_reg)
            IncrementButton: begin
                if (button[1]) begin
                    if (bcd0 == 4'b1001) 
                        bcd0 <= 4'b0000;  // Reset to 0 after 9
                    else 
                        bcd0 <= bcd0 + 1;  // Increment bcd0
                end
            end

            LockNumber: begin
                LockedNumber <= bcd0; // Display locked number
            end

            default: begin
                // Default case for resetting the display
                bcd0 <= 4'b0000;  // Reset to zero
            end
        endcase
    end

    // Instantiate the 7-segment display module
    seg7 segDisplayNumber (
        .bcd(bcd0),    // Pass bcd0 to the segment display
        .leds(Digit0)  // Connect 7-segment display output to Digit0 (wire)
    );

endmodule
