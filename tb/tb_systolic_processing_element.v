//====================================================
// ForgeAI
//
// Module ID : TB-013
// Module    : tb_systolic_processing_element
// Author    : Daniel Simpson
//
// Description:
// Testbench for the systolic processing element.
//
// Verifies:
//   - Activation forwarding
//   - Weight forwarding
//   - MAC computation
//
//====================================================

`timescale 1ns/1ps

module tb_systolic_processing_element;

    reg clk;
    reg rst;

    reg act_load;
    reg wgt_load;
    reg acc_clear;
    reg compute_en;

    reg signed [7:0] activation_in;
    reg signed [7:0] weight_in;

    wire signed [7:0] activation_out;
    wire signed [7:0] weight_out;

    wire signed [31:0] acc_out;

    //--------------------------------------------------
    // DUT
    //--------------------------------------------------

    systolic_processing_element uut (

        .clk(clk),
        .rst(rst),

        .act_load(act_load),
        .wgt_load(wgt_load),
        .acc_clear(acc_clear),
        .compute_en(compute_en),

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

        $dumpfile("systolic_processing_element.vcd");
        $dumpvars(0, tb_systolic_processing_element);

        clk = 0;
        rst = 0;

        act_load = 0;
        wgt_load = 0;
        acc_clear = 0;
        compute_en = 0;

        activation_in = 0;
        weight_in = 0;

        //------------------------------------------
        // Reset
        //------------------------------------------

        @(negedge clk);
        rst = 1;

        @(negedge clk);
        rst = 0;

        //------------------------------------------
        // Load operands
        //------------------------------------------

        @(negedge clk);

        activation_in = 8'sd7;
        weight_in     = 8'sd6;

        act_load = 1;
        wgt_load = 1;

        @(negedge clk);

        act_load = 0;
        wgt_load = 0;

        //------------------------------------------
        // Clear accumulator
        //------------------------------------------

        @(negedge clk);

        acc_clear = 1;

        @(negedge clk);

        acc_clear = 0;

        //------------------------------------------
        // Compute once
        //------------------------------------------

        @(negedge clk);

        compute_en = 1;

        @(negedge clk);

        compute_en = 0;

        //------------------------------------------
        // Compute again
        //------------------------------------------

        @(negedge clk);

        compute_en = 1;

        @(negedge clk);

        compute_en = 0;

        repeat (4)
            @(negedge clk);

        $finish;

    end

endmodule