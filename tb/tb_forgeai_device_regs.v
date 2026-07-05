//====================================================
// ForgeAI
//
// Module ID : TB-010
// Module    : tb_forgeai_device_regs
// Author    : Daniel Simpson
//
// Description:
// Testbench for ForgeAI host-facing device registers.
//
//====================================================

`timescale 1ns/1ps

module tb_forgeai_device_regs;

    reg clk;
    reg rst;

    reg        write_en;
    reg [7:0]  write_addr;
    reg [31:0] write_data;

    reg  [7:0]  read_addr;
    wire [31:0] read_data;

    reg        busy;
    reg        done;
    reg [31:0] result_in;

    wire start;
    wire clear;

    forgeai_device_regs uut (
        .clk(clk),
        .rst(rst),

        .write_en(write_en),
        .write_addr(write_addr),
        .write_data(write_data),

        .read_addr(read_addr),
        .read_data(read_data),

        .busy(busy),
        .done(done),
        .result_in(result_in),

        .start(start),
        .clear(clear)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("forgeai_device_regs.vcd");
        $dumpvars(0, tb_forgeai_device_regs);

        clk = 0;
        rst = 0;
        write_en = 0;
        write_addr = 8'h00;
        write_data = 32'h00000000;
        read_addr = 8'h00;
        busy = 0;
        done = 0;
        result_in = 32'h00000000;

        // Reset
        @(negedge clk);
        rst = 1;
        @(negedge clk);
        rst = 0;

        // Read DEVICE_ID
        @(negedge clk);
        read_addr = 8'h00;

        // Read VERSION
        @(negedge clk);
        read_addr = 8'h04;

        // Read STATUS: busy=1, done=0
        @(negedge clk);
        busy = 1;
        done = 0;
        read_addr = 8'h08;

        // Read STATUS: busy=0, done=1
        @(negedge clk);
        busy = 0;
        done = 1;
        read_addr = 8'h08;

        // Read RESULT
        @(negedge clk);
        result_in = 32'h000000AE;
        read_addr = 8'h10;

        // Write CONTROL start bit
        @(negedge clk);
        write_addr = 8'h0C;
        write_data = 32'h00000001;
        write_en = 1;

        @(negedge clk);
        write_en = 0;
        write_data = 32'h00000000;

        // Write CONTROL clear bit
        @(negedge clk);
        write_addr = 8'h0C;
        write_data = 32'h00000002;
        write_en = 1;

        @(negedge clk);
        write_en = 0;

        @(negedge clk);
        $finish;
    end

endmodule