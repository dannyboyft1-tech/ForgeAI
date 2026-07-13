//====================================================
// ForgeAI
//
// Module ID : FA-016
// Module    : debounce
// Author    : Daniel Simpson
//
// Description:
// Parameterized pushbutton debouncer.
//
// Produces a single clean output after the input
// remains stable for COUNT_MAX clock cycles.
//
//====================================================

module debounce #(
    parameter COUNT_MAX = 500000
)(
    input  wire clk,
    input  wire rst,
    input  wire noisy,

    output reg clean
);

    localparam COUNT_WIDTH = $clog2(COUNT_MAX);

    reg [COUNT_WIDTH-1:0] counter;
    reg sync0, sync1;

    //------------------------------------------------
    // Synchronize input
    //------------------------------------------------

    always @(posedge clk) begin
        sync0 <= noisy;
        sync1 <= sync0;
    end

    //------------------------------------------------
    // Debounce
    //------------------------------------------------

    always @(posedge clk) begin

        if (rst) begin
            clean   <= 1'b0;
            counter <= 0;
        end
        else begin

            if (sync1 == clean) begin

                counter <= 0;

            end
            else begin

                if (counter == COUNT_MAX-1) begin
                    clean   <= sync1;
                    counter <= 0;
                end
                else begin
                    counter <= counter + 1'b1;
                end

            end

        end

    end

endmodule