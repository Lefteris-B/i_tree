module i_tree(
    input wire clk,
    input wire reset,
    input wire sensor_data, // Incoming sensor data bit
    output wire anomaly_detected // Output indicating if an anomaly was detected
);

// Internal signal declarations
wire [7:0] data_from_buffer;
wire data_ready;
wire data_processed;

// Instantiate the InputBuffer module
  InputBuffer #(.DATA_WIDTH(8)) input_buffer_inst (
    .clk(clk),
    .reset(reset),
    .sensor_data(sensor_data),
    .data_processed(data_processed),
    .data_output(data_from_buffer),
    .data_ready(data_ready)
);

// Instantiate the IsolationTreeStateMachine module
IsolationTreeStateMachine isolation_tree_state_machine_inst (
    .clk(clk),
    .reset(reset),
    .data_input(data_from_buffer),
    .data_valid(data_ready),
    .anomaly_detected(anomaly_detected),
    .data_processed(data_processed)
);

endmodule