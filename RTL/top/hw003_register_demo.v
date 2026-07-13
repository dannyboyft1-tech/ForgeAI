`timescale 1ns / 1ps

//====================================================
// ForgeAI
//
// Hardware Milestone : HW-003
// Module             : hw003_register_demo
//
// Description:
// Hardware demonstration of the frozen registerN
// and debounce primitives.
//
// SW[1:0] provides register data.
// BTN0 loads the switch value after debouncing.
// BTN1 resets the register and control logic.
// LED[1:0] displays the stored register value.
// LED[3:2] remains off.
//
//====================================================

module hw003_register_demo #(
    parameter DEBOUNCE_COUNT_MAX = 500000
)(
    input  wire       clk,
    input  wire       btn0,
    input  wire       btn1,
    input  wire [1:0] sw,

    output wire [3:0] led
);

    //------------------------------------------------
    // Internal signals
    //------------------------------------------------

    wire       btn0_clean;
    wire [1:0] register_q;



    //------------------------------------------------
    // BTN0 debounce
    //------------------------------------------------

    debounce #(
        .COUNT_MAX(DEBOUNCE_COUNT_MAX)
    ) u_btn0_debounce (
        .clk   (clk),
        .rst   (btn1),
        .noisy (btn0),
        .clean (btn0_clean)
    );

    //------------------------------------------------
    // Rising-edge detector
    //
    // Produces one clock-cycle pulse when the
    // debounced BTN0 signal changes from 0 to 1.
    //------------------------------------------------

    wire load_pulse;

    edge_detect u_edge_detect (
    .clk   (clk),
    .rst   (btn1),
    .level (btn0_clean),
    .rise  (load_pulse),
    .fall  ()
);

    //------------------------------------------------
    // Two-bit hardware register
    //------------------------------------------------

    registerN #(
        .WIDTH(2)
    ) u_register (
        .clk (clk),
        .rst (btn1),
        .en  (load_pulse),
        .d   (sw),
        .q   (register_q)
    );

    //------------------------------------------------
    // LED outputs
    //------------------------------------------------

    assign led[1:0] = register_q;
    assign led[3:2] = 2'b00;

endmodule