`timescale 1ns / 1ps
module Mux_4_32(
    input [31:0]A,
    input [31:0]B,
    input [31:0]C,
    input [31:0]D,
    input [1:0]op,
    output [31:0]out
    );
    assign out= (op==2'b00)?A:
                (op==2'b01)?B:
                (op==2'b10)?C:
                D;
                
endmodule
