//initial goal 4/13/2022
//send pulse to speaker 

module FPGAaudio(CLOCK_50,GPIO,KEY); //currently sends a pulse to speaker 

input [1:0]KEY;
input CLOCK_50; 
output [35:0]GPIO; 

reg [32:0] counter; 
reg state; 

assign GPIO[0] = state;  

always @ (posedge CLOCK_50) 
begin 

if(KEY[0])begin //control the pulse with the button on board 
counter <= counter + 1; 
state <= counter[25]; //change state when we change the 26th bit
end 

end 



endmodule 