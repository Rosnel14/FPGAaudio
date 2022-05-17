//selector module done!! 4/26/22
module FPGAaudio(CLOCK_50,KEY,GPIO);

input CLOCK_50; 
input [0:3]KEY; //input for the keys 
output [0:1]GPIO; //output to speaker 

wire clkOut; //output from divider 


Clock_divider clkDiv(CLOCK_50,clkOut);

reg [15:0] counterC;
always @(posedge clkOut) if(counterC==47782) counterC <= 0; else counterC <= counterC+1; //C

reg [15:0] counterD;
always @(posedge clkOut) if(counterD==42567) counterD <= 0; else counterD <= counterD+1; //D

reg [15:0] counterE;
always @(posedge clkOut) if(counterE==37922) counterE <= 0; else counterE <= counterE+1; //E

reg [15:0] counterG;
always @(posedge clkOut) if(counterG==35793) counterG <= 0; else counterG <= counterG+1;  //G

 

//output statement 
assign GPIO[0] =  ~KEY[0] &&  counterC[15] ||~KEY[1] &&  counterD[15]||~KEY[2] &&  counterE[15]||~KEY[3] &&  counterG[15]; //this allows control of the note 




endmodule 



//just testing A note
module Anote(CLOCK_50,KEY,GPIO,); 

input CLOCK_50;
input [0:1]KEY;  
output [0:1]GPIO; 

wire clkOut; //output from divider 

Clock_divider clkDiv(CLOCK_50,clkOut);

reg [15:0] counter;
always @(posedge clkOut) if(counter==56817) counter <= 0; else counter <= counter+1;

assign GPIO[0] = ~KEY[0] &&  counter[15]; //this allows control of the note 
endmodule 





//frequency divider (50 > 25mhz)
module Clock_divider(clock_in,clock_out);

input clock_in; // input clock on FPGA
output reg clock_out; // output clock after dividing the input clock by divisor
reg[27:0] counter=28'd0;
parameter DIVISOR = 28'd2; //division factor (2) 

 
// The frequency of the output clk_out
//  = The frequency of the input clk_in divided by DIVISOR
// For example: Fclk_in = 50Mhz, if you want to get 1Hz signal to blink LEDs
// You will modify the DIVISOR parameter value to 28'd50.000.000
// Then the frequency of the output clk_out = 50Mhz/50.000.000 = 1Hz
always @(posedge clock_in)
begin
 counter <= counter + 28'd1;
 if(counter>=(DIVISOR-1))
  counter <= 28'd0;
 clock_out <= (counter<DIVISOR/2)?1'b1:1'b0;
end
endmodule
