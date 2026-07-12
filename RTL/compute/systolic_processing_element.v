//====================================================
// ForgeAI
//
// Module ID : FA-013
// Module    : systolic_processing_element
// Author    : Daniel Simpson
//
// Description:
// Systolic Processing Element.
//
// Receives activation and weight operands,
// forwards them to neighboring PEs,
// and performs one signed INT8 MAC.
//
//====================================================

module systolic_processing_element (

    input  wire clk,
    input  wire rst,

    input  wire act_load,
    input  wire wgt_load,
    input  wire acc_clear,
    input  wire compute_en,

    input  wire signed [7:0] activation_in,
    input  wire signed [7:0] weight_in,

    output reg  signed [7:0] activation_out,
    output reg  signed [7:0] weight_out,

    output wire signed [31:0] acc_out

);

    //--------------------------------------------------
    // Internal Registers
    //--------------------------------------------------

    reg signed [7:0] activation_reg;
    reg signed [7:0] weight_reg;

    //--------------------------------------------------
    // Pipeline Registers
    //--------------------------------------------------

    always @(posedge clk) begin

        if (rst) begin

            activation_reg <= 0;
            weight_reg     <= 0;

            activation_out <= 0;
            weight_out     <= 0;

        end
        else begin

            if (act_load) begin

                activation_reg <= activation_in;
                activation_out <= activation_in;

            end

            if (wgt_load) begin

                weight_reg <= weight_in;
                weight_out <= weight_in;

            end

        end

    end

    //--------------------------------------------------
    // MAC Engine
    //--------------------------------------------------

        macN #(
        .DATA_WIDTH(8),
        .ACC_WIDTH(32)
    ) mac (

        .clk(clk),
        .rst(rst),
        .clear_acc(acc_clear),
        .en(compute_en),

        .a(activation_reg),
        .b(weight_reg),

        .acc(acc_out)

    );

endmodule