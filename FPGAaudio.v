
module FPGAaudio(CLOCK_50,KEY,GPIO);

input CLOCK_50; 
input [0:3]KEY; //input for the keys 
output [0:3]GPIO; //output to speaker 

wire clkOut; //output from divider 

Clock_divider clkDiv(CLOCK_50,clkOut);

reg [15:0] counterA;
always @(posedge clkOut) if(counterA==56817) counterA <= 0; else counterA <= counterA+1;

reg [15:0] counterC;
always @(posedge clkOut) if(counterC==95419) counterC <= 0; else counterC <= counterC+1;  

reg [15:0] counterF;
always @(posedge clkOut) if(counterF==71633) counterF <= 0; else counterF <= counterF+1; 

reg [15:0] counterG;
always @(posedge clkOut) if(counterG==63775) counterG <= 0; else counterG <= counterG+1;  

assign GPIO[0] = ~KEY[0] &&  counterA[15] ||~KEY[1] &&  counterC[15]||~KEY[2] &&  counterF[15]||~KEY[3] &&  counterG[15]; //this allows control of the note 

//assign GPIO[1] = ~KEY[1] &&  counterC[15];

//assign GPIO[2] = ~KEY[2] &&  counterF[15];

//assign GPIO[3] = ~KEY[3] &&  counterG[15];



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




//this is used to set output high for desired note 
//out 1 = A
//out 2 = B
//out 3 = C
module noteDecoder(A0,A1,out0,out1,out2,out3); 

input A0,A1; 
output out0,out1,out2,out3; 

and(out0,~A0,~A1);
and(out1,A0,~A1); 
and(out2,~A0,A1);
and(out3,A0,A1);


endmodule 


//PoliceSirenModule
module PoliceSiren(CLOCK_50, GPIO);
input CLOCK_50;
output [0:1]GPIO; //speaker out 

Clock_divider clkDiv(CLOCK_50,clkOut);

reg [27:0] tone;
always @(posedge clkOut) tone <= tone+1;

//fast sweep is a square wave with smaller duty cycles

//slow sweep is a square wave with larger duty cycles 

wire [6:0] fastsweep = (tone[22] ? tone[21:15] : ~tone[21:15]);
wire [6:0] slowsweep = (tone[25] ? tone[24:18] : ~tone[24:18]);

//after we create either wave, we toggle between tones using comparator statement 

wire [14:0] clkdivider = {2'b01, (tone[27] ? slowsweep : fastsweep), 6'b000000};

reg [14:0] counter;
always @(posedge clkOut) if(counter==0) counter <= clkdivider; else counter <= counter-1;

reg speaker;
always @(posedge clkOut) if(counter==0) speaker <= ~speaker;

assign GPIO[0] = speaker; 

endmodule





//division module 
module divide_by12(numer, quotient, remain);
input [5:0] numer;
output [2:0] quotient;
output [3:0] remain;

reg [2:0] quotient;
reg [3:0] remain_bit3_bit2;

// the first 2 bits are copied through
// effectively dividing by 4

assign remain = {remain_bit3_bit2, numer[1:0]}; 

always @(numer[5:2]) // and just do a divide by "3" on the remaining bits
case(numer[5:2])
   0: begin quotient=0; remain_bit3_bit2=0; end
   1: begin quotient=0; remain_bit3_bit2=1; end
   2: begin quotient=0; remain_bit3_bit2=2; end
   3: begin quotient=1; remain_bit3_bit2=0; end
   4: begin quotient=1; remain_bit3_bit2=1; end
   5: begin quotient=1; remain_bit3_bit2=2; end
   6: begin quotient=2; remain_bit3_bit2=0; end
   7: begin quotient=2; remain_bit3_bit2=1; end
   8: begin quotient=2; remain_bit3_bit2=2; end
   9: begin quotient=3; remain_bit3_bit2=0; end
 10: begin quotient=3; remain_bit3_bit2=1; end
 11: begin quotient=3; remain_bit3_bit2=2; end
 12: begin quotient=4; remain_bit3_bit2=0; end
 13: begin quotient=4; remain_bit3_bit2=1; end
 14: begin quotient=4; remain_bit3_bit2=2; end
 15: begin quotient=5; remain_bit3_bit2=0; end
endcase
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
