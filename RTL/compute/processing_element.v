//====================================================
// ForgeAI
//
// Module ID : FA-008
// Module    : processing_element
// Author    : Daniel Simpson
//
// Description:
// AI Processing Element.
// Holds one signed INT8 activation, one signed INT8 weight,
// and feeds them into a signed MAC accumulator.
//
//====================================================

module processing_element (
    input  wire               clk,
    input  wire               rst,

    input  wire               act_load,
    input  wire               wgt_load,
    input  wire               acc_clear,
    input  wire               compute_en,

    input  wire signed [7:0]  act_in,
    input  wire signed [7:0]  wgt_in,

    output wire signed [31:0] acc_out
);

    reg signed [7:0] act_reg;
    reg signed [7:0] wgt_reg;

    always @(posedge clk) begin
        if (rst) begin
            act_reg <= 8'sd0;
            wgt_reg <= 8'sd0;
        end else begin
            if (act_load) begin
                act_reg <= act_in;
            end

            if (wgt_load) begin
                wgt_reg <= wgt_in;
            end
        end
    end

    macN #(
        .DATA_WIDTH(8),
        .ACC_WIDTH(32)
    ) pe_mac (
        .clk(clk),
        .rst(rst),
        .clear_acc(acc_clear),
        .en(compute_en),
        .a(act_reg),
        .b(wgt_reg),
        .acc(acc_out)
    );

endmodule