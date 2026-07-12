//====================================================
// ForgeAI
//
// HW-002
//
// Switches to LEDs
//
//====================================================

module forge_hw002_switches(

    input  wire sw0,
    input  wire sw1,

    output wire led0,
    output wire led1,
    output wire led2,
    output wire led3

);

    assign led0 = sw0;
    assign led1 = sw1;

    assign led2 = sw0 ^ sw1;
    assign led3 = sw0 & sw1;

endmodule