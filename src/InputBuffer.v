module InputBuffer #(
    parameter DATA_WIDTH = 8  // Default parameter for data width
)(
    input wire clk,
    input wire reset,
    input wire sensor_data,
    input wire data_processed,  // Signal from state machine indicating data has been processed
    output reg [DATA_WIDTH-1:0] data_output,
    output reg data_ready,
    output reg buffer_toggle  // New signal to control buffer swapping
);

reg [DATA_WIDTH-1:0] buffer_0, buffer_1;
reg select = 0; // Buffer selector for double buffering

// Always block for handling the shift register and outputting data
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        // Reset all outputs and internal registers
        buffer_0 <= 0;
        buffer_1 <= 0;
        select <= 0;
        data_output <= 0;
        data_ready <= 0;
        buffer_toggle <= 0;
    end else begin
        if (data_processed && data_ready) begin
            data_ready <= 0;  // Clear data ready after processing
            select <= ~select; // Toggle buffer selection
            buffer_toggle <= ~buffer_toggle; // Toggle buffer control signal
        end

        if (!data_ready) begin
            // Collect data in the inactive buffer to not overwrite data being processed
            if (select) begin
                buffer_1 <= (buffer_1 << 1) | sensor_data;
            end else begin
                buffer_0 <= (buffer_0 << 1) | sensor_data;
            end

            if (buffer_0 == (DATA_WIDTH - 1) || buffer_1 == (DATA_WIDTH - 1)) begin
                data_output <= select ? buffer_1 : buffer_0;
                data_ready <= 1;
            end
        end
    end
end

endmodule
