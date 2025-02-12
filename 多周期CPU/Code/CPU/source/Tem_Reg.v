`timescale 1ns / 1ps
module Tem_Reg(
    input CLK,
    input [31:0]in,
    input Wre,  //Ğ´Ê¹ÄÜ
    output reg[31:0] out
    );
    initial begin
        out<=0;
    end
    always@(posedge CLK) begin
        if (Wre) out<=in;
    end
endmodule
