module TB;

reg clock, reset;
reg [12:0] instruction_Register;
wire signed [511:0] A1, A2, A3, A4;

Processor Processor (.instruction_Register(instruction_Register), .clock(clock), .reset(reset), 
                     .wire1(A1), .wire2(A2), .wire3(A3), .wire4(A4));

initial
    clock = 0;
always
    #5 clock <= ~clock;

initial begin
    reset = 0;
    #1 reset = 1;
    // store: 00 load: 01 add: 10 multiply: 11
    instruction_Register = 13'b11_00_000000000; // A1 * A2
    #40 instruction_Register = 13'b10_00_000000000; // A1 + A2
    #40 instruction_Register = 13'b00_00_111111100; // store A1 to Mem
    #40 instruction_Register = 13'b01_10_111111100; // load Mem to A3
    #40 $stop();
end
endmodule
