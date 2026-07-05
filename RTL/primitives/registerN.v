//====================================================
// ForgeAI
//
// Module ID FA-002
// Module: registerN
// Author: Daniel Simpson
//
// Description:
// Parameterized register with synchronous active-high
// reset and active-high enable.
//
//====================================================

module registerN #(
    parameter WIDTH = 8
)(
    input  wire             clk,
    input  wire             rst,
    input  wire             en,
    input  wire [WIDTH-1:0] d,
    output reg  [WIDTH-1:0] q
);

always @(posedge clk) begin
    if (rst) begin
        q <= {WIDTH{1'b0}};
    end else if (en) begin
        q <= d;
    end
end

endmodule