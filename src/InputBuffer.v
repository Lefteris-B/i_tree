module InputBuffer #(
    parameter DATA_WIDTH = 8  // Default parameter for data width
)(
    input wire clk,
    input wire reset,
    input wire sensor_data,
    input wire data_processed,
    output reg [DATA_WIDTH-1:0] data_output,
    output reg data_ready
);

reg [DATA_WIDTH-1:0] shift_register;
reg [$clog2(DATA_WIDTH)-1:0] bit_count;

// Always block for handling the shift register and outputting data
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        // Reset all outputs and internal registers
        shift_register <= 0;
        bit_count <= 0;
        data_output <= 0;
        data_ready <= 0;
    end else begin
        // Process data only if it has not been processed yet
        if (data_processed) begin
            data_ready <= 0;  // Acknowledge the data processing
        end

        // Check if new data can be accepted
        if (!data_ready && bit_count < DATA_WIDTH) begin
            // Shift in the new bit from the sensor_data input
            shift_register <= (shift_register << 1) | sensor_data;
            bit_count <= bit_count + 1;

            // Check if we have received enough bits
            if (bit_count == DATA_WIDTH - 1) begin
                data_output <= shift_register;  // Move complete data to output
                data_ready <= 1;  // Indicate that data is ready
                bit_count <= 0;  // Reset bit count for next data
                shift_register <= 0;  // Reset shift register for next data
            end
        end
    end
end

endmodule

