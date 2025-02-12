`timescale 1ns / 1ps
module ALU(
    input [31:0]A,
    input [31:0]B,
    input [2:0]ALUOP,
    output reg[31:0]ans,
    output Zero,
    output Sign
    );
    always@(*) begin
        case(ALUOP)
            3'b000: ans=A+B;
            3'b001: ans=A-B;
            3'b010: ans=B<<A;
            3'b011: ans=A|B;
            3'b100: ans=A&B;
            3'b101: ans=(A<B?1:0);
            3'b110: ans=(A[31]!=B[31]?(A[31]==1?1:0):A<B);
            3'b111: ans=A^B;
        endcase
    end
    assign Zero=(ans==0);
    assign Sign=ans[31];
endmodule