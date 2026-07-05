//====================================================
// ForgeAI
//
// Module ID : TB-011
// Module    : tb_sync_fifo
// Author    : Daniel Simpson
//
// Description:
// Testbench for parameterized synchronous FIFO.
//
//====================================================

`timescale 1ns/1ps

module tb_sync_fifo;

    reg clk;
    reg rst;

    reg        write_en;
    reg [31:0] write_data;

    reg        read_en;
    wire [31:0] read_data;

    wire empty;
    wire full;

    sync_fifo #(
        .DATA_WIDTH(32),
        .DEPTH(4)
    ) uut (
        .clk(clk),
        .rst(rst),
        .write_en(write_en),
        .write_data(write_data),
        .read_en(read_en),
        .read_data(read_data),
        .empty(empty),
        .full(full)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sync_fifo.vcd");
        $dumpvars(0, tb_sync_fifo);

        clk = 0;
        rst = 0;
        write_en = 0;
        write_data = 32'd0;
        read_en = 0;

        // Reset
        @(negedge clk);
        rst = 1;
        @(negedge clk);
        rst = 0;

        // Write 4 words: FIFO should become full
        @(negedge clk); write_data = 32'hAAAA0001; write_en = 1;
        @(negedge clk); write_data = 32'hBBBB0002;
        @(negedge clk); write_data = 32'hCCCC0003;
        @(negedge clk); write_data = 32'hDDDD0004;
        @(negedge clk); write_en = 0;

        // Read 2 words
        @(negedge clk); read_en = 1;
        @(negedge clk);
        @(negedge clk); read_en = 0;

        // Write 2 more words to test wraparound
        @(negedge clk); write_data = 32'hEEEE0005; write_en = 1;
        @(negedge clk); write_data = 32'hFFFF0006;
        @(negedge clk); write_en = 0;

        // Read all remaining words
        @(negedge clk); read_en = 1;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk); read_en = 0;

        // Attempt read while empty
        @(negedge clk); read_en = 1;
        @(negedge clk); read_en = 0;

        @(negedge clk);
        $finish;
    end

endmodule