`timescale 1ns / 1ps
module frequency_divider(
    input CLK,
    output reg[3:0]AN
    );
    parameter T1MS=	100000;
    reg [21:0] counter;
    initial begin
        counter<=    0;
        AN<=    4'b0111;
    end
    always@(posedge CLK) begin
        counter<=counter+1;
        if (counter==T1MS) begin
            counter<=0;
            case (AN)
                4'b0111: AN<=4'b1110;
                4'b1110: AN<=4'b1101;
                4'b1101: AN<=4'b1011;
                4'b1011: AN<=4'b0111;
                4'b0000: AN<=4'b0111;
            endcase
        end
    end
endmodule
