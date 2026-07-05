//====================================================
// ForgeAI
//
// Module: tb_multiplierN
// Author: Daniel Simpson
//
// Description:
// Testbench for parameterized combinational multiplier.
//
//====================================================

`timescale 1ns/1ps

module tb_multiplierN;

    reg  [7:0]  a8;
    reg  [7:0]  b8;
    wire [15:0] product8;

    reg  [15:0] a16;
    reg  [15:0] b16;
    wire [31:0] product16;

    multiplierN #(
        .WIDTH(8)
    ) mult8_uut (
        .a(a8),
        .b(b8),
        .product(product8)
    );

    multiplierN #(
        .WIDTH(16)
    ) mult16_uut (
        .a(a16),
        .b(b16),
        .product(product16)
    );

    initial begin
        $dumpfile("multiplierN.vcd");
        $dumpvars(0, tb_multiplierN);

        a8 = 8'd5;
        b8 = 8'd7;

        a16 = 16'd100;
        b16 = 16'd25;
        #10;

        a8 = 8'd255;
        b8 = 8'd2;

        a16 = 16'd65535;
        b16 = 16'd2;
        #10;

        a8 = 8'd12;
        b8 = 8'd12;

        a16 = 16'd1234;
        b16 = 16'd56;
        #10;

        $finish;
    end

endmodule