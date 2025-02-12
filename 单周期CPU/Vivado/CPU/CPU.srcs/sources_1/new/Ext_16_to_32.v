`timescale 1ns / 1ps
module Ext_16_to_32(
    input [15:0]immidiate,
    input Extop,
    output  [31:0]immidiate_32
    );
    assign immidiate_32 = (Extop && immidiate[15]) ? {16'b1111111111111111, immidiate} : {16'b0000000000000000, immidiate};
endmodule
