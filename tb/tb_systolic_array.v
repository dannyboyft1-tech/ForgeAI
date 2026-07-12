//====================================================
// ForgeAI
//
// Module ID : TB-014A
// Module    : tb_systolic_array
// Author    : Daniel Simpson
//
// Description:
// Testbench for the parameterized systolic array.
//
// Stage A Verification:
// - Generate loops instantiate correctly
// - Every PE computes independently
// - No systolic routing yet
//
//====================================================

`timescale 1ns/1ps

module tb_systolic_array;

    parameter ROWS = 4;
    parameter COLS = 4;

    reg clk;
    reg rst;

    reg act_load;
    reg wgt_load;
    reg acc_clear;
    reg compute_en;

    reg [ROWS*8-1:0] activations_in;
    reg [COLS*8-1:0] weights_in;

    wire [ROWS*COLS*32-1:0] accumulators_out;

    //--------------------------------------------------
    // DUT
    //--------------------------------------------------

    systolic_array #(
        .ROWS(ROWS),
        .COLS(COLS)
    ) uut (

        .clk(clk),
        .rst(rst),

        .act_load(act_load),
        .wgt_load(wgt_load),
        .acc_clear(acc_clear),
        .compute_en(compute_en),

        .activations_in(activations_in),
        .weights_in(weights_in),

        .accumulators_out(accumulators_out)

    );

    //--------------------------------------------------
    // Clock
    //--------------------------------------------------

    always #5 clk = ~clk;

    //--------------------------------------------------
    // Test
    //--------------------------------------------------

    initial begin

        $dumpfile("systolic_array.vcd");
        $dumpvars(0, tb_systolic_array);

        clk = 0;
        rst = 0;

        act_load = 0;
        wgt_load = 0;
        acc_clear = 0;
        compute_en = 0;

        //------------------------------------------
        // Row activations
        //
        // Row0 = 1
        // Row1 = 2
        // Row2 = 3
        // Row3 = 4
        //------------------------------------------

        activations_in = {
            8'd4,
            8'd3,
            8'd2,
            8'd1
        };

        //------------------------------------------
        // Column weights
        //
        // Col0 = 5
        // Col1 = 6
        // Col2 = 7
        // Col3 = 8
        //------------------------------------------

        weights_in = {
            8'd8,
            8'd7,
            8'd6,
            8'd5
        };

        //------------------------------------------
        // Reset
        //------------------------------------------

        @(negedge clk);
        rst = 1;

        @(negedge clk);
        rst = 0;

        //------------------------------------------
        // Load
        //------------------------------------------

        @(negedge clk);

        act_load = 1;
        wgt_load = 1;

        @(negedge clk);

        act_load = 0;
        wgt_load = 0;

        //------------------------------------------
        // Clear
        //------------------------------------------

        @(negedge clk);

        acc_clear = 1;

        @(negedge clk);

        acc_clear = 0;

        //------------------------------------------
        // Compute
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