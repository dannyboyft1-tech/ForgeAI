//====================================================
// ForgeAI
//
// Module ID : TB-012B
// Module    : tb_tile_controller_fifo
// Author    : Daniel Simpson
//
// Description:
// Testbench for tile_controller_fifo.
//
//====================================================

`timescale 1ns/1ps

module tb_tile_controller_fifo;

    reg clk;
    reg rst;
    reg start;

    reg         fifo_write_en;
    reg [31:0] fifo_write_data;

    wire        fifo_empty;
    wire        fifo_full;
    wire        fifo_read_en;
    wire [31:0] fifo_read_data;

    wire        act_load;
    wire        wgt_load;
    wire [31:0] activations;
    wire [31:0] weights;

    wire        busy;
    wire        done;
    wire [2:0]  state;

    sync_fifo #(
        .DATA_WIDTH(32),
        .DEPTH(4)
    ) input_fifo (
        .clk(clk),
        .rst(rst),
        .write_en(fifo_write_en),
        .write_data(fifo_write_data),
        .read_en(fifo_read_en),
        .read_data(fifo_read_data),
        .empty(fifo_empty),
        .full(fifo_full)
    );

    tile_controller_fifo uut (
        .clk(clk),
        .rst(rst),
        .start(start),

        .fifo_empty(fifo_empty),
        .fifo_read_en(fifo_read_en),
        .fifo_read_data(fifo_read_data),

        .act_load(act_load),
        .wgt_load(wgt_load),
        .activations(activations),
        .weights(weights),

        .busy(busy),
        .done(done),
        .state(state)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("tile_controller_fifo.vcd");
        $dumpvars(0, tb_tile_controller_fifo);

        clk = 0;
        rst = 0;
        start = 0;
        fifo_write_en = 0;
        fifo_write_data = 32'd0;

        // Reset
        @(negedge clk);
        rst = 1;
        @(negedge clk);
        rst = 0;

        // Write activation word to FIFO: {4,3,2,1}
        @(negedge clk);
        fifo_write_data = 32'h04030201;
        fifo_write_en = 1;

        // Write weight word to FIFO: {8,7,6,5}
        @(negedge clk);
        fifo_write_data = 32'h08070605;

        @(negedge clk);
        fifo_write_en = 0;

        // Start controller
        @(negedge clk);
        start = 1;

        @(negedge clk);
        start = 0;

        // Wait for completion
        repeat (12)
            @(negedge clk);

        $finish;
    end

endmodule