module Rps2(
    input clk,                  // 50 MHz Clock
    input [1:0] state,          // Current game state (3 bits for 4 states)
    input [3:0] user_move,      // User's move (Rock = 1, Paper = 2, Scissors = 3)
    input [3:0] computer_move,  // Computer's move (Rock = 1, Paper = 2, Scissors = 3)
    output reg [1:0] result,    // Result (0 = Lose, 1 = Draw, 2 = Win)
    output reg [9:0] LEDn,      // 10 LEDs output (for feedback)
    output reg [7:0] Digit5,
    output reg [7:0] Digit4,
    output reg [7:0] Digit2,    // 8-bit 7-segment digit 2
    output reg [7:0] Digit1,    // 8-bit 7-segment digit 1
    output reg [7:0] Digit0     // 8-bit 7-segment digit 0
);

    reg [3:0] bcd4; // Loss counter (BCD)
    reg [3:0] bcd5; // Win counter (BCD)
    reg result_counters_incremented; // Flag to prevent multiple increments

    initial begin
        Digit4 = 8'b11111111;
        Digit5 = 8'b11111111;
        bcd4 = 4'b0001;
        bcd5 = 4'b0001;
        result_counters_incremented = 1'b0;
    end

    // Game logic
    always @(posedge clk) begin
        case (state)
            2'b00: begin // Waiting
                LEDn <= 10'b0000000001;  // Display "Waiting"
                Digit0 <= 8'b11000000;  // Display 0
                Digit1 <= 8'b11111111;  // Display blank
                Digit2 <= 8'b11111111;  // Display blank
                result_counters_incremented <= 1'b0; // Reset flag for next game
            end
            2'b01: begin // Move
                LEDn <= 10'b0000001110;  // Display "First Move"
                Digit0 <= 8'b11000000;  // Display 0
                Digit1 <= 8'b11111111;  // Display blank
                Digit2 <= 8'b11111111;  // Display blank
            end
            2'b10: begin // Result Stage
                if (!result_counters_incremented) begin
                    // Check the result of the game (win, loss, draw)
                    if (user_move == computer_move) begin
                        bcd4 <= bcd4;
                        bcd5 <= bcd5;
                        
                        if (bcd4 == 4'b1001) bcd4 <= 4'b0000;
                        else if (bcd5 == 4'b1001) bcd5 <= 4'b0000;
                        
                        result <= 1; // Draw
                        Digit0 <= 8'b10100001;    // "d" for Draw
                        Digit1 <= 8'b10100001;    // "d" for Draw
                        LEDn <= 10'b1111111111;   // Display Draw
                        case(computer_move)
                            0: Digit2 <= 8'b11001110; // (r for Rock)
                            1: Digit2 <= 8'b10001100; // (p for Paper)
                            2: Digit2 <= 8'b10010010; // (S for Scissors)
                        endcase
                    end else if ((user_move == 1 && computer_move == 0) ||
                                 (user_move == 0 && computer_move == 2) ||
                                 (user_move == 2 && computer_move == 1)) begin
                        // Win case
                        bcd5 <= bcd5 + 1;  // Increment win counter
                        result_counters_incremented <= 1'b1; // Set flag to prevent further increments
                        bcd4 <= bcd4;

                        if (bcd4 == 4'b1001) bcd4 <= 4'b0000;
                        else if (bcd5 == 4'b1001) bcd5 <= 4'b0000;

                        result <= 2; // Win
                        LEDn <= 10'b1010101010; // Display Win
                        case(computer_move)
                            0: Digit2 <= 8'b11001110; // (r for Rock)
                            1: Digit2 <= 8'b10001100; // (p for Paper)
                            2: Digit2 <= 8'b10010010; // (S for Scissors)
                        endcase
                        
                        // Update the win counter display
                        case(bcd5)
                            4'b0000: Digit5 <= 8'b11000000;
                            4'b0001: Digit5 <= 8'b11111001;
                            4'b0010: Digit5 <= 8'b10100100;
                            4'b0011: Digit5 <= 8'b10110000;
                            4'b0100: Digit5 <= 8'b10011001;
                            4'b0101: Digit5 <= 8'b10010010;
                            4'b0110: Digit5 <= 8'b10000010;
                            4'b0111: Digit5 <= 8'b11111000; 
                            4'b1000: Digit5 <= 8'b10000000;
                            4'b1001: Digit5 <= 8'b10010000;
                        endcase
                        
                        Digit1 <= 8'b10001000;    // "A" for Win
                    end else begin
                        // Loss case
                        bcd4 <= bcd4 + 1;  // Increment loss counter
                        result_counters_incremented <= 1'b1; // Set flag to prevent further increments
                        bcd5 <= bcd5;

                        if (bcd4 == 4'b1001) bcd4 <= 4'b0000;
                        else if (bcd5 == 4'b1001) bcd5 <= 4'b0000;

                        result <= 0; // Lose
                        LEDn <= 10'b1111100000; // Display Lose
                        Digit1 <= 8'b11000111;    // "F" for Lose
                        Digit1 <= 8'b11000111;    // "F" for Lose
                        case(computer_move)
                            0: Digit2 <= 8'b11001110; // (r for Rock)
                            1: Digit2 <= 8'b10001100; // (p for Paper)
                            2: Digit2 <= 8'b10010010; // (S for Scissors)
                        endcase

                        // Update the loss counter display
                        case(bcd4)
                            4'b0000: Digit4 <= 8'b11000000;
                            4'b0001: Digit4 <= 8'b11111001;
                            4'b0010: Digit4 <= 8'b10100100;
                            4'b0011: Digit4 <= 8'b10110000;
                            4'b0100: Digit4 <= 8'b10011001;
                            4'b0101: Digit4 <= 8'b10010010;
                            4'b0110: Digit4 <= 8'b10000010;
                            4'b0111: Digit4 <= 8'b11111000; 
                            4'b1000: Digit4 <= 8'b10000000;
                            4'b1001: Digit4 <= 8'b10010000;
                        endcase
                    end
                end
            end
            default: begin
                LEDn <= 10'b0000000000;
                Digit0 <= 8'b11111111;  // Blank
                Digit1 <= 8'b11111111;  // Blank
                Digit2 <= 8'b11111111;  // Blank
            end
        endcase
    end

endmodule
