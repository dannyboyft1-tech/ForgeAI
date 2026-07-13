//====================================================
// ForgeAI
//
// Module ID : TB-009
// Module    : tb_compute_tile_4pe
// Author    : Daniel Simpson
//
// Description:
// Clock-driven testbench for the 4-Processing Element AI Compute Tile.
//
//====================================================

`timescale 1ns/1ps

module tb_compute_tile_4pe;

    reg clk;
    reg rst;

    reg act_load;
    reg wgt_load;
    reg acc_clear;
    reg compute_en;

    reg signed [31:0] activations;
    reg signed [31:0] weights;

    wire signed [31:0] tile_result;
    wire done;

    compute_tile_4pe uut (
        .clk(clk),
        .rst(rst),
        .act_load(act_load),
        .wgt_load(wgt_load),
        .acc_clear(acc_clear),
        .compute_en(compute_en),
        .activations(activations),
        .weights(weights),
        .tile_result(tile_result),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("compute_tile_4pe.vcd");
        $dumpvars(0, tb_compute_tile_4pe);

        clk = 0;
        rst = 0;
        act_load = 0;
        wgt_load = 0;
        acc_clear = 0;
        compute_en = 0;
        activations = 32'sd0;
        weights = 32'sd0;

        // Reset
        @(negedge clk);
        rst = 1;
        @(negedge clk);
        rst = 0;

        // Load Test 1: [1,2,3,4] dot [5,6,7,8] = 70
        @(negedge clk);
        activations = {8'sd4, 8'sd3, 8'sd2, 8'sd1};
        weights     = {8'sd8, 8'sd7, 8'sd6, 8'sd5};
        act_load = 1;
        wgt_load = 1;

        @(negedge clk);
        act_load = 0;
        wgt_load = 0;

        // Compute once
        @(negedge clk);
        compute_en = 1;

        @(negedge clk);
        compute_en = 0;

        // Load Test 2 activations only: [5,6,7,8] using same weights = 174
        @(negedge clk);
        activations = {8'sd8, 8'sd7, 8'sd6, 8'sd5};
        act_load = 1;

        @(negedge clk);
        act_load = 0;

        // Compute once: total should be 70 + 174 = 244
        @(negedge clk);
        compute_en = 1;

        @(negedge clk);
        compute_en = 0;

        // Hold for two cycles
        @(negedge clk);
        @(negedge clk);

        // Clear accumulator
        @(negedge clk);
        acc_clear = 1;

        @(negedge clk);
        acc_clear = 0;

        // Compute once after clear: should be 174
        @(negedge clk);
        compute_en = 1;

        @(negedge clk);
        compute_en = 0;

        @(negedge clk);
        $finish;
    end

endmodule