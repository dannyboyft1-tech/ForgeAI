//====================================================
// ForgeAI
//
// Module ID : TB-008
// Module    : tb_processing_element
// Author    : Daniel Simpson
//
// Description:
// Testbench for AI Processing Element.
//
//====================================================

`timescale 1ns/1ps

module tb_processing_element;

    reg clk;
    reg rst;

    reg act_load;
    reg wgt_load;
    reg acc_clear;
    reg compute_en;

    reg signed [7:0] act_in;
    reg signed [7:0] wgt_in;

    wire signed [31:0] acc_out;

    processing_element uut (
        .clk(clk),
        .rst(rst),
        .act_load(act_load),
        .wgt_load(wgt_load),
        .acc_clear(acc_clear),
        .compute_en(compute_en),
        .act_in(act_in),
        .wgt_in(wgt_in),
        .acc_out(acc_out)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("processing_element.vcd");
        $dumpvars(0, tb_processing_element);

        clk = 0;
        rst = 0;
        act_load = 0;
        wgt_load = 0;
        acc_clear = 0;
        compute_en = 0;
        act_in = 8'sd0;
        wgt_in = 8'sd0;

        // Reset
        rst = 1;
        #10;
        rst = 0;

        // Load activation = 5, weight = 7
        act_in = 8'sd5;
        wgt_in = 8'sd7;
        act_load = 1;
        wgt_load = 1;
        #10;
        act_load = 0;
        wgt_load = 0;

        // Compute: acc = 35
        compute_en = 1;
        #10;

        // Load new activation only: activation = -3, weight stays 7
        act_in = -8'sd3;
        act_load = 1;
        #10;
        act_load = 0;

        // Compute: acc = 35 + (-3 * 7) = 14
        #10;

        // Load new weight only: weight = -2, activation stays -3
        wgt_in = -8'sd2;
        wgt_load = 1;
        #10;
        wgt_load = 0;

        // Compute: acc = 14 + (-3 * -2) = 20
        #10;

        // Hold test
        compute_en = 0;
        act_in = 8'sd100;
        wgt_in = 8'sd100;
        #20;

        // Clear accumulator
        acc_clear = 1;
        #10;
        acc_clear = 0;

        // Compute again with stored activation=-3 and weight=-2
        compute_en = 1;
        #10;

        $finish;
    end

endmodule