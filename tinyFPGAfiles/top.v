// look in pins.pcf for all the pin names on the TinyFPGA BX board
//FPGAaudio module
// recall that buttons work on the negedge

module top(CLK,PIN_13,PIN_12,PIN_11,PIN_10,PIN_22);

input CLK;
input PIN_13,PIN_12,PIN_11,PIN_10; //input buttons
output PIN_22; //speaker output

//if statement constants different for 16mhz clock
reg [15:0] counterC;
always @(posedge CLK) if(counterC==61157) counterC <= 0; else counterC <= counterC+1; //C

reg [15:0] counterD;
always @(posedge CLK) if(counterD==54484) counterD <= 0; else counterD <= counterD+1; //D

reg [15:0] counterE;
always @(posedge CLK) if(counterE==48540) counterE <= 0; else counterE <= counterE+1; //E

reg [15:0] counterG;
always @(posedge CLK) if(counterG==91632) counterG <= 0; else counterG <= counterG+1;  //F

//mux statement
//m41 noteout(PIN_22,counterC,counterD,counterE,counterG,~PIN_13,~PIN_12);

//output statement
//xor(PIN_22, (PIN_13 && counterD),(PIN_12&& counterC)) ; //this allows control of the note

assign PIN_22 = (PIN_13 && counterC[15]) || (PIN_12 && counterD[15]) || (PIN_11 && counterE[15]) || (PIN_10 && counterG[15]);



endmodule
