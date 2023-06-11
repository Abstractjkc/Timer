`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/07 10:59:56
// Design Name: 
// Module Name: binary_bcd
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module binary_bcd(
        input [9:0] bcd_in,
        output [15:0] bcd_out
    );
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg [3:0] d;
    integer i;
    always @(*) begin
        a = 4'd0;
        b = 4'd0;
        c = 4'd0;
        d = 4'd0;
        for (i = 9; i >= 0; i = i - 1) begin
            if (a >= 4'd5) a = a + 4'd3;
            if (b >= 4'd5) b = b + 4'd3;
            if (c >= 4'd5) c = c + 4'd3;
            if (d >= 4'd5) d = d + 4'd3;
            d = {d[2:0], c[3]};
            c = {c[2:0], b[3]};
            b = {b[2:0], a[3]};
            a = {a[2:0], bcd_in[i]};
        end
    end
    assign bcd_out = {d, c, b, a};
endmodule
