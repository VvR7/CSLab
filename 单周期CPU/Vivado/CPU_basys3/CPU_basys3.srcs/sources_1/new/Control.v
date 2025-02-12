`timescale 1ns / 1ps
module Control(
    input Zero,
    input Sign,
    input [5:0]OP,
    input [5:0]func,
    output PC_Wre,
    output ALUsrcA,
    output ALUsrcB,
    output Data_Src,
    output Reg_Wre,
    output Ins_Mem_RD,
    output Mem_RD,
    output Mem_Wre,
    output Reg_Dst,
    output ExtOP,
    output [2:0]ALUOP,
    output [1:0]PC_Src
    );
    parameter R=6'b000000;
    parameter add=6'b100000;
    parameter sub=6'b100010;
    parameter And=6'b100100;
    parameter Or=6'b100101;
    parameter sll=6'b000000;
    //parameter add=6'b000000;
    //parameter sub=6'b000001;
    parameter addiu=6'b001001;
    parameter andi=6'b001100;
    //parameter And=6'b010001;
    parameter ori=6'b001101;
    //parameter Or=6'b010011;
    //parameter sll=6'b011000;
    parameter slti=6'b001010;
    parameter sw=6'b101011;
    parameter lw=6'b100011;
    parameter j=6'b000010;
    parameter halt=6'b111111;
    parameter beq=6'b000100;
    parameter bne=6'b000101;
    parameter blez=6'b000110;
    
    assign PC_Wre= OP!=halt;
    assign ALUsrcA= OP==R && func==sll;
    assign ALUsrcB= OP==addiu||OP==andi||OP==ori||OP==slti||OP==sw||OP==lw;
    assign Data_Src= OP==lw;
    assign Reg_Wre= (OP!=sw && OP!=beq && OP!=j && OP !=bne && OP!=blez)?1:0;
    assign Ins_Mem_RD=1;
    assign Mem_RD= OP==lw;
    assign Mem_Wre= OP==sw;
    //assign Reg_Dst= OP==add || OP==sub|| OP==And || OP==Or || OP==sll;
    assign Reg_Dst=OP==R;
    assign ExtOP= OP!=andi && OP!=ori;
//    assign ALUOP= OP==sub || OP==beq || OP==bne || OP==bltz ?3'b001
//                    : OP==add || OP==addiu || OP==sw || OP==lw ?3'b000
//                    : OP == andi||OP==And?3'b100
//                    :OP==ori||OP==Or?3'b011
//                    :OP==sll?3'b010
//                    :OP==slti?3'b110
//                    :3'b000;
    assign ALUOP= (OP==R&&func==sub) || OP==beq || OP==bne || OP==blez ?3'b001
                    : (OP==R&&func==add) || OP==addiu || OP==sw || OP==lw ?3'b000
                    : OP == andi||(OP==R&&func==And)?3'b100
                    :OP==ori||(OP==R&&func==Or)?3'b011
                    :(OP==R&&func==sll)?3'b010
                    :OP==slti?3'b110
                    :3'b000;
    assign PC_Src= OP==j?2'b10
                    :OP==beq?Zero?2'b01:2'b00
                    :OP==bne?Zero?2'b00:2'b01
                    :OP==blez?Sign||Zero?2'b01:2'b00
                    :2'b00;
endmodule
