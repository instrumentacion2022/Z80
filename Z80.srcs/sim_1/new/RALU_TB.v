`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.11.2022 20:34:34
// Design Name: 
// Module Name: RALU_TB
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


module RALU_TB(

    );
reg [7:0] DATA_IN;
reg CLK, LD_B, LD_AO,LD_AI,SEL_AI,SEL_AO,RST_A;
reg LD_FO,LD_FI,SEL_FI,SEL_FO,RST_F;
reg [4:0] SEL;
wire [7:0] DO_A,DO_F;
    
 REGALU TESTRALU (DATA_IN,CLK,LD_B,LD_AO,LD_AI,SEL_AI,SEL_AO,RST_A,LD_FO,LD_FI,SEL_FI,SEL_FO,RST_F,SEL,DO_A,DO_F);
 initial begin
 //no cambian
 CLK = 0;
 SEL = 5'b00000;
 RST_A=1;
 RST_F =1;
LD_AO = 1;
LD_FO=1;
SEL_FI = 0;
SEL_FO = 1;
LD_FI=1;
 //////


//Cargar Dato a A
DATA_IN = 8'hFF;
SEL_AI=1;
LD_AI = 1;
LD_B = 0;
SEL_AO = 0;


 #20;
 //Guardas valor en A
DATA_IN = 8'hFF;
SEL_AI=1;
LD_AI = 0;
LD_B = 0;
SEL_AO = 0;
 #20;
 
//Cargar dato a B
DATA_IN = 8'h01;
SEL_AI=0;
LD_AI = 0;
LD_B = 1;
SEL_AO = 0;

//Guardas resultado en A y envias a la salida
#20;
DATA_IN = 8'h01;
SEL_AI=0;
LD_AI = 1;
LD_B = 1;
SEL_AO = 1;
#20;


 end
 
 
always begin
    CLK = ~CLK;
    #10; 
end 
endmodule
