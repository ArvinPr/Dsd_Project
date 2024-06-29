module Memory (
    input wire clock, 
    input wire reset, 
    input reg [8:0] addr, 
    input wire we, 
    input wire signed [511:0] wr_data,
    output reg signed [511:0] rd_data
);

reg signed [31:0] memory_array [0:511];

integer index;
always @(negedge clock or negedge reset) begin
    if (!reset) begin
        for (index = 0; index < 511; index = index + 1) begin
            memory_array[index] <= 32'b0;
        end
    end else if (we) begin
        for (index = 0; index < 16; index = index + 1) begin
            memory_array[addr + index] <= wr_data[32*index +: 32];
        end
    end
end

always @(posedge clock) begin
    rd_data = 512'b0;
    for (index = 0; index < 16; index = index + 1) begin
        rd_data[32*index +: 32] <= memory_array[addr + index];
    end
end

endmodule
