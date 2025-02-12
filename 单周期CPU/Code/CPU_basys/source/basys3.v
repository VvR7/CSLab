`timescale 1ns / 1ps
module basys3(
    input CLK,
    input [1:0]SW,
    input Reset,
    input button,
    output [3:0]AN,
    output [7:0]display
    );
    wire [31:0]PC;
    wire [31:0]newaddress;
    wire [31:0]Instruction;
    wire [31:0]Reg_S;
    wire [31:0]Reg_T;
    wire [31:0]ALUOUT;
    wire [31:0]W_data;
    wire myCLK;
    reg [3:0]data;
    button_debounce mybutton(CLK,button,myCLK);
    CPU mycpu(myCLK,Reset,PC,newaddress,Instruction,Reg_S,Reg_T,ALUOUT,W_data);
    display_7seg myseg(data,display);
    frequency_divider my(CLK,AN);
    always@(myCLK)begin
           case(AN)
                4'b1110:    begin
                    case(SW)
                        2'b00:data<=newaddress[3:0];
                        2'b01:data<=Reg_S[3:0];
                        2'b10:data<=Reg_T[3:0];
                        2'b11:data<=W_data[3:0];
                    endcase
                end
                4'b1101:    begin
                    case(SW)
                        2'b00:data<=newaddress[7:4];
                        2'b01:data<=Reg_S[7:4];
                        2'b10:data<=Reg_T[7:4];
                        2'b11:data<=W_data[7:4];
                    endcase
                end
                4'b1011:    begin
                    case(SW)
                        2'b00:data<=PC[3:0];
                        2'b01:data<=Instruction[24:21];
                        2'b10:data<=Instruction[19:16];
                        2'b11:data<=ALUOUT[3:0];
                    endcase
                end
                4'b0111 : begin
                    case(SW)
                        2'b00:data<=PC[7:4];
                        2'b01:data<={3'b000,Instruction[25]};
                        2'b10:data<={3'b000,Instruction[20]};
                        2'b11:data<=ALUOUT[7:4];
                    endcase
                end
            endcase
    end
endmodule
