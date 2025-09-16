module DisplayFeedback(
    input [2:0] state,
    input [3:0] guess,
    input [3:0] remaining_guesses,
    output reg [6:0] Digit0, Digit1
);

    always @(state or guess or remaining_guesses) begin
        case (state)
            3'b000: begin  // Waiting state
                Digit0 = 7'b1111111;  // Blank display
                Digit1 = 7'b1111111;
            end
            3'b001: begin  // Guessing state
                Digit0 = 7'b0111111;  // Show the current guess
                Digit1 = 7'b0111111;
            end
            3'b010: begin  // Feedback state
                if (guess == 4'b0000) begin
                    Digit0 = 7'b0110001;  // "Tiny"
                    Digit1 = 7'b1111001;  // "Tiny"
                end else if (guess == 4'b0001) begin
                    Digit0 = 7'b1111111;  // Blank display
                    Digit1 = 7'b0110000;  // "Big"
                end else begin
                    Digit0 = 7'b1111111;  // Default display
                    Digit1 = 7'b1111111;
                end
            end
            3'b011: begin  // Win state
                Digit0 = 7'b1111111;  // Show win message
                Digit1 = 7'b0111111;  // Show win message
            end
            default: begin  // Lose or error state
                Digit0 = 7'b1111111;  // Default display
                Digit1 = 7'b1111111;
            end
        endcase
    end

endmodule
