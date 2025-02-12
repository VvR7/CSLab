`timescale 1ns / 1ps
module CPU(
    input CLK,
    input Reset,
    output [31:0]PC,
    output [31:0]newaddress,
    output [31:0]Instruction,
    output [31:0]Reg_S,
    output [31:0]Reg_T,
    output [31:0]ALU_OUT,
    output [31:0]W_data
    );
    //  控制器所需变量
    wire Zero;
    wire Sign;
    wire PC_Wre;
    wire ALUsrcA;
    wire ALUsrcB;
    wire Data_Src;
    wire Reg_Wre;
    wire Ins_Mem_RD;
    wire Mem_RD;
    wire Mem_Wre;
    wire Reg_Dst;
    wire ExtOP;
    wire [2:0]ALUOP;
    wire [1:0]PC_Src;
    //ALU所需变量
    wire [31:0]ALUA;
    wire [31:0]ALUB;
    //存储器
    wire [31:0]Mem_OUT;
    //扩展立即数
    wire [31:0]immidiate_32;
    //寄存器堆
    wire [4:0]W_Reg;
    wire [31:0]PC4=PC+4;
    assign newaddress= (PC_Src==2'b00)? PC4
                                    :(PC_Src==2'b01) ? PC4+(immidiate_32<<2)
                                    :{PC4[31:28],Instruction[25:0],2'b00};
    //ALU B口来自data2还是立即数
    mul_32 mul_32_1(Reg_T,immidiate_32,ALUsrcB,ALUB);
    //目的寄存器是rt还是rd
    mul_5 mul_5(Instruction[20:16],Instruction[15:11],Reg_Dst,W_Reg);
    //ALU A口来自data1还是sa
    mul_32 mul_32_2(Reg_S,{27'b000000000000000000000000000,Instruction[10:6]},ALUsrcA,ALUA);
    //寄存器写来自ALU还是存储器
    mul_32 mul_32_3(ALU_OUT,Mem_OUT,Data_Src,W_data);
    //16位立即数扩展到32位
    Ext_16_to_32 newimmidiate(Instruction[15:0],ExtOP,immidiate_32);
    
    ALU myALU(ALUA,ALUB,ALUOP,ALU_OUT,Zero,Sign);
    Control myControl(Zero,Sign,Instruction[31:26],Instruction[5:0],PC_Wre,ALUsrcA,ALUsrcB,Data_Src,Reg_Wre,Ins_Mem_RD,Mem_RD,Mem_Wre,Reg_Dst,ExtOP,ALUOP,PC_Src);
    Ins_Mem myIns_Mem(PC,Ins_Mem_RD,Instruction);
    PC myPC(CLK,Reset,PC_Wre,newaddress,PC);
    Data_mem myData(CLK,Mem_RD,Mem_Wre,ALU_OUT,ALU_OUT,Reg_T,Mem_OUT);
    Reg_file myReg(Reg_Wre,CLK,W_Reg,W_data,Instruction[25:21],Instruction[20:16],Reg_S,Reg_T);
endmodule
