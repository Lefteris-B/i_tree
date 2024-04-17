module IsolationTreeStateMachine(
    input wire clk,
    input wire reset,
    input wire [7:0] data_input,
    input wire data_valid,
    output reg anomaly_detected,
    output reg data_processed,
    input wire buffer_toggle  // New signal indicating buffer toggle from InputBuffer
);

// Define state constants
localparam [1:0] IDLE = 2'b00,
                 CHECK_ANOMALY = 2'b01,
                 PROCESS_DONE = 2'b10;

// State variables
reg [1:0] current_state = IDLE;
reg [1:0] next_state = IDLE;
reg buffer_toggle_reg = 0; // Register to store buffer toggle state

always @(posedge clk or negedge reset) begin
    if (!reset) begin
        // Reset logic
        anomaly_detected <= 0;
        data_processed <= 0;
        current_state <= IDLE;
        next_state <= IDLE;
        buffer_toggle_reg <= 0;
    end else begin
        // Store buffer toggle state
        buffer_toggle_reg <= buffer_toggle;

        current_state <= next_state; // Transition to the next state

        case (current_state)
            IDLE: begin
                anomaly_detected <= 0; // Reset anomaly_detected each cycle
                if (data_valid && buffer_toggle == buffer_toggle_reg)
                    next_state <= CHECK_ANOMALY; // Transition only if buffer toggle matches
            end
            CHECK_ANOMALY: begin
                // Perform anomaly check
                anomaly_detected <= (data_input == 8'h55); // Placeholder for anomaly detection logic
                next_state <= PROCESS_DONE; // Move to process done state
            end
            PROCESS_DONE: begin
                // Indicate processing is done
                data_processed <= 1;
                next_state <= IDLE; // Return to IDLE state
            end
            default: begin
                next_state <= IDLE; // Default fallback to IDLE
            end
        endcase
    end
end

endmodule
