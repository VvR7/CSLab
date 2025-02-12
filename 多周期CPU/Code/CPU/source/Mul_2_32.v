`timescale 1ns / 1ps
module Mul_2_32(
    input [31:0]A,
    input [31:0]B,
    input op,
    output [31:0]out
    );
    assign out=(op==1'b0)?A:B;
endmodule
