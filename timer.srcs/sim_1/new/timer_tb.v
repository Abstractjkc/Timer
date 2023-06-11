`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/11 11:33:12
// Design Name: 
// Module Name: timer_tb
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


module timer_tb(

    );
    reg clk;
    reg rst_n;
    reg start_button, pause_button;
    wire [6:0] O_led;
    wire [3:0] O_dx;
    wire O_minute_show;
    wire over_limit;
    parameter PERIOD = 6;
    initial begin
        rst_n = 1;
        start_button = 0;
        pause_button = 0;
        #(PERIOD);
        rst_n = 0;
        #(PERIOD);
        rst_n = 1;
        start_button = 1;
        #(PERIOD * 100);
    end
    always begin
        clk = 1;
        #(PERIOD / 2);
        clk = 0;
        #(PERIOD / 2);
    end
    timer U_timer(.clk(clk), .rst_n(rst_n), .start_button(start_button), .pause_button(pause_button), .O_led(O_led), .O_dx(O_dx), .O_minute_show(O_minute_show), .over_limit(over_limit));
endmodule
