//====================================================
// ForgeAI
//
// Module ID : TB-006
// Module    : tb_macN
// Author    : Daniel Simpson
//
// Description:
// Testbench for parameterized signed MAC with clear_acc.
//
//====================================================

`timescale 1ns/1ps

module tb_macN;

    reg clk;
    reg rst;
    reg clear_acc;
    reg en;

    reg  signed [7:0]  a8;
    reg  signed [7:0]  b8;
    wire signed [31:0] acc8;

    macN #(
        .DATA_WIDTH(8),
        .ACC_WIDTH(32)
    ) mac8_uut (
        .clk(clk),
        .rst(rst),
        .clear_acc(clear_acc),
        .en(en),
        .a(a8),
        .b(b8),
        .acc(acc8)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("macN.vcd");
        $dumpvars(0, tb_macN);

        clk = 0;
        rst = 0;
        clear_acc = 0;
        en  = 0;
        a8  = 8'sd0;
        b8  = 8'sd0;

        // Reset
        rst = 1;
        #10;
        rst = 0;

        // acc = 0 + 5*7 = 35
        en = 1;
        a8 = 8'sd5;
        b8 = 8'sd7;
        #10;

        // acc = 35 + -3*10 = 5
        a8 = -8'sd3;
        b8 =  8'sd10;
        #10;

        // Clear accumulator without reset
        clear_acc = 1;
        #10;
        clear_acc = 0;

        // acc = 0 + -4*-6 = 24
        a8 = -8'sd4;
        b8 = -8'sd6;
        #10;

        // Hold test
        en = 0;
        a8 = 8'sd100;
        b8 = 8'sd100;
        #20;

        // Re-enable: acc = 24 + 2*-8 = 8
        en = 1;
        a8 =  8'sd2;
        b8 = -8'sd8;
        #10;

        $finish;
    end

endmodule