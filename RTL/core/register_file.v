//====================================================
// ForgeAI
//
// Module ID : FA-007
// Module    : register_file
// Author    : Daniel Simpson
//
// Description:
// 32 x 32-bit register file.
//
// R0 is hardwired to zero.
//
// Two asynchronous read ports.
// One synchronous write port.
//
//====================================================

module register_file (

    input  wire         clk,
    input  wire         rst,

    input  wire [4:0]   read_addr_a,
    input  wire [4:0]   read_addr_b,

    output wire signed [31:0]  read_data_a,
    output wire signed [31:0]  read_data_b,

    input  wire         write_en,
    input  wire [4:0]   write_addr,
    input  wire signed [31:0]  write_data

);

    reg signed [31:0] registers [31:0];

    integer i;

    //------------------------------------------------
    // Synchronous Write
    //------------------------------------------------

    always @(posedge clk) begin

        if (rst) begin

            for(i=1;i<32;i=i+1)
                registers[i] <= 32'd0;

        end
        else if(write_en && (write_addr != 5'd0)) begin

            registers[write_addr] <= write_data;

        end

    end

    //------------------------------------------------
    // Asynchronous Reads
    //------------------------------------------------

    assign read_data_a =
        (read_addr_a == 5'd0)
        ? 32'd0
        : registers[read_addr_a];

    assign read_data_b =
        (read_addr_b == 5'd0)
        ? 32'd0
        : registers[read_addr_b];

endmodule