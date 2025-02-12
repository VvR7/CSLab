`timescale 1ns / 1ps
module Mul_3_5(
    input [4:0]A,
    input [4:0]B,
    input [4:0]C,
    input [1:0]op,
    output [4:0]out
    );
    assign out= (op== 2'b00)?A:
                (op== 2'b01)?B:
                C;
endmodule
