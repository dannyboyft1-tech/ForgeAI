`timescale 1ns / 1ps

//====================================================
// ForgeAI
//
// Module: edge_detect
//
// Description:
// Detects rising and falling transitions on a
// synchronous input signal.
//
// Outputs are asserted for exactly one clock cycle.
//
//====================================================

module edge_detect (
    input  wire clk,
    input  wire rst,
    input  wire level,

    output wire rise,
    output wire fall
);

    reg previous_level;

    always @(posedge clk) begin
        if (rst) begin
            previous_level <= 1'b0;
        end
        else begin
            previous_level <= level;
        end
    end

    assign rise = ~rst &  level & ~previous_level;
    assign fall = ~rst & ~level &  previous_level;
    
endmodule