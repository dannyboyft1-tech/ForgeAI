//====================================================
// ForgeAI
//
// Module ID : FA-014B
// Module    : systolic_array
// Author    : Daniel Simpson
//
// Description:
// Parameterized systolic array with operand routing.
// Activations flow left-to-right.
// Weights flow top-to-bottom.
//
//====================================================

module systolic_array #(
    parameter ROWS = 4,
    parameter COLS = 4
)(
    input  wire clk,
    input  wire rst,

    input  wire act_load,
    input  wire wgt_load,
    input  wire acc_clear,
    input  wire compute_en,

    input  wire [ROWS*8-1:0] activations_in,
    input  wire [COLS*8-1:0] weights_in,

    output wire [ROWS*COLS*32-1:0] accumulators_out
);

    genvar r, c;

    // Activation buses: ROWS rows, COLS+1 stages
    wire signed [7:0] act_bus [0:ROWS*(COLS+1)-1];

    // Weight buses: ROWS+1 stages, COLS columns
    wire signed [7:0] wgt_bus [0:(ROWS+1)*COLS-1];

    // Connect left edge activations
    generate
        for (r = 0; r < ROWS; r = r + 1) begin : ACT_INPUTS
            assign act_bus[r*(COLS+1)] = activations_in[(r*8)+7 -: 8];
        end
    endgenerate

    // Connect top edge weights
    generate
        for (c = 0; c < COLS; c = c + 1) begin : WGT_INPUTS
            assign wgt_bus[c] = weights_in[(c*8)+7 -: 8];
        end
    endgenerate

    // Generate PE fabric
    generate
        for (r = 0; r < ROWS; r = r + 1) begin : ROW_GEN
            for (c = 0; c < COLS; c = c + 1) begin : COL_GEN

                wire signed [31:0] acc;

                systolic_processing_element pe (
                    .clk(clk),
                    .rst(rst),

                    .act_load(act_load),
                    .wgt_load(wgt_load),
                    .acc_clear(acc_clear),
                    .compute_en(compute_en),

                    .activation_in(
                        act_bus[(r*(COLS+1))+c]
                    ),

                    .weight_in(
                        wgt_bus[(r*COLS)+c]
                    ),

                    .activation_out(
                        act_bus[(r*(COLS+1))+c+1]
                    ),

                    .weight_out(
                        wgt_bus[((r+1)*COLS)+c]
                    ),

                    .acc_out(acc)
                );

                assign accumulators_out[((r*COLS+c)*32)+31 -: 32] = acc;

            end
        end
    endgenerate

endmodule