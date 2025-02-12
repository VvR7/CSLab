`timescale 1ns / 1ps
module Control(
        input Reset,
        input CLK,
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
        output [1:0]Reg_Dst,
        output ExtOP,
        output [2:0]ALUOP,
        output [1:0]PC_Src,
        output reg[2:0] state,
        output IR_Wre,
        output Wd
    );
    parameter R=6'b000000;
    
    parameter add=6'b100000;
    parameter sub=6'b100010;
    parameter And=6'b100100;
    parameter Or=6'b100101;
    parameter sll=6'b000000;
    parameter slt=6'b101010;
    parameter jr=6'b001000;

    parameter xori=6'b001110;
    parameter addiu=6'b001001;
    parameter andi=6'b001100;
    parameter ori=6'b001101;
    parameter slti=6'b001010;
    parameter sw=6'b101011;
    parameter lw=6'b100011;
    parameter j=6'b000010;
    parameter jal=6'b000011;
    parameter halt=6'b111111;
    parameter beq=6'b000100;
    parameter bne=6'b000101;
    parameter blez=6'b000110;
    parameter bltz=6'b000001;
    
    initial begin
        state<=3'b000;
    end
    //每个周期开始时根据当前状态与指令进行state的转化
    always@(posedge CLK) begin
        if (Reset==1) state<=3'b000;
        else begin
            case (state) 
                3'b000:state<=OP!=halt?3'b001:3'b000;
                3'b001: begin
                    state<= OP==beq || OP==bne || OP==bltz ? 3'b101:
                            OP==sw  || OP==lw ?3'b010:
                            OP==j || OP==jal || (OP==R&&func==jr) || OP==halt?3'b000:
                            3'b110;
                end
                3'b010:state<=3'b011;
                3'b011:state<=OP==lw? 3'b100: 3'b000;
                3'b100:state<=3'b000;
                3'b101:state<=3'b000;
                3'b110:state<=3'b111;
                3'b111:state<=3'b000;
            endcase
        end
    end
    //以下几个控制信号与state无关，与单周期CPU一致
    assign ALUsrcA= OP==R && func==sll;
    assign ALUsrcB= OP==addiu||OP==andi||OP==ori||OP==slti||OP==sw||OP==lw||OP==xori;
    assign Data_Src= OP==lw;
    assign ExtOP= OP!=andi && OP!=ori && OP!=xori;
    assign ALUOP= (OP==R&&(func==sub)) || OP==beq || OP==bne || OP==blez || OP==bltz?3'b001
            : (OP==R&&func==add) || OP==addiu || OP==sw || OP==lw ?3'b000
            : OP == andi||(OP==R&&func==And)?3'b100
            :OP==ori||(OP==R&&func==Or)?3'b011
            :(OP==R&&func==sll)?3'b010
            :OP==slti||(OP==R&&func==slt)?3'b110
            :OP==xori?3'b111
            :3'b000;
    assign PC_Src= OP==j||OP==jal?2'b11
                               :OP==R&&func==jr?2'b10
                               :OP==beq?Zero?2'b01:2'b00
                               :OP==bne?Zero?2'b00:2'b01
                               :OP==bltz?Sign?2'b01:2'b00
                               :2'b00;
    //PC_Wre在j、jal、jr、halt的ID，sw的MEM，分支指令的EXE，以及WB阶段有效，在下个时钟周期到来时写PC
    assign PC_Wre= (OP!=halt)&&(state==3'b001&&(OP==j||OP==jal||(OP==R&&func==jr))||state==3'b111||state==3'b101||state==3'b100||(state==3'b011&&OP==sw));
    //Reg_Wre:在jal指令的ID，以及WB阶段进行寄存器写
    assign Reg_Wre= (state==3'b001&&OP==jal)||(state==3'b111)||(state==3'b100);
    //只有在IF取指阶段读指令存储器
    assign Ins_Mem_RD= (state==3'b000);
    //只有在lw的MEM阶段读数据存储器
    assign Mem_RD= (OP==lw&&state==3'b011);
    //只有在sw的MEM阶段写数据存储器
    assign Mem_Wre= (OP==sw&&state==3'b011);
    //只有在IF阶段写指令寄存器，其他状态下指令寄存器不变以存储当前指令
    assign IR_Wre= state==3'b000;
    //目标寄存器来自rd,rt,$31
    assign Reg_Dst=OP==R?2'b01:
                   OP==jal?2'b10:
                   2'b00;
    
    //W_data的来源，PC+4(jal)还是DB总线
    assign Wd= OP==jal?1'b0:1'b1;
endmodule
