`timescale 1ns / 1ps
module Data_mem(
    input CLK,
    input RD_EN,
    input W_EN,
    input [31:0]R_addr,
    input [31:0]W_addr,
    input [31:0]W_data,
    output reg [31:0]R_data
    );
    reg[7:0]Mem[255:0];
    always@(negedge CLK) begin
        if (W_EN) begin
            Mem[W_addr]<=W_data[31:24];
            Mem[W_addr+1]<=W_data[23:16];
            Mem[W_addr+2]<=W_data[15:8];
            Mem[W_addr+3]<=W_data[7:0];
        end
    end
    always@(RD_EN or R_addr) begin
        if (RD_EN) begin
            R_data<={Mem[R_addr],Mem[R_addr+1],Mem[R_addr+2],Mem[R_addr+3]};
        end
    end
endmodule
