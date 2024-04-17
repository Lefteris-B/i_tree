module InputBuffer #(
    parameter DATA_WIDTH = 8  // Default parameter for data width
)(
    input wire clk,
    input wire reset,
    input wire sensor_data,
    input wire data_processed,  // Signal from state machine indicating data has been processed
    output reg [DATA_WIDTH-1:0] data_output,
    output reg data_ready
);

// Internal signals and registers
reg [DATA_WIDTH-1:0] buffer;
reg [DATA_WIDTH-1:0] data_temp;
reg [DATA_WIDTH-1:0] bit_count = 0; // Bit count for data collection

// Always block for handling the shift register and outputting data
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset all outputs and internal registers
        buffer <= 0;
        data_temp <= 0;
        data_output <= 0;
        data_ready <= 0;
        bit_count <= 0;
    end else begin
        // Handle data collection and output
        if (bit_count < DATA_WIDTH) begin
            buffer <= (buffer << 1) | sensor_data;
            bit_count <= bit_count + 1;
        end

        // Check if data has been processed and ready to be output
        if (data_processed && (bit_count == DATA_WIDTH)) begin
            data_temp <= buffer; // Save data temporarily
            data_ready <= 1;
        end

        // Output data after ensuring it has been processed and ready
        if (data_ready) begin
            data_output <= data_temp;
            data_ready <= 0;
            buffer <= 0; // Reset buffer for new data collection
            bit_count <= 0; // Reset bit count
        end
    end
end

endmodule
