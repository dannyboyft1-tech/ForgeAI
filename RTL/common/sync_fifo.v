//====================================================
// ForgeAI
//
// Module ID : FA-011
// Module    : sync_fifo
// Author    : Daniel Simpson
//
// Description:
// Parameterized synchronous FIFO.
//
//====================================================

module sync_fifo #(
    parameter DATA_WIDTH = 32,
    parameter DEPTH      = 16
)(
    input  wire                     clk,
    input  wire                     rst,

    input  wire                     write_en,
    input  wire [DATA_WIDTH-1:0]    write_data,

    input  wire                     read_en,
    output reg  [DATA_WIDTH-1:0]    read_data,

    output wire                     empty,
    output wire                     full
);

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    reg [$clog2(DEPTH):0] write_ptr;
    reg [$clog2(DEPTH):0] read_ptr;
    reg [$clog2(DEPTH+1)-1:0] count;

    assign empty = (count == 0);
    assign full  = (count == DEPTH);

    always @(posedge clk) begin

        if (rst) begin

            write_ptr <= 0;
            read_ptr  <= 0;
            count     <= 0;
            read_data <= 0;

        end
        else begin

            //--------------------------------------------------
            // Write
            //--------------------------------------------------

            if (write_en && !full) begin

                mem[write_ptr] <= write_data;
                write_ptr <= (write_ptr == DEPTH-1) ? 0 : write_ptr + 1;

            end

            //--------------------------------------------------
            // Read
            //--------------------------------------------------

            if (read_en && !empty) begin

                read_data <= mem[read_ptr];
                read_ptr <= (read_ptr == DEPTH-1) ? 0 : read_ptr + 1;

            end

            //--------------------------------------------------
            // Count
            //--------------------------------------------------

            case ({write_en && !full, read_en && !empty})

                2'b10: count <= count + 1;

                2'b01: count <= count - 1;

                default: count <= count;

            endcase

        end

    end

endmodule