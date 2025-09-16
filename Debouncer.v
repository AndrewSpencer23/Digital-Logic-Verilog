module debounce(
    input clk,              // Clock signal
    input button,           // Input signal (button press)
    output reg debounced_signal  // Debounced output signal
);

    reg [3:0] debounce_counter;  // Counter to debounce the signal

    always @(posedge clk) begin
        if (button == 1'b0) begin   // Active low button
            debounce_counter <= debounce_counter + 1;
        end else begin
            debounce_counter <= 4'b0000;  // Reset counter if button is released
        end
        
        // Only register the signal as debounced if it has been stable long enough
        if (debounce_counter == 4'b1111) begin
            debounced_signal <= 1'b1;
        end else begin
            debounced_signal <= 1'b0;
        end
    end

endmodule
