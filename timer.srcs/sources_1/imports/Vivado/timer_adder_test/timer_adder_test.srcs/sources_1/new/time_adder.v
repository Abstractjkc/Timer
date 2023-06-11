`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/09 21:12:42
// Design Name: 
// Module Name: time_adder
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


module time_adder(
        input clk,
        input rst_n,
        input X,    // 现在是否计时 1 计时，0 未计时
        output reg [9:0] minute,
        output reg [9:0] second,
        output reg [9:0] mills,
        output over_limit
    );
    parameter A = 2'b00, B = 2'b01, C = 2'b11, D = 2'b10;
    reg [1:0] state, next_state;
    reg OL;
    reg [31:0] count;
    // parameter COUNT = 2;
    parameter COUNT = 10000;


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            minute <= 0;
            second <= 0;
            mills <= 0;
            OL <= 0;
            state <= A;
            count <= 0; 
        end
        else begin
            state <= next_state;
        end
    end
    always @(X or OL or state) begin
        case (state) 
            A : begin
                next_state = X ? B : A;
            end
            B : begin
                next_state = OL ? D : X ? B : C;
            end
            C : begin
                next_state = X ? B : C;
            end
            D : begin
                next_state = D;
            end
        endcase
    end
    always @(posedge clk) begin
        case (state) 
            B : begin
                if (count >= COUNT) begin
                    if (mills == 999) begin
                        if (second == 59) begin
                            if (minute == 1) begin
                                OL = 1;
                            end
                            else begin
                                second = 0;
                                minute = minute + 1;
                            end
                        end 
                        else begin
                            second = second + 1;
                        end
                    end
                    else begin
                        mills = mills + 1;
                    end
                    count = 0;
                end
                else begin
                    count = count + 1;
                end
            end
            A : begin
                minute = 0;
                second = 0;
                mills = 0;
                count = 0;
                OL = 0;
            end
            C : begin
                count = 0;
                OL = 0;
            end
            D : begin
                count = 0;
                OL = 0;
            end
        endcase
    end
    assign over_limit = state == D;
endmodule
