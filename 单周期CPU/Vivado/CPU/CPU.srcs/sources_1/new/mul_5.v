`timescale 1ns / 1ps
module mul_5(
    input [4:0]A,
    input [4:0]B,
    input op,
    output [4:0]out
    );
    assign out=(op==0)?A:B;
endmodule
