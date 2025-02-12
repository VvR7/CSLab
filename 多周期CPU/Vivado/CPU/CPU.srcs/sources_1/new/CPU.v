`timescale 1ns / 1ps
module CPU(
    input CLK,
    input Reset,
    output [31:0]PC,
    output [31:0]newaddress,
    output [31:0]Instruction,
    output [31:0]ALUA,
    output [31:0]ALUB,
    output [31:0]ALU_OUT,
    output [31:0]W_data,
    output [4:0]W_reg,
    output [31:0]R_data1,
    output [31:0]R_data2,
    output [31:0]Ext_imm,
    //五个临时寄存器里的值:
    output [31:0]Daout,
    output [31:0]Dbout,
    output [31:0]ALUDout,
    output [31:0] DBSrc,
    output [31:0]Dinstruction,
    //状态
    output [2:0]state  
    );
    wire Zero,Sign,PC_Wre,ALUsrcA,ALUsrcB,Reg_Wre,Ins_Mem_RD,Mem_RD,Mem_Wre,ExtOP,IR_Wre,Data_Src,Wd;
    wire [1:0]Reg_Dst;
    wire [2:0]ALUOP;
    wire[1:0]PC_Src;
    wire [31:0]PC4,jPC,bPC;
    wire [31:0]Mem_OUT;
    wire [31:0]DBout;
    //五个临时寄存器
    Tem_Reg Da(CLK,R_data1,1,Daout);
    Tem_Reg Db(CLK,R_data2,1,Dbout);
    Tem_Reg alu(CLK,ALU_OUT,1,ALUDout);
    Tem_Reg db(CLK,DBout,1,DBSrc);
    Tem_Reg ins(CLK,Instruction,IR_Wre,Dinstruction);
    //ALU B口来自data2还是立即数
    Mul_2_32 Mux2_1(Dbout,Ext_imm,ALUsrcB,ALUB);
    //目的寄存器是rt还是rd还是$31
    Mul_3_5 Mul_3_1(Dinstruction[20:16],Dinstruction[15:11],5'b11111,Reg_Dst,W_reg);
    //ALU A口来自data1还是sa
    Mul_2_32 Mux2_2(Daout,{27'b000000000000000000000000000,Dinstruction[10:6]},ALUsrcA,ALUA);
    //DB总线来源
    Mul_2_32 Mux2_3(ALU_OUT,Mem_OUT,Data_Src,DBout);//是ALU_OUT不是ALUDout，因为下一周期上升沿DBout就写入DBSrc，从而写回寄存器
    //立即数扩展
    Ext_16_to_32 newimmidiate(Dinstruction[15:0],ExtOP,Ext_imm);
    //写入寄存器的是db总线，还是pc+4（jal）指令
    Mul_2_32 Mux2_4(PC4,DBSrc,Wd,W_data);
    //下地址计算:
    Mux_4_32 nextPC(PC4,bPC,R_data1,jPC,PC_Src,newaddress);
    assign PC4=PC+4;
    assign bPC=PC4+(Ext_imm<<2);
    assign jPC={PC4[31:28],Instruction[25:0],2'b00};
    
    ALU myALU(ALUA,ALUB,ALUOP,ALU_OUT,Zero,Sign);
    Ins_Mem myInsmen(PC,Ins_Mem_RD,Instruction);
    PC myPC(CLK,Reset,PC_Wre,newaddress,PC);
    Data_mem myData(CLK,Mem_RD,Mem_Wre,ALUDout,ALUDout,Dbout,Mem_OUT);
    Reg_file myreg(Reg_Wre,CLK,W_reg,W_data,Dinstruction[25:21],Dinstruction[20:16],R_data1,R_data2);
    Control mycontrol(Reset,CLK,Zero,Sign,Dinstruction[31:26],Dinstruction[5:0],PC_Wre,ALUsrcA,ALUsrcB,Data_Src,Reg_Wre,Ins_Mem_RD,Mem_RD,Mem_Wre,Reg_Dst,ExtOP,ALUOP,PC_Src,state,IR_Wre,Wd);
endmodule
