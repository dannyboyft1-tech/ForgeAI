//====================================================
// ForgeAI
//
// Module ID : TB-012C
// Module    : tb_tile_controller_compute
//
// Description:
// End-to-end integration test.
//
// FIFO
//   ↓
// Tile Controller
//   ↓
// Compute Tile (4 PE)
//
//====================================================

`timescale 1ns/1ps

module tb_tile_controller_compute;

    reg clk;
    reg rst;
    reg start;

    //--------------------------------------------------
    // FIFO Write Interface
    //--------------------------------------------------

    reg        fifo_write_en;
    reg [31:0] fifo_write_data;

    wire       fifo_empty;
    wire       fifo_full;
    wire       fifo_read_en;
    wire [31:0] fifo_read_data;

    //--------------------------------------------------
    // Controller -> Tile
    //--------------------------------------------------

    wire        act_load;
    wire        wgt_load;
    wire        acc_clear;
    wire        compute_en;

    wire [31:0] activations;
    wire [31:0] weights;

    //--------------------------------------------------
    // Tile Outputs
    //--------------------------------------------------

    wire [31:0] tile_result;
    wire        tile_done;

    //--------------------------------------------------
    // Controller Outputs
    //--------------------------------------------------

    wire busy;
    wire done;
    wire [31:0] result;
    wire [3:0] state;

    //--------------------------------------------------
    // Clock
    //--------------------------------------------------

    always #5 clk = ~clk;

    //--------------------------------------------------
    // FIFO
    //--------------------------------------------------

    sync_fifo #(
        .DATA_WIDTH(32),
        .DEPTH(4)
    ) fifo (

        .clk(clk),
        .rst(rst),

        .write_en(fifo_write_en),
        .write_data(fifo_write_data),

        .read_en(fifo_read_en),
        .read_data(fifo_read_data),

        .empty(fifo_empty),
        .full(fifo_full)

    );

    //--------------------------------------------------
    // Controller
    //--------------------------------------------------

    tile_controller_compute controller (

        .clk(clk),
        .rst(rst),
        .start(start),

        .fifo_empty(fifo_empty),
        .fifo_read_en(fifo_read_en),
        .fifo_read_data(fifo_read_data),

        .act_load(act_load),
        .wgt_load(wgt_load),
        .acc_clear(acc_clear),
        .compute_en(compute_en),

        .activations(activations),
        .weights(weights),

        .tile_done(tile_done),
        .tile_result(tile_result),

        .busy(busy),
        .done(done),
        .result(result),
        .state(state)

    );

    //--------------------------------------------------
    // Compute Tile
    //--------------------------------------------------

    compute_tile_4pe tile (

        .clk(clk),
        .rst(rst),

        .act_load(act_load),
        .wgt_load(wgt_load),
        .acc_clear(acc_clear),
        .compute_en(compute_en),

        .activations(activations),
        .weights(weights),

        .tile_result(tile_result),
        .done(tile_done)

    );

    //--------------------------------------------------
    // Test
    //--------------------------------------------------

    initial begin

        $dumpfile("tile_controller_compute.vcd");
        $dumpvars(0, tb_tile_controller_compute);

        clk = 0;
        rst = 0;
        start = 0;

        fifo_write_en = 0;
        fifo_write_data = 0;

        //-------------------------
        // Reset
        //-------------------------

        @(negedge clk);
        rst = 1;

        @(negedge clk);
        rst = 0;

        //-------------------------
        // Write activation vector
        //
        // [1 2 3 4]
        //-------------------------

        @(negedge clk);

        fifo_write_data = 32'h04030201;
        fifo_write_en = 1;

        //-------------------------
        // Write weight vector
        //
        // [5 6 7 8]
        //-------------------------

        @(negedge clk);

        fifo_write_data = 32'h08070605;

        @(negedge clk);

        fifo_write_en = 0;

        //-------------------------
        // Start accelerator
        //-------------------------

        @(negedge clk);

        start = 1;

        @(negedge clk);

        start = 0;

        //-------------------------
        // Wait
        //-------------------------

        repeat(20)
            @(negedge clk);

        $finish;

    end

endmodule