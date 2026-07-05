//====================================================
// ForgeAI
//
// Module ID : FA-005
// Module    : mac_int8
// Author    : Daniel Simpson
//
// Description:
// Signed INT8 multiply-accumulate unit.
// Performs: acc <= acc + (a * b)
//
// Standards:
// - Positive-edge clock
// - Active-high synchronous reset
// - Active-high enable
// - Signed INT8 arithmetic
// - Signed INT32 accumulator
//
//====================================================

module mac_int8 (
    input  wire               clk,
    input  wire               rst,
    input  wire               en,
    input  wire signed [7:0]  a,
    input  wire signed [7:0]  b,
    output reg  signed [31:0] acc
);

    wire signed [15:0] product;

    assign product = a * b;

    always @(posedge clk) begin
        if (rst) begin
            acc <= 32'sd0;
        end else if (en) begin
            acc <= acc + product;
        end
    end

endmodule