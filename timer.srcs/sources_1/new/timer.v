`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/11 11:10:13
// Design Name: 
// Module Name: timer
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


module timer(
        input clk,
        input rst_n,
        input start_button,
        input pause_button,
        // input stop_button,
        output [6:0] O_led,
        output [3:0] O_dx,
        output O_minute_show,
        output over_limit 
    );
    reg X;
    wire start, pause;
    key_rebounce start_key_rebounce(.I_clk(clk), .I_rst_n(rst_n), .I_key_in(start_button), .O_key_out(start));
    key_rebounce pause_key_rebounce(.I_clk(clk), .I_rst_n(rst_n), .I_key_in(pause_button), .O_key_out(pause));
    // key_rebounce stop_key_rebounce(.I_clk(clk), .I_rst_n(rst_n), .I_key_in(stop_button), .O_key_out(stop));
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            X <= 0; 
            
        end
        else if (start == 1) begin
            X <= 1;
        end
        else if (pause == 1) begin
            X <= 0;
        end
        else begin
            X <= X;
        end
    end
    wire [9:0] minute;
    wire [9:0] second;
    wire [9:0] mills;
    time_adder U_time_adder(.clk(clk), .rst_n(rst_n), .X(X), .minute(minute), .second(second), .mills(mills), .over_limit(over_limit));
    // wire bcd_minute;
    wire [15:0] bcd_second;
    wire [15:0] bcd_mills;
    wire [15:0] show_num;
    // binary_bcd minute_binary_bcd(.bcd_in(minute), .bcd_out(bcd_minute));
    binary_bcd second_binary_bcd(.bcd_in(second), .bcd_out(bcd_second));
    binary_bcd mills_binary_bcd(.bcd_in(mills), .bcd_out(bcd_mills));
    assign show_num = {bcd_second[7:0], bcd_mills[11:4]};
    assign O_minute_show = {minute[0]};
    light_show U_light_show(.I_clk(clk), .I_rst_n(rst_n), .I_show_num(show_num), .O_led(O_led), .O_dx(O_dx));
endmodule
