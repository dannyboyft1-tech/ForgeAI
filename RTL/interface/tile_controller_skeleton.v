//====================================================
// ForgeAI
//
// Module ID : FA-012A
// Module    : tile_controller_skeleton
// Author    : Daniel Simpson
//
// Description:
// Stage 1 tile controller skeleton.
// Verifies controller state sequencing only.
//
//====================================================

module tile_controller_skeleton (
    input  wire       clk,
    input  wire       rst,
    input  wire       start,

    output reg        busy,
    output reg        done,
    output reg [2:0]  state
);

    localparam IDLE       = 3'd0;
    localparam READ_ACT   = 3'd1;
    localparam READ_WGT   = 3'd2;
    localparam LOAD_TILE  = 3'd3;
    localparam COMPUTE    = 3'd4;
    localparam STORE_RES  = 3'd5;

    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            busy  <= 1'b0;
            done  <= 1'b0;
        end else begin
            done <= 1'b0;

            case (state)

                IDLE: begin
                    busy <= 1'b0;

                    if (start) begin
                        state <= READ_ACT;
                        busy  <= 1'b1;
                    end
                end

                READ_ACT: begin
                    state <= READ_WGT;
                end

                READ_WGT: begin
                    state <= LOAD_TILE;
                end

                LOAD_TILE: begin
                    state <= COMPUTE;
                end

                COMPUTE: begin
                    state <= STORE_RES;
                end

                STORE_RES: begin
                    state <= IDLE;
                    busy  <= 1'b0;
                    done  <= 1'b1;
                end

                default: begin
                    state <= IDLE;
                    busy  <= 1'b0;
                    done  <= 1'b0;
                end

            endcase
        end
    end

endmodule