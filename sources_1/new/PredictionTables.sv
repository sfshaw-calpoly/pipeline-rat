`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/02/2017 02:46:24 PM
// Design Name:
// Module Name: PredictionTables
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module PredictionTables(
    input wire clk,
    input wire rst,
    input wire we,
    input wire branch_taken,
    input wire [9:0] pc,
    input wire [9:0] old_pc,
    input wire update_pc,
    input wire evict,
    input wire [2:0] evict_idx,
    input wire [2:0] prev_history,
    input wire update_valid,
    input wire [2:0] update_history,
    output wire prediction
    );

    parameter ENTRY_WIDTH = 3;
    parameter ENTRY_DEPTH = 1 << ENTRY_WIDTH;

    wire table_index = pc[2:0];
    wire update_table_index = old_pc[2:0];

    logic ind_rst [0:ENTRY_DEPTH - 1];
    logic [1:0] ind_prediction [0:ENTRY_DEPTH - 1];
    logic ind_update [0:ENTRY_DEPTH - 1];

    generate
        genvar idx;
        for (idx = 0; idx < 8; idx++) begin
            assign ind_update[integer'(idx)] = (integer'(update_table_index) == integer'(idx) && we); // TODO: check that old_pc is right
            assign ind_rst[integer'(idx)] = (integer'(update_table_index) == integer'(idx) || rst);
        end
    endgenerate

    RecTable tables [0:ENTRY_DEPTH - 1] (
        .clk(clk),
        .rst(ind_rst),
        .rec(ind_prediction),
        .update(ind_update),
        .addr(prev_history),
        .wr_addr(update_history),
        .taken(branch_taken)
    );

    assign prediction = ind_prediction[integer'(table_index)][1];




endmodule
