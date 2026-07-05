//====================================================
// ForgeAI
//
// Module ID : FA-007
// Module    : compute_tile_dot4
// Author    : Daniel Simpson
//
// Description:
// INT8 signed 4-element dot product compute tile.
// Computes:
// result = a0*w0 + a1*w1 + a2*w2 + a3*w3
//
//====================================================

module compute_tile_dot4 (
    input  wire                     clk,
    input  wire                     rst,
    input  wire                     start,

    input  wire signed [7:0]        a0,
    input  wire signed [7:0]        a1,
    input  wire signed [7:0]        a2,
    input  wire signed [7:0]        a3,

    input  wire signed [7:0]        w0,
    input  wire signed [7:0]        w1,
    input  wire signed [7:0]        w2,
    input  wire signed [7:0]        w3,

    output reg  signed [31:0]       result,
    output reg                      done
);

    wire signed [15:0] p0;
    wire signed [15:0] p1;
    wire signed [15:0] p2;
    wire signed [15:0] p3;

    wire signed [31:0] sum;

    assign p0 = a0 * w0;
    assign p1 = a1 * w1;
    assign p2 = a2 * w2;
    assign p3 = a3 * w3;

    assign sum =
        {{16{p0[15]}}, p0} +
        {{16{p1[15]}}, p1} +
        {{16{p2[15]}}, p2} +
        {{16{p3[15]}}, p3};

    always @(posedge clk) begin
        if (rst) begin
            result <= 32'sd0;
            done   <= 1'b0;
        end else begin
            done <= 1'b0;

            if (start) begin
                result <= sum;
                done   <= 1'b1;
            end
        end
    end

endmodule