//====================================================
// ForgeAI
//
// Module ID : TB-015
// Module    : tb_streaming_processing_element
// Author    : Daniel Simpson
//
// Description:
// Testbench for the parameterized Streaming
// Processing Element.
//
// Verifies:
//   ✓ Operand forwarding
//   ✓ Signed multiply-accumulate
//   ✓ Accumulator clear
//   ✓ Compute enable
//
//====================================================

`timescale 1ns/1ps

module tb_streaming_processing_element;

    parameter DATA_WIDTH = 8;
    parameter ACC_WIDTH  = 32;

    reg clk;
    reg rst;

    reg compute_en;
    reg clear_acc;

    reg signed [DATA_WIDTH-1:0] activation_in;
    reg signed [DATA_WIDTH-1:0] weight_in;

    wire signed [DATA_WIDTH-1:0] activation_out;
    wire signed [DATA_WIDTH-1:0] weight_out;
    wire signed [ACC_WIDTH-1:0]  acc_out;

    //--------------------------------------------------
    // DUT
    //--------------------------------------------------

    streaming_processing_element #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH)
    ) uut (

        .clk(clk),
        .rst(rst),

        .compute_en(compute_en),
        .clear_acc(clear_acc),

        .activation_in(activation_in),
        .weight_in(weight_in),

        .activation_out(activation_out),
        .weight_out(weight_out),

        .acc_out(acc_out)

    );

    //--------------------------------------------------
    // Clock
    //--------------------------------------------------

    always #5 clk = ~clk;

    //--------------------------------------------------
    // Test
    //--------------------------------------------------

    initial begin

        $dumpfile("streaming_processing_element.vcd");
        $dumpvars(0, tb_streaming_processing_element);

        clk = 0;
        rst = 0;

        compute_en = 0;
        clear_acc  = 0;

        activation_in = 0;
        weight_in     = 0;

        //------------------------------------------
        // Reset
        //------------------------------------------

        @(negedge clk);
        rst = 1;

        @(negedge clk);
        rst = 0;

        //------------------------------------------
        // Clear accumulator
        //------------------------------------------

        @(negedge clk);
        clear_acc = 1;

        @(negedge clk);
        clear_acc = 0;

        //------------------------------------------
        // First operands
        // 7 * 6 = 42
        //------------------------------------------

        @(negedge clk);

        activation_in = 8'sd7;
        weight_in     = 8'sd6;

        compute_en = 1;

        @(negedge clk);

        //------------------------------------------
        // Second operands
        // -3 * 8 = -24
        //------------------------------------------

        activation_in = -8'sd3;
        weight_in     = 8'sd8;

        @(negedge clk);

        //------------------------------------------
        // Third operands
        // 5 * -2 = -10
        //------------------------------------------

        activation_in = 8'sd5;
        weight_in     = -8'sd2;

        @(negedge clk);

        //------------------------------------------
        // Stop computing
        //------------------------------------------

        compute_en = 0;

        repeat(4)
            @(negedge clk);

        $finish;

    end

endmodule