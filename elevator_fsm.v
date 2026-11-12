`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.06.2026 23:32:13
// Design Name: 
// Module Name: elevator_fsm
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


module elevator(clk, rst, count, weight, f_req, bell, floor, direction);
input clk,rst;
input count; //count of people inside lift from ir sensor
input weight; //weight of people inside lift from weight sensor
input [1:0] f_req; //requested floor number 
output reg bell; //this bell rings when count or weight of people is above limit
output reg [1:0] floor,direction; //shows the current floor number and direction of movement

reg [2:0] current,next;

//naming each state
parameter a_0 = 3'd0; //at floor 0
parameter pos_0 = 3'd1; //going from 0 to 1
parameter neg_1 = 3'd2; //going from 1 to 0
parameter a_1 = 3'd3; //at floor 1
parameter pos_1 = 3'd4; //going from 1 to 2
parameter neg_2 = 3'd5; //going from 2 to 1
parameter a_2 = 3'd6; //at floor 2

//naming floor and direction
parameter floor0 = 2'd0;
parameter floor1 = 2'd1;
parameter floor2 = 2'd2;
parameter down = 2'd0;
parameter up = 2'd1;
parameter nil = 2'd2;

//curent state logic
always@(posedge clk or posedge rst)begin
if(rst) current<=a_0;
else current<=next;
end

//next state logic
always@(*)begin
case (current)

a_0:begin
if ((f_req==2'd1) || (f_req==2'd2))
next=pos_0;
else
next=a_0;
end 

pos_0:begin
if(f_req==2'd2)
next=pos_1;
else
next=a_1;
end

a_1:begin
if (f_req==2'd0)
next=neg_1;
else if (f_req==2'd2)
next=pos_1;
else
next=a_1;
end

neg_1:begin
next=a_0;
end

pos_1:begin
next=a_2;
end

a_2:begin
if((f_req==2'd1)||(f_req==2'd0))
next=neg_2;
else
next=a_2;
end

neg_2:begin
if(f_req==2'd0)
next=neg_1;
else
next=a_1;
end

default: next=a_0;

endcase
end

//output logic
always@(*)begin

floor = floor0;
direction = nil;

//warning bell 
if((count==1'b1)||(weight==1'b1))
bell=1'b1;
else
bell=1'b0;

//floor and direction
case(current)

a_0:begin
floor=floor0;
direction=nil;
end

pos_0:begin
floor=floor0;
direction=up;
end

a_1:begin
floor=floor1;
direction=nil;
end

neg_1:begin
floor=floor1;
direction=down;
end

pos_1:begin
floor=floor1;
direction=up;
end

a_2:begin
floor=floor2;
direction=nil;
end

neg_2:begin
floor=floor2;
direction=down;
end

default:begin 
floor=floor0;
direction=nil;
end

endcase

end

endmodule
