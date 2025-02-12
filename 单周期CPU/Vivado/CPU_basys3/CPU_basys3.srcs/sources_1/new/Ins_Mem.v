`timescale 1ns / 1ps
module Ins_Mem(
    input [31:0]R_addr,
    input R_EN,
    output reg[31:0]Ins
    );
    reg [7:0]Mem[255:0];
    initial begin  //用测试的指令来初始化Mem
        $readmemb("E:/vivado_lab/input _mips.txt",Mem);
    end
    always@(R_addr or R_EN) begin
        if (R_EN) begin  //大端存储
            Ins<={Mem[R_addr],Mem[R_addr+1],Mem[R_addr+2],Mem[R_addr+3]};
        end
    end
endmodule
