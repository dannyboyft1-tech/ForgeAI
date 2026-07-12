//====================================================
// ForgeAI
//
// Module: forge_bringup
// Author: Daniel Simpson
//
// Description:
// First Arty Z7-20 hardware bring-up.
// Divides the 125 MHz board clock and blinks LED0.
//
//====================================================

module forge_bringup (
    input  wire clk,
    output wire led0
);

    reg [26:0] counter = 27'd0;

    always @(posedge clk) begin
        counter <= counter + 1'b1;
    end

    assign led0 = counter[26];

endmodule