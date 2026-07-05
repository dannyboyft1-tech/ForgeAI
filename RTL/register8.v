//====================================================
// ForgeAI
//
// Module ID FA-001
// Module: register8
// Author: Daniel Simpson
//
// Description:
// 8-bit register with synchronous active-high reset
// and active-high enable.
//
//====================================================

module register8 (
    input  wire       clk,
    input  wire       rst,
    input  wire       en,
    input  wire [7:0] d,
    output reg  [7:0] q
);

always @(posedge clk) begin
    if (rst) begin
        q <= 8'b00000000;
    end else if (en) begin
        q <= d;
    end
end

endmodule