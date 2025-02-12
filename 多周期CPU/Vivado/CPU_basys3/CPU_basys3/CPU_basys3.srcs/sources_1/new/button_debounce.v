`timescale 1ns / 1ps
module button_debounce(
    input CLK,
    input button,
    output out
    );
    parameter MAX=5000;
    reg [15:0] count_low;
    reg [15:0] count_high;
    reg count_out;
    always@(posedge CLK) begin
        count_low<= button?0:count_low+1;
        count_high<= button?count_high+1:0;
        if (count_low==MAX) count_out<=0;
        else if (count_high==MAX) count_out<=1;
    end
    assign out=!count_out;
endmodule
