//====================================================
// ForgeAI
//
// Module ID : FA-010
// Module    : forgeai_device_regs
// Author    : Daniel Simpson
//
// Description:
// Host-facing device register block for ForgeAI.
// Provides device identity, version, status, control,
// and result registers.
//
//====================================================

module forgeai_device_regs (
    input  wire        clk,
    input  wire        rst,

    input  wire        write_en,
    input  wire [7:0]  write_addr,
    input  wire [31:0] write_data,

    input  wire [7:0]  read_addr,
    output reg  [31:0] read_data,

    input  wire        busy,
    input  wire        done,
    input  wire [31:0] result_in,

    output reg         start,
    output reg         clear
);

    localparam DEVICE_ID_ADDR = 8'h00;
    localparam VERSION_ADDR   = 8'h04;
    localparam STATUS_ADDR    = 8'h08;
    localparam CONTROL_ADDR   = 8'h0C;
    localparam RESULT_ADDR    = 8'h10;

    localparam DEVICE_ID      = 32'hF0A10001;
    localparam VERSION        = 32'h00000001;

    always @(posedge clk) begin
        if (rst) begin
            start <= 1'b0;
            clear <= 1'b0;
        end else begin
            start <= 1'b0;
            clear <= 1'b0;

            if (write_en && write_addr == CONTROL_ADDR) begin
                start <= write_data[0];
                clear <= write_data[1];
            end
        end
    end

    always @(*) begin
        case (read_addr)
            DEVICE_ID_ADDR: read_data = DEVICE_ID;
            VERSION_ADDR:   read_data = VERSION;
            STATUS_ADDR:    read_data = {30'd0, done, busy};
            CONTROL_ADDR:   read_data = 32'd0;
            RESULT_ADDR:    read_data = result_in;
            default:        read_data = 32'hDEADBEEF;
        endcase
    end

endmodule