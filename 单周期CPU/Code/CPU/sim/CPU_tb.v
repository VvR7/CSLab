`timescale 1ns / 1ps
module CPU_tb();
    reg CLK;
    reg Reset;
    wire [31:0]PC;
    wire [31:0]newaddress;
    wire [31:0]Instruction;
    wire [31:0]Reg_S;
    wire [31:0]Reg_T;
    wire [31:0]ALU_OUT;
    wire [31:0]W_data;
    //CPU mycpu(CLK,Reset,PC,newaddress,Instruction,Reg_S,Reg_T,ALU_OUT,W_data);
    CPU mycpu(
        .CLK(CLK),
        .Reset(Reset),
        .PC(PC),
        .newaddress(newaddress),
        .Instruction(Instruction),
        .Reg_S(Reg_S),
        .Reg_T(Reg_T),
        .ALU_OUT(ALU_OUT),
        .W_data(W_data)
    );    
    integer i;
    initial begin
        Reset=1;CLK=0;
        #50;
        CLK=1;
        #50;
        Reset=0;CLK=0;
        for (i=0;i<100;i=i+1)
        begin
            #50;
            CLK=!CLK;
        end
    end
endmodule
