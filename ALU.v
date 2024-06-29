module ArithmeticLogicUnit (
    input wire signed [511:0] operand1, 
    input wire signed [511:0] operand2, 
    input wire [1:0] operation, 
    output reg signed [1023:0] output_data
);

// 00 -> store 
// 10 -> add
// 01 -> load
// 11 -> multiply

reg signed [31:0] part1, part2;
reg signed [63:0] temp_result;
reg overflow_flag;

integer index;
always @* begin
    output_data = 1024'b0;  // Initialize the output data
    for (index = 0; index < 16; index = index + 1) begin
        part1 = operand1[32*index +: 32];
        part2 = operand2[32*index +: 32];
        case (operation)
            2'b10: begin
                temp_result = part1 + part2;
                overflow_flag = (~part1[31] & ~part2[31] & temp_result[31]) | (part1[31] & part2[31] & ~temp_result[31]);
                if (overflow_flag) begin
                    temp_result[63:32] = part1[31] ? 32'b1 : 32'b0;
                end
                output_data[64*index +: 64] = temp_result;
            end
            
            2'b11: begin
                temp_result = part1 * part2;
                output_data[64*index +: 64] = temp_result;
            end
        endcase
    end
end

endmodule
