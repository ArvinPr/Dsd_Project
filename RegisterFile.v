module RegFile (
    input wire signed [1023:0] alu_out, 
    output reg signed [511:0] reg1, 
    output reg signed [511:0] reg2,
    output reg signed [511:0] reg3, 
    output reg signed [511:0] reg4, 
    input wire clock, 
    input wire reset,
    input wire [1:0] wr_addr, 
    input wire wr_en, 
    input wire is_alu_result, 
    input wire [511:0] wr_data
);

integer index;
always @(negedge clock or negedge reset) begin
    if (!reset) begin
        reg1 <= 512'hFFFF0000_00000000_80000000_00000010; 
        reg2 <= 512'hFFFF0000_00000000_00000000_000002E1; 
        reg3 <= 512'h0;
        reg4 <= 512'h0;
    end else if (wr_en) begin
        if (is_alu_result) begin
            for (index = 0; index < 16; index = index + 1) begin
                reg3[32*index +: 32] <= alu_out[64*index +: 32];
                reg4[32*index +: 32] <= alu_out[64*index + 32 +: 32];
            end
        end else begin
            case (wr_addr)
                2'b00: reg1 <= wr_data;
                2'b01: reg2 <= wr_data;
                2'b10: reg3 <= wr_data;
                2'b11: reg4 <= wr_data;
            endcase
        end
    end
end

endmodule
