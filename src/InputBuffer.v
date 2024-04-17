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

reg [DATA_WIDTH-1:0] buffer_0, buffer_1;
reg select = 0; // Buffer selector for double buffering
reg [DATA_WIDTH-1:0] bit_count = 0; // Bit count for data collection

// Always block for handling the shift register and outputting data
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset all outputs and internal registers
        buffer_0 <= 0;
        buffer_1 <= 0;
        select <= 0;
        data_output <= 0;
        data_ready <= 0;
        bit_count <= 0;
    end else begin
        // Process data if not in reset
        if (data_processed && data_ready) begin
            data_ready <= 0;  // Clear data ready after processing
            select <= ~select; // Toggle buffer selection
        end

        // Handle data collection and output
        if (!data_ready && bit_count < DATA_WIDTH) begin
            // Select buffer based on 'select' state
            if (select) begin
                buffer_1 <= (buffer_1 << 1) | sensor_data;
            end else begin
                buffer_0 <= (buffer_0 << 1) | sensor_data;
            end
            bit_count <= bit_count + 1;

            // Check if a full byte has been collected
            if (bit_count == DATA_WIDTH) begin
                data_output <= select ? buffer_1 : buffer_0;
                data_ready <= 1;
                bit_count <= 0;  // Reset bit count for next data
                if (select) buffer_1 <= 0; 
                else buffer_0 <= 0;
            end
        end
    end
end

endmodule
