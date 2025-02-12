`timescale 1ns / 1ps
module basys3(
    input CLK,
    input [2:0]SW,
    input Reset,
    input button,
    output [3:0]AN,
    output [7:0]display
    );
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
    //五个临时寄存器里的值:
    wire [31:0]Daout;
    wire [31:0]Dbout;
    wire [31:0]ALUDout;
    wire [31:0] DBSrc;
    wire [31:0]Dinstruction;
    //状态
    wire [2:0]state  ;
    wire myCLK;
    reg [3:0]data;
    button_debounce mybutton(CLK,button,myCLK);
    CPU mycpu(myCLK,Reset,PC,newaddress,Instruction,ALUA,ALUB,ALU_OUT,W_data,W_reg,R_data1,R_data2,Ext_imm,Daout,Dbout,ALUDout,DBSrc,Dinstruction,state);
    display_7seg myseg(data,display);
    frequency_divider my(CLK,AN);
    always@(myCLK)begin
           case(AN)
                4'b1110:    begin
                    case(SW)
                        3'b000:data<=newaddress[3:0];
                        3'b010:data<=Daout[3:0];
                        3'b100:data<=Dbout[3:0];
                        3'b110:data<=W_data[3:0];
                        default: data<={3'b000,state[0]};
                    endcase
                end
                4'b1101:    begin
                    case(SW)
                        3'b000:data<=newaddress[7:4];
                        3'b010:data<=Daout[7:4];
                        3'b100:data<=Dbout[7:4];
                        3'b110:data<=W_data[7:4];
                        default: data<={3'b000,state[1]};
                    endcase
                end
                4'b1011:    begin
                    case(SW)
                        3'b000:data<=PC[3:0];
                        3'b010:data<=Instruction[24:21];
                        3'b100:data<=Instruction[19:16];
                        3'b110:data<=ALUDout[3:0];
                        default: data<={3'b000,state[2]};
                    endcase
                end
                4'b0111 : begin
                    case(SW)
                        3'b000:data<=PC[7:4];
                        3'b010:data<={3'b000,Instruction[25]};
                        3'b100:data<={3'b000,Instruction[20]};
                        3'b110:data<=ALUDout[7:4];
                        default:data<=4'b0000;
                    endcase
                end
            endcase
    end
endmodule
