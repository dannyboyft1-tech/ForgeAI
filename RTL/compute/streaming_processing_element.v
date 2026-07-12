//====================================================
// ForgeAI
//
// Module ID : FA-015
// Module    : streaming_processing_element
// Author    : Daniel Simpson
//
// Description:
// Parameterized streaming processing element.
//
// On each enabled clock:
// - Forwards activation to the right
// - Forwards weight downward
// - Accumulates activation_in * weight_in
//
//====================================================

module streaming_processing_element #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32
)(
    input  wire                           clk,
    input  wire                           rst,
    input  wire                           compute_en,
    input  wire                           clear_acc,

    input  wire signed [DATA_WIDTH-1:0]   activation_in,
    input  wire signed [DATA_WIDTH-1:0]   weight_in,

    output reg  signed [DATA_WIDTH-1:0]   activation_out,
    output reg  signed [DATA_WIDTH-1:0]   weight_out,
    output reg  signed [ACC_WIDTH-1:0]    acc_out
);

    localparam PRODUCT_WIDTH = DATA_WIDTH * 2;

    wire signed [PRODUCT_WIDTH-1:0] product;
    wire signed [ACC_WIDTH-1:0]     product_ext;

    assign product = activation_in * weight_in;

    assign product_ext = {
        {(ACC_WIDTH - PRODUCT_WIDTH){product[PRODUCT_WIDTH-1]}},
        product
    };

    always @(posedge clk) begin
        if (rst) begin
            activation_out <= {DATA_WIDTH{1'b0}};
            weight_out     <= {DATA_WIDTH{1'b0}};
            acc_out        <= {ACC_WIDTH{1'b0}};
        end else begin
            // Registered systolic forwarding
            activation_out <= activation_in;
            weight_out     <= weight_in;

            if (clear_acc) begin
                acc_out <= {ACC_WIDTH{1'b0}};
            end else if (compute_en) begin
                acc_out <= acc_out + product_ext;
            end
        end
    end

endmodule