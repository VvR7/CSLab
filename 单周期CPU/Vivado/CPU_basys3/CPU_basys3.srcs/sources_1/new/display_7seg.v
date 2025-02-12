`timescale 1ns / 1ps
module display_7seg(
    input [3:0] data,
    output reg[7:0] display
    );
    always@(data) begin
        case (data)
        4'b0000 : display = 8'b1100_0000;  //0£ª'0'-¡¡µ∆£¨'1'-œ®µ∆
        4'b0001 : display = 8'b1111_1001;  //1
        4'b0010 : display = 8'b1010_0100;  //2
        4'b0011 : display = 8'b1011_0000;  //3
        4'b0100 : display = 8'b1001_1001;  //4
        4'b0101 : display = 8'b1001_0010;   //5
        4'b0110 : display = 8'b1000_0010;  //6 
        4'b0111 : display = 8'b1101_1000;  //7
        4'b1000 : display = 8'b1000_0000;  //8
        4'b1001 : display = 8'b1001_0000;  //9
        4'b1010 : display = 8'b1000_1000;  //A
        4'b1011 : display = 8'b1000_0011;  //b
        4'b1100 : display = 8'b1100_0110;  //C
        4'b1101 : display = 8'b1010_0001;  //d
        4'b1110 : display = 8'b1000_0110;  //E
        4'b1111 : display = 8'b1000_1110; //F
        default : display = 8'b0000_0000;  //≤ª¡¡
        endcase
    end
endmodule
