//====================================================
// ForgeAI
//
// Module ID : TB-005
// Module    : tb_mac_int8
// Author    : Daniel Simpson
//
// Description:
// Testbench for signed INT8 MAC unit.
//
//====================================================

`timescale 1ns/1ps

module tb_mac_int8;

    reg clk;
    reg rst;
    reg en;

    reg  signed [7:0]  a;
    reg  signed [7:0]  b;
    wire signed [31:0] acc;

    mac_int8 uut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .a(a),
        .b(b),
        .acc(acc)
    );

    // 10 ns period = 100 MHz
    always #5 clk = ~clk;

    initial begin
        $dumpfile("mac_int8.vcd");
        $dumpvars(0, tb_mac_int8);

        clk = 0;
        rst = 0;
        en  = 0;
        a   = 8'sd0;
        b   = 8'sd0;

        // Reset accumulator
        rst = 1;
        #10;
        rst = 0;

        // acc = 0 + (5 * 7) = 35
        en = 1;
        a  = 8'sd5;
        b  = 8'sd7;
        #10;

        // acc = 35 + (-3 * 10) = 5
        a = -8'sd3;
        b =  8'sd10;
        #10;

        // acc = 5 + (-4 * -6) = 29
        a = -8'sd4;
        b = -8'sd6;
        #10;

        // Disable enable; acc should hold 29
        en = 0;
        a  = 8'sd100;
        b  = 8'sd100;
        #20;

        // Re-enable; acc = 29 + (2 * -8) = 13
        en = 1;
        a  =  8'sd2;
        b  = -8'sd8;
        #10;

        // Reset again; acc = 0
        rst = 1;
        #10;
        rst = 0;
        en  = 0;

        #10;

        $finish;
    end

endmodule