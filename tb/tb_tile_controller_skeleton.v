//====================================================
// ForgeAI
//
// Module ID : TB-012A
// Module    : tb_tile_controller_skeleton
// Author    : Daniel Simpson
//
// Description:
// Testbench for Tile Controller Skeleton.
//
//====================================================

`timescale 1ns/1ps

module tb_tile_controller_skeleton;

    reg clk;
    reg rst;
    reg start;

    wire busy;
    wire done;
    wire [2:0] state;

    tile_controller_skeleton uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .busy(busy),
        .done(done),
        .state(state)
    );

    // 100 MHz clock
    always #5 clk = ~clk;

    initial begin

        $dumpfile("tile_controller_skeleton.vcd");
        $dumpvars(0, tb_tile_controller_skeleton);

        clk   = 0;
        rst   = 0;
        start = 0;

        //---------------------------------------
        // Reset
        //---------------------------------------

        @(negedge clk);
        rst = 1;

        @(negedge clk);
        rst = 0;

        //---------------------------------------
        // Start one transaction
        //---------------------------------------

        @(negedge clk);
        start = 1;

        @(negedge clk);
        start = 0;

        //---------------------------------------
        // Wait long enough for controller
        //---------------------------------------

        repeat (8)
            @(negedge clk);

        //---------------------------------------
        // Start another transaction
        //---------------------------------------

        @(negedge clk);
        start = 1;

        @(negedge clk);
        start = 0;

        repeat (8)
            @(negedge clk);

        $finish;

    end

endmodule