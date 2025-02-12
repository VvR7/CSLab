`timescale 1ns / 1ps
module CPU_tb();
    reg CLK;
    reg Reset;
    wire [31:0]PC;
    wire [31:0]newaddress;
    wire [31:0]Instruction;
    wire [31:0]ALUA;
    wire [31:0]ALUB;
    wire [31:0]ALU_OUT;
    wire [31:0]W_data;
    wire [4:0]W_reg;
    wire [31:0]R_data1;
    wire [31:0]R_data2;
    wire [31:0]Ext_imm;
    wire [31:0]Daout;
    wire [31:0]Dbout;
    wire [31:0]ALUDout;
    wire [31:0]DBSrc;
    wire [31:0]Dinstruction;
    wire [2:0]state;
    //CPU mycpu(CLK,Reset,PC,newaddress,Instruction,Reg_S,Reg_T,ALU_OUT,W_data);
    CPU mycpu(
        .CLK(CLK),
        .Reset(Reset),
        .PC(PC),
        .newaddress(newaddress),
        .Instruction(Instruction),
        .ALUA(ALUA),
        .ALUB(ALUB),
        .ALU_OUT(ALU_OUT),
        .W_data(W_data),
        .W_reg(W_reg),
        .R_data1(R_data1),
        .R_data2(R_data2),
        .Ext_imm(Ext_imm),
        .Daout(Daout),
        .Dbout(Dbout),
        .ALUDout(ALUDout),
        .DBSrc(DBSrc),
        .Dinstruction(Dinstruction),
        .state(state)
    );    
    integer i;
    initial begin
        Reset=1;CLK=0;
        #50;
        CLK=1;
        #50;
        Reset=0;CLK=0;
        for (i=0;i<1000;i=i+1)
        begin
            #50;
            CLK=!CLK;
        end
    end
endmodule
