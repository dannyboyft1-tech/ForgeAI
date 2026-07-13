`timescale 1ns / 1ps

//====================================================
// ForgeAI
//
// Testbench: tb_edge_detect
//
// Verifies:
//   1. Reset suppresses both outputs.
//   2. Stable low produces no pulse.
//   3. Rising transition produces one rise pulse.
//   4. Stable high produces no extra pulse.
//   5. Falling transition produces one fall pulse.
//   6. Stable low produces no extra pulse.
//   7. Multiple transitions are detected correctly.
//   8. Reset while level is high produces no false rise.
//   9. Release from reset is handled correctly.
//
//====================================================

module tb_edge_detect;

    //------------------------------------------------
    // Testbench signals
    //------------------------------------------------

    reg clk;
    reg rst;
    reg level;

    wire rise;
    wire fall;

    integer error_count;

    //------------------------------------------------
    // Device under test
    //------------------------------------------------

    edge_detect dut (
        .clk   (clk),
        .rst   (rst),
        .level (level),
        .rise  (rise),
        .fall  (fall)
    );

    //------------------------------------------------
    // Clock generation
    //
    // 10 ns period
    // 100 MHz
    //------------------------------------------------

    initial begin
        clk = 1'b0;

        forever begin
            #5 clk = ~clk;
        end
    end

    //------------------------------------------------
    // Wait for clock cycles
    //------------------------------------------------

    task wait_cycles;
        input integer cycles;
        integer index;

        begin
            for (index = 0; index < cycles; index = index + 1) begin
                @(posedge clk);
            end
        end
    endtask

    //------------------------------------------------
    // Output check
    //------------------------------------------------

    task check_outputs;
        input expected_rise;
        input expected_fall;
        input [255:0] test_name;

        begin
            #1;

            if ((rise !== expected_rise) ||
                (fall !== expected_fall)) begin

                $display(
                    "FAIL: %0s | expected rise=%b fall=%b | actual rise=%b fall=%b",
                    test_name,
                    expected_rise,
                    expected_fall,
                    rise,
                    fall
                );

                error_count = error_count + 1;
            end
            else begin
                $display(
                    "PASS: %0s | rise=%b fall=%b",
                    test_name,
                    rise,
                    fall
                );
            end
        end
    endtask

    //------------------------------------------------
    // Test sequence
    //------------------------------------------------

    initial begin

        $dumpfile("tb_edge_detect.vcd");
        $dumpvars(0, tb_edge_detect);

        error_count = 0;

        rst   = 1'b1;
        level = 1'b0;

        //------------------------------------------------
        // Test 1:
        // Reset suppresses outputs
        //------------------------------------------------

        wait_cycles(2);

        check_outputs(
            1'b0,
            1'b0,
            "Reset suppresses both outputs"
        );

        //------------------------------------------------
        // Test 2:
        // Stable low after reset
        //------------------------------------------------

        rst = 1'b0;

        wait_cycles(2);

        check_outputs(
            1'b0,
            1'b0,
            "Stable low produces no edge"
        );

        //------------------------------------------------
        // Test 3:
        // Rising transition
        //------------------------------------------------

        @(negedge clk);
        level = 1'b1;

        #1;

        check_outputs(
            1'b1,
            1'b0,
            "Low-to-high transition asserts rise"
        );

        //------------------------------------------------
        // Test 4:
        // Rising pulse clears after one clock
        //------------------------------------------------

        @(posedge clk);

        check_outputs(
            1'b0,
            1'b0,
            "Rise pulse lasts one clock cycle"
        );

        //------------------------------------------------
        // Test 5:
        // Stable high
        //------------------------------------------------

        wait_cycles(2);

        check_outputs(
            1'b0,
            1'b0,
            "Stable high produces no edge"
        );

        //------------------------------------------------
        // Test 6:
        // Falling transition
        //------------------------------------------------

        @(negedge clk);
        level = 1'b0;

        #1;

        check_outputs(
            1'b0,
            1'b1,
            "High-to-low transition asserts fall"
        );

        //------------------------------------------------
        // Test 7:
        // Falling pulse clears after one clock
        //------------------------------------------------

        @(posedge clk);

        check_outputs(
            1'b0,
            1'b0,
            "Fall pulse lasts one clock cycle"
        );

        //------------------------------------------------
        // Test 8:
        // Stable low
        //------------------------------------------------

        wait_cycles(2);

        check_outputs(
            1'b0,
            1'b0,
            "Stable low produces no additional edge"
        );

        //------------------------------------------------
        // Test 9:
        // Second rising transition
        //------------------------------------------------

        @(negedge clk);
        level = 1'b1;

        #1;

        check_outputs(
            1'b1,
            1'b0,
            "Second rising transition detected"
        );

        @(posedge clk);

        check_outputs(
            1'b0,
            1'b0,
            "Second rise pulse clears"
        );

        //------------------------------------------------
        // Test 10:
        // Second falling transition
        //------------------------------------------------

        @(negedge clk);
        level = 1'b0;

        #1;

        check_outputs(
            1'b0,
            1'b1,
            "Second falling transition detected"
        );

        @(posedge clk);

        check_outputs(
            1'b0,
            1'b0,
            "Second fall pulse clears"
        );

        //------------------------------------------------
        // Test 11:
        // Reset while level is high
        //
        // First establish a high input and allow the
        // internal previous_level register to capture it.
        //------------------------------------------------

        @(negedge clk);
        level = 1'b1;

        @(posedge clk);

        check_outputs(
            1'b0,
            1'b0,
            "High level captured before reset test"
        );

        //------------------------------------------------
        // Assert reset while level remains high.
        // Both outputs must remain suppressed.
        //------------------------------------------------

        @(negedge clk);
        rst = 1'b1;

        @(posedge clk);

        check_outputs(
            1'b0,
            1'b0,
            "Outputs suppressed during reset while level is high"
        );

        //------------------------------------------------
        // Keep reset asserted for another cycle
        //------------------------------------------------

        wait_cycles(1);

        check_outputs(
            1'b0,
            1'b0,
            "Outputs remain suppressed while reset is held"
        );

        //------------------------------------------------
        // Test 12:
        // Release reset while level remains high
        //
        // Because reset cleared previous_level to zero,
        // releasing reset while level is still high
        // creates a valid rising transition.
        //------------------------------------------------

        @(negedge clk);
        rst = 1'b0;

        #1;

        check_outputs(
            1'b1,
            1'b0,
            "Reset release with level high produces one rise pulse"
        );

        @(posedge clk);

        check_outputs(
            1'b0,
            1'b0,
            "Post-reset rise pulse clears after one clock"
        );

        //------------------------------------------------
        // Test 13:
        // Return low after reset sequence
        //------------------------------------------------

        @(negedge clk);
        level = 1'b0;

        #1;

        check_outputs(
            1'b0,
            1'b1,
            "Return low after reset sequence produces fall pulse"
        );

        @(posedge clk);

        check_outputs(
            1'b0,
            1'b0,
            "Final fall pulse clears"
        );

        //------------------------------------------------
        // Final result
        //------------------------------------------------

        if (error_count == 0) begin
            $display("");
            $display("========================================");
            $display("EDGE DETECT TEST PASSED");
            $display("All edge detection tests completed.");
            $display("========================================");
        end
        else begin
            $display("");
            $display("========================================");
            $display("EDGE DETECT TEST FAILED");
            $display("Total errors: %0d", error_count);
            $display("========================================");
        end

        $finish;
    end

endmodule