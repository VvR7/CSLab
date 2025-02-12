`timescale 1ns / 1ps
module Mux_3_32(
    input [31:0]A,
    input [31:0]B,
    input [31:0]C,
    input [1:0]op,
    output [31:0]out
    );
    assign out= (op== 2'b00)?A:
                (op== 2'b01)?B:
                C;
endmodule
