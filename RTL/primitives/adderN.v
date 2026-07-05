//====================================================
// ForgeAI
//
// Module ID FA-003
// Module: adderN
// Author: Daniel Simpson
//
// Description:
// Parameterized combinational adder.
// Adds two WIDTH-bit inputs and produces WIDTH+1 output.
//
//====================================================

module adderN #(
    parameter WIDTH = 8
)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    output wire [WIDTH:0]   sum
);

assign sum = a + b;

endmodule