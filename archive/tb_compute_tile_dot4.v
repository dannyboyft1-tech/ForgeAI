//====================================================
// ForgeAI
//
// Module ID : TB-007
// Module    : tb_compute_tile_dot4
// Author    : Daniel Simpson
//
// Description:
// Testbench for compute_tile_dot4.
//
//====================================================

`timescale 1ns/1ps

module tb_compute_tile_dot4;

    reg clk;
    reg rst;
    reg start;

    reg signed [7:0] a0, a1, a2, a3;
    reg signed [7:0] w0, w1, w2, w3;

    wire signed [31:0] result;
    wire done;

    compute_tile_dot4 uut (
        .clk(clk),
        .rst(rst),
        .start(start),

        .a0(a0), .a1(a1), .a2(a2), .a3(a3),
        .w0(w0), .w1(w1), .w2(w2), .w3(w3),

        .result(result),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("compute_tile_dot4.vcd");
        $dumpvars(0, tb_compute_tile_dot4);

        clk = 0;
        rst = 0;
        start = 0;

        a0 = 0; a1 = 0; a2 = 0; a3 = 0;
        w0 = 0; w1 = 0; w2 = 0; w3 = 0;

        // Reset
        rst = 1;
        #10;
        rst = 0;

        // Test 1:
        // [1,2,3,4] dot [5,6,7,8]
        // 1*5 + 2*6 + 3*7 + 4*8 = 70
        a0 = 8'sd1; a1 = 8'sd2; a2 = 8'sd3; a3 = 8'sd4;
        w0 = 8'sd5; w1 = 8'sd6; w2 = 8'sd7; w3 = 8'sd8;

        start = 1;
        #10;
        start = 0;
        #10;

        // Test 2:
        // [-1,2,-3,4] dot [5,-6,7,-8]
        // -5 -12 -21 -32 = -70
        a0 = -8'sd1; a1 =  8'sd2; a2 = -8'sd3; a3 =  8'sd4;
        w0 =  8'sd5; w1 = -8'sd6; w2 =  8'sd7; w3 = -8'sd8;

        start = 1;
        #10;
        start = 0;
        #10;

        // Test 3:
        // [10,10,10,10] dot [1,1,1,1] = 40
        a0 = 8'sd10; a1 = 8'sd10; a2 = 8'sd10; a3 = 8'sd10;
        w0 = 8'sd1;  w1 = 8'sd1;  w2 = 8'sd1;  w3 = 8'sd1;

        start = 1;
        #10;
        start = 0;
        #10;

        $finish;
    end

endmodule