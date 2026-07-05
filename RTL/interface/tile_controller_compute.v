//====================================================
// ForgeAI
//
// Module ID : FA-012C
// Module    : tile_controller_compute
// Author    : Daniel Simpson
//
// Description:
// Tile controller with FIFO input and compute tile control.
// Reads activation/weight words from FIFO, loads compute tile,
// clears accumulator, starts compute, captures result.
//
//====================================================

module tile_controller_compute (
    input  wire        clk,
    input  wire        rst,
    input  wire        start,

    input  wire        fifo_empty,
    output reg         fifo_read_en,
    input  wire [31:0] fifo_read_data,

    output reg         act_load,
    output reg         wgt_load,
    output reg         acc_clear,
    output reg         compute_en,

    output reg  [31:0] activations,
    output reg  [31:0] weights,

    input  wire        tile_done,
    input  wire [31:0] tile_result,

    output reg         busy,
    output reg         done,
    output reg [31:0]  result,
    output reg [3:0]   state
);

    localparam IDLE          = 4'd0;
    localparam READ_ACT      = 4'd1;
    localparam LATCH_ACT     = 4'd2;
    localparam READ_WGT      = 4'd3;
    localparam LATCH_WGT     = 4'd4;
    localparam LOAD_TILE     = 4'd5;
    localparam CLEAR_ACC     = 4'd6;
    localparam COMPUTE       = 4'd7;
    localparam WAIT_DONE     = 4'd8;
    localparam STORE_RESULT  = 4'd9;
    localparam DONE_STATE    = 4'd10;

    always @(posedge clk) begin
        if (rst) begin
            state        <= IDLE;
            fifo_read_en <= 1'b0;
            act_load     <= 1'b0;
            wgt_load     <= 1'b0;
            acc_clear    <= 1'b0;
            compute_en   <= 1'b0;
            activations  <= 32'd0;
            weights      <= 32'd0;
            busy         <= 1'b0;
            done         <= 1'b0;
            result       <= 32'd0;
        end else begin
            fifo_read_en <= 1'b0;
            act_load     <= 1'b0;
            wgt_load     <= 1'b0;
            acc_clear    <= 1'b0;
            compute_en   <= 1'b0;
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
                    state    <= CLEAR_ACC;
                end

                CLEAR_ACC: begin
                    acc_clear <= 1'b1;
                    state     <= COMPUTE;
                end

                COMPUTE: begin
                    compute_en <= 1'b1;
                    state      <= WAIT_DONE;
                end

                WAIT_DONE: begin
                    if (tile_done) begin
                        state <= STORE_RESULT;
                    end
                end

                STORE_RESULT: begin
                    result <= tile_result;
                    state  <= DONE_STATE;
                end

                DONE_STATE: begin
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