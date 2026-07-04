//====================================================
// ForgeAI
//
// Module: tb_register8
// Author: Daniel Simpson
//
// Description:
// Testbench for register8.
// Verifies reset, enable, load, and hold behavior.
//
//====================================================

`timescale 1ns/1ps

module tb_register8;

    reg        clk;
    reg        rst;
    reg        en;
    reg  [7:0] d;
    wire [7:0] q;

    register8 uut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .d(d),
        .q(q)
    );

    // Clock generator: 10 ns period = 100 MHz
    always #5 clk = ~clk;

    initial begin
        $dumpfile("register8.vcd");
        $dumpvars(0, tb_register8);

        clk = 0;
        rst = 0;
        en  = 0;
        d   = 8'h00;

        // Reset the register
        rst = 1;
        #10;
        rst = 0;

        // Load A5
        d  = 8'hA5;
        en = 1;
        #10;

        // Disable enable and change input
        // q should HOLD A5
        en = 0;
        d  = 8'hFF;
        #20;

        // Re-enable and load 3C
        en = 1;
        d  = 8'h3C;
        #10;

        // Reset again
        rst = 1;
        #10;
        rst = 0;

        #10;

        $finish;
    end

endmodule