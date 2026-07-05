//====================================================
// ForgeAI
//
// Module ID : FA-012B
// Module    : tile_controller_fifo
// Author    : Daniel Simpson
//
// Description:
// Tile controller with FIFO input integration.
// Reads activation and weight words from FIFO and
// presents them to the compute tile interface.
//
//====================================================

module tile_controller_fifo (
    input  wire        clk,
    input  wire        rst,
    input  wire        start,

    input  wire        fifo_empty,
    output reg         fifo_read_en,
    input  wire [31:0] fifo_read_data,

    output reg         act_load,
    output reg         wgt_load,
    output reg [31:0]  activations,
    output reg [31:0]  weights,

    output reg         busy,
    output reg         done,
    output reg [2:0]   state
);

    localparam IDLE       = 3'd0;
    localparam READ_ACT   = 3'd1;
    localparam LATCH_ACT  = 3'd2;
    localparam READ_WGT   = 3'd3;
    localparam LATCH_WGT  = 3'd4;
    localparam LOAD_TILE  = 3'd5;
    localparam DONE       = 3'd6;

    always @(posedge clk) begin
        if (rst) begin
            state        <= IDLE;
            fifo_read_en <= 1'b0;
            act_load     <= 1'b0;
            wgt_load     <= 1'b0;
            activations  <= 32'd0;
            weights      <= 32'd0;
            busy         <= 1'b0;
            done         <= 1'b0;
        end else begin
            fifo_read_en <= 1'b0;
            act_load     <= 1'b0;
            wgt_load     <= 1'b0;
            done         <= 1'b0;

            case (state)

                IDLE: begin
                    busy <= 1'b0;

                    if (start && !fifo_empty) begin
                        busy         <= 1'b1;
                        fifo_read_en <= 1'b1;
                        state        <= READ_ACT;
                    end
                end

                READ_ACT: begin
                    state <= LATCH_ACT;
                end

                LATCH_ACT: begin
                    activations <= fifo_read_data;

                    if (!fifo_empty) begin
                        fifo_read_en <= 1'b1;
                        state        <= READ_WGT;
                    end
                end

                READ_WGT: begin
                    state <= LATCH_WGT;
                end

                LATCH_WGT: begin
                    weights <= fifo_read_data;
                    state   <= LOAD_TILE;
                end

                LOAD_TILE: begin
                    act_load <= 1'b1;
                    wgt_load <= 1'b1;
                    state    <= DONE;
                end

                DONE: begin
                    busy  <= 1'b0;
                    done  <= 1'b1;
                    state <= IDLE;
                end

                default: begin
                    state <= IDLE;
                    busy  <= 1'b0;
                end

            endcase
        end
    end

endmodule