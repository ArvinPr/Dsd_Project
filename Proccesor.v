module Processor (
    input wire [12:0] instruction_Register,
    input wire clock,
    input wire reset,
    output wire signed [511:0] wire1,
    output wire signed [511:0] wire2,
    output wire signed [511:0] wire3,
    output wire signed [511:0] wire4
);

wire [511:0] wr_data;
wire [511:0] rd_data;
wire [1023:0] alu_out;

reg [511:0] Memory_write_data_reg; // Register for wr_data

always @* begin
    case (instruction_Register[10:9])
        2'b00: Memory_write_data_reg = wire1;
        2'b01: Memory_write_data_reg = wire2;
        2'b10: Memory_write_data_reg = wire3;
        default: Memory_write_data_reg = wire4;
    endcase
end

assign wr_data = Memory_write_data_reg; // Assign to wire

ArithmeticLogicUnit alu(.operand1(wire1), .operand2(wire2), .operation(instruction_Register[12:11]), .output_data(alu_out));

RegFile registerFile (
    alu_out, wire1, wire2, wire3, wire4,
    clock, reset,
    instruction_Register[10:9],
    ~(~instruction_Register[12] & instruction_Register[11]),
    instruction_Register[12],
    rd_data
);

Memory memory(
    clock, reset,
    instruction_Register[8:0],
    ~(instruction_Register[12] | instruction_Register[11]),
    wr_data,
    rd_data
);

endmodule
