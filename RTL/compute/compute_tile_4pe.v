//====================================================
// ForgeAI
//
// Module ID : FA-009
// Module    : compute_tile_4pe
// Author    : Daniel Simpson
//
// Description:
// AI compute tile composed of four Processing Elements.
// Accepts packed signed INT8 activations and weights.
// Produces summed INT32 tile result.
//
//====================================================

module compute_tile_4pe (
    input  wire               clk,
    input  wire               rst,

    input  wire               act_load,
    input  wire               wgt_load,
    input  wire               acc_clear,
    input  wire               compute_en,

    input  wire signed [31:0] activations,
    input  wire signed [31:0] weights,

    output wire signed [31:0] tile_result,
    output reg                done
);

    wire signed [31:0] acc0;
    wire signed [31:0] acc1;
    wire signed [31:0] acc2;
    wire signed [31:0] acc3;

    wire signed [7:0] act0 = activations[7:0];
    wire signed [7:0] act1 = activations[15:8];
    wire signed [7:0] act2 = activations[23:16];
    wire signed [7:0] act3 = activations[31:24];

    wire signed [7:0] wgt0 = weights[7:0];
    wire signed [7:0] wgt1 = weights[15:8];
    wire signed [7:0] wgt2 = weights[23:16];
    wire signed [7:0] wgt3 = weights[31:24];

    processing_element pe0 (
        .clk(clk),
        .rst(rst),
        .act_load(act_load),
        .wgt_load(wgt_load),
        .acc_clear(acc_clear),
        .compute_en(compute_en),
        .act_in(act0),
        .wgt_in(wgt0),
        .acc_out(acc0)
    );

    processing_element pe1 (
        .clk(clk),
        .rst(rst),
        .act_load(act_load),
        .wgt_load(wgt_load),
        .acc_clear(acc_clear),
        .compute_en(compute_en),
        .act_in(act1),
        .wgt_in(wgt1),
        .acc_out(acc1)
    );

    processing_element pe2 (
        .clk(clk),
        .rst(rst),
        .act_load(act_load),
        .wgt_load(wgt_load),
        .acc_clear(acc_clear),
        .compute_en(compute_en),
        .act_in(act2),
        .wgt_in(wgt2),
        .acc_out(acc2)
    );

    processing_element pe3 (
        .clk(clk),
        .rst(rst),
        .act_load(act_load),
        .wgt_load(wgt_load),
        .acc_clear(acc_clear),
        .compute_en(compute_en),
        .act_in(act3),
        .wgt_in(wgt3),
        .acc_out(acc3)
    );

    assign tile_result = acc0 + acc1 + acc2 + acc3;

    always @(posedge clk) begin
        if (rst) begin
            done <= 1'b0;
        end else begin
            done <= compute_en;
        end
    end

endmodule