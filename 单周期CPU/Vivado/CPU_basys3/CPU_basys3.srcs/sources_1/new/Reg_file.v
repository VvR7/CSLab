`timescale 1ns / 1ps
module Reg_file(
    input W_EN,
    input CLK,
    input [4:0]W_reg,
    input [31:0]W_data,
    input [4:0]RD_reg1,
    input [4:0]RD_reg2,
    output [31:0]RD_data1,
    output [31:0]RD_data2
    );
    reg[31:0] registers[31:0];
    integer i;
    initial begin
        for (i=0;i<32;i=i+1)
          registers[i]<=0;
    end
    assign RD_data1=registers[RD_reg1];
    assign RD_data2=registers[RD_reg2];
    always@(negedge CLK) begin
        if (W_EN) begin
            registers[W_reg]<=W_data;
        end
    end
endmodule
