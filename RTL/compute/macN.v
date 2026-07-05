//====================================================
// ForgeAI
//
// Module ID : FA-006
// Module    : macN
// Author    : Daniel Simpson
//
// Description:
// Parameterized signed multiply-accumulate unit.
// Performs: acc <= acc + (a * b)
//
// Standards:
// - Positive-edge clock
// - Active-high synchronous reset
// - Active-high enable
// - Active-high accumulator clear
// - Signed arithmetic
//
//====================================================

module macN #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32
)(
    input  wire                         clk,
    input  wire                         rst,
    input  wire                         clear_acc,
    input  wire                         en,
    input  wire signed [DATA_WIDTH-1:0] a,
    input  wire signed [DATA_WIDTH-1:0] b,
    output reg  signed [ACC_WIDTH-1:0]  acc
);

    localparam PRODUCT_WIDTH = DATA_WIDTH * 2;

    wire signed [PRODUCT_WIDTH-1:0] product;
    wire signed [ACC_WIDTH-1:0]     product_ext;

    assign product     = a * b;
    assign product_ext = {{(ACC_WIDTH-PRODUCT_WIDTH){product[PRODUCT_WIDTH-1]}}, product};

    always @(posedge clk) begin
        if (rst) begin
            acc <= {ACC_WIDTH{1'b0}};
        end else if (clear_acc) begin
            acc <= {ACC_WIDTH{1'b0}};
        end else if (en) begin
            acc <= acc + product_ext;
        end
    end

endmodule