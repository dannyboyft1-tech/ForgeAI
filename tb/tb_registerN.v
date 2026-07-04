//====================================================
// ForgeAI
//
// Module: tb_registerN
// Author: Daniel Simpson
//
// Description:
// Testbench for parameterized registerN.
// Tests both 8-bit and 32-bit instances.
//
//====================================================

`timescale 1ns/1ps

module tb_registerN;

    reg clk;
    reg rst;
    reg en;

    reg  [7:0]  d8;
    wire [7:0]  q8;

    reg  [31:0] d32;
    wire [31:0] q32;

    registerN #(
        .WIDTH(8)
    ) reg8_uut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .d(d8),
        .q(q8)
    );

    registerN #(
        .WIDTH(32)
    ) reg32_uut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .d(d32),
        .q(q32)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("registerN.vcd");
        $dumpvars(0, tb_registerN);

        clk = 0;
        rst = 0;
        en  = 0;
        d8  = 8'h00;
        d32 = 32'h00000000;

        // Reset both registers
        rst = 1;
        #10;
        rst = 0;

        // Load both registers
        en  = 1;
        d8  = 8'hA5;
        d32 = 32'hDEADBEEF;
        #10;

        // Disable enable; both should hold
        en  = 0;
        d8  = 8'hFF;
        d32 = 32'hFFFFFFFF;
        #20;

        // Re-enable and load new values
        en  = 1;
        d8  = 8'h3C;
        d32 = 32'h12345678;
        #10;

        // Reset again
        rst = 1;
        #10;
        rst = 0;
        en  = 0;

        #10;

        $finish;
    end

endmodule