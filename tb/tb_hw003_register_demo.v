`timescale 1ns / 1ps

//====================================================
// ForgeAI
//
// Hardware Milestone : HW-003
// Testbench           : tb_hw003_register_demo
//
// Description:
// Verifies the HW-003 register hardware demo.
//
// Tests:
//   1. Reset clears the register.
//   2. Switch changes do not directly change LEDs.
//   3. Short BTN0 bounce does not load the register.
//   4. Stable BTN0 press loads the switch value.
//   5. Holding BTN0 produces only one load event.
//   6. BTN0 must be released before another load.
//   7. BTN1 clears the stored value.
//
//====================================================

module tb_hw003_register_demo;

    //------------------------------------------------
    // Testbench signals
    //------------------------------------------------

    reg        clk;
    reg        btn0;
    reg        btn1;
    reg  [1:0] sw;

    wire [3:0] led;

    //------------------------------------------------
    // Testbench control
    //------------------------------------------------

    integer error_count;
    integer load_pulse_count;

    localparam DEBOUNCE_COUNT_MAX = 4;

    //------------------------------------------------
    // Device under test
    //------------------------------------------------

    hw003_register_demo #(
        .DEBOUNCE_COUNT_MAX(DEBOUNCE_COUNT_MAX)
    ) dut (
        .clk  (clk),
        .btn0 (btn0),
        .btn1 (btn1),
        .sw   (sw),
        .led  (led)
    );

    //------------------------------------------------
    // 125 MHz clock
    //
    // Period = 8 ns
    //------------------------------------------------

    initial begin
        clk = 1'b0;

        forever begin
            #4 clk = ~clk;
        end
    end

    //------------------------------------------------
    // Count internal load pulses
    //
    // This verifies that one button press produces
    // exactly one register enable pulse.
    //------------------------------------------------

    always @(posedge clk) begin
        if (btn1) begin
            load_pulse_count <= 0;
        end
        else if (dut.load_pulse) begin
            load_pulse_count <= load_pulse_count + 1;
        end
    end

    //------------------------------------------------
    // Check task
    //------------------------------------------------

    task check_led;
        input [3:0] expected;
        input [255:0] test_name;

        begin
            #1;

            if (led !== expected) begin
                $display(
                    "FAIL: %0s | expected led = %b, actual led = %b",
                    test_name,
                    expected,
                    led
                );

                error_count = error_count + 1;
            end
            else begin
                $display(
                    "PASS: %0s | led = %b",
                    test_name,
                    led
                );
            end
        end
    endtask

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
    // Test sequence
    //------------------------------------------------

    initial begin

        $dumpfile("tb_hw003_register_demo.vcd");
        $dumpvars(0, tb_hw003_register_demo);

        error_count     = 0;
        load_pulse_count = 0;

        btn0 = 1'b0;
        btn1 = 1'b1;
        sw   = 2'b00;

        //------------------------------------------------
        // Allow synchronizer input to settle
        //------------------------------------------------

        wait_cycles(4);

        //------------------------------------------------
        // Test 1: Reset clears register
        //------------------------------------------------

        btn1 = 1'b0;

        wait_cycles(2);

        check_led(
            4'b0000,
            "Reset clears register"
        );

        //------------------------------------------------
        // Test 2: Switch changes alone do not affect LEDs
        //------------------------------------------------

        sw = 2'b11;

        wait_cycles(3);

        check_led(
            4'b0000,
            "Switch changes do not directly affect LEDs"
        );

        //------------------------------------------------
        // Test 3: Short bounce must not load register
        //------------------------------------------------

        btn0 = 1'b1;
        wait_cycles(1);

        btn0 = 1'b0;
        wait_cycles(1);

        btn0 = 1'b1;
        wait_cycles(1);

        btn0 = 1'b0;

        wait_cycles(DEBOUNCE_COUNT_MAX + 4);

        check_led(
            4'b0000,
            "Short BTN0 bounce does not load register"
        );

        if (load_pulse_count !== 0) begin
            $display(
                "FAIL: Bounce generated load pulse | count = %0d",
                load_pulse_count
            );

            error_count = error_count + 1;
        end
        else begin
            $display(
                "PASS: Bounce generated no load pulse"
            );
        end

        //------------------------------------------------
        // Test 4: Stable press loads 2'b11
        //------------------------------------------------

        btn0 = 1'b1;

        wait_cycles(DEBOUNCE_COUNT_MAX + 5);

        check_led(
            4'b0011,
            "Stable BTN0 press loads switch value 11"
        );

        if (load_pulse_count !== 1) begin
            $display(
                "FAIL: First press pulse count | expected 1, actual %0d",
                load_pulse_count
            );

            error_count = error_count + 1;
        end
        else begin
            $display(
                "PASS: First press generated exactly one load pulse"
            );
        end

        //------------------------------------------------
        // Test 5: Holding BTN0 must not continuously load
        //------------------------------------------------

        sw = 2'b01;

        wait_cycles(DEBOUNCE_COUNT_MAX + 5);

        check_led(
            4'b0011,
            "Holding BTN0 does not reload changed switches"
        );

        if (load_pulse_count !== 1) begin
            $display(
                "FAIL: Held button generated extra pulses | count = %0d",
                load_pulse_count
            );

            error_count = error_count + 1;
        end
        else begin
            $display(
                "PASS: Held button generated no extra load pulses"
            );
        end

        //------------------------------------------------
        // Release BTN0 and allow debounce to return low
        //------------------------------------------------

        btn0 = 1'b0;

        wait_cycles(DEBOUNCE_COUNT_MAX + 5);

        check_led(
            4'b0011,
            "Releasing BTN0 does not alter stored value"
        );

        //------------------------------------------------
        // Test 6: Second stable press loads 2'b01
        //------------------------------------------------

        btn0 = 1'b1;

        wait_cycles(DEBOUNCE_COUNT_MAX + 5);

        check_led(
            4'b0001,
            "Second BTN0 press loads switch value 01"
        );

        if (load_pulse_count !== 2) begin
            $display(
                "FAIL: Two presses pulse count | expected 2, actual %0d",
                load_pulse_count
            );

            error_count = error_count + 1;
        end
        else begin
            $display(
                "PASS: Two presses generated exactly two load pulses"
            );
        end

        //------------------------------------------------
        // Release BTN0 before reset test
        //------------------------------------------------

        btn0 = 1'b0;

        wait_cycles(DEBOUNCE_COUNT_MAX + 5);

        //------------------------------------------------
        // Test 7: BTN1 resets the register
        //------------------------------------------------

        btn1 = 1'b1;

        wait_cycles(2);

        check_led(
            4'b0000,
            "BTN1 clears stored register value"
        );

        //------------------------------------------------
        // Final result
        //------------------------------------------------

        if (error_count == 0) begin
            $display("");
            $display("========================================");
            $display("HW-003 TEST PASSED");
            $display("All register demo tests completed.");
            $display("========================================");
        end
        else begin
            $display("");
            $display("========================================");
            $display("HW-003 TEST FAILED");
            $display("Total errors: %0d", error_count);
            $display("========================================");
        end

        $finish;
    end

endmodule