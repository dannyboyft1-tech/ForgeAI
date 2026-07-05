//====================================================
// ForgeAI
//
// Module ID FA-004
// Module: multiplierN
// Author: Daniel Simpson
//
// Description:
// Parameterized combinational multiplier.
// Multiplies two WIDTH-bit inputs and produces
// a 2*WIDTH-bit product.
//
//====================================================

module multiplierN #(
    parameter WIDTH = 8
)(
    input  wire [WIDTH-1:0]     a,
    input  wire [WIDTH-1:0]     b,
    output wire [(2*WIDTH)-1:0] product
);

assign product = a * b;

endmodule