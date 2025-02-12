`timescale 1ns / 1ps
module PC(
    input CLK,
    input Reset,
    input W_EN,
    input [31:0]nextaddress,
    output reg [31:0]PC
    );
    initial begin
        PC=0;
    end
    always@(posedge CLK or posedge Reset) begin
        if (Reset) PC<=0;
            else if (W_EN)
                    PC<=nextaddress;    
    end
endmodule