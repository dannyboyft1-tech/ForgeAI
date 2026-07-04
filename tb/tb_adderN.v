//====================================================
// ForgeAI
//
// Module: tb_adderN
// Author: Daniel Simpson
//
// Description:
// Testbench for parameterized combinational adder.
//
//====================================================

`timescale 1ns/1ps

module tb_adderN;

    reg  [7:0] a8;
    reg  [7:0] b8;
    wire [8:0] sum8;

    reg  [31:0] a32;
    reg  [31:0] b32;
    wire [32:0] sum32;

    adderN #(
        .WIDTH(8)
    ) adder8_uut (
        .a(a8),
        .b(b8),
        .sum(sum8)
    );

    adderN #(
        .WIDTH(32)
    ) adder32_uut (
        .a(a32),
        .b(b32),
        .sum(sum32)
    );

    initial begin
        $dumpfile("adderN.vcd");
        $dumpvars(0, tb_adderN);

        a8 = 8'd10;
        b8 = 8'd20;

        a32 = 32'd1000;
        b32 = 32'd2500;
        #10;

        a8 = 8'd255;
        b8 = 8'd1;

        a32 = 32'hFFFFFFFF;
        b32 = 32'd1;
        #10;

        a8 = 8'd42;
        b8 = 8'd58;

        a32 = 32'h12345678;
        b32 = 32'h00000008;
        #10;

        $finish;
    end

endmodule