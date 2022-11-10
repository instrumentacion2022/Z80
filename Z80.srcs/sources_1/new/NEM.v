`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.11.2022 20:57:08
// Design Name: 
// Module Name: NEM
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


module NEM();
    
    //-----------------------------------------Operaciones 8 bits-----------------------------------------//
    parameter ADD = 5'b00000;
    parameter ADC = 5'b00001;
    parameter SUB = 5'b00010;
    parameter SBC = 5'b00011;
    parameter AND = 5'b00100;
    parameter XOR = 5'b00101; 
    parameter OR =  5'b00110;
    parameter CP =  5'b00111;
    parameter INC = 5'b01000;
    parameter DCR = 5'b01001;
    parameter RLC = 5'b01010;       //Rotación izquierda con acarreo
    parameter RRC = 5'b01011;       //Rotación derecha con acarreo
    parameter RL =  5'b01100;       //Rotación izquierda       
    parameter RR =  5'b01101;       //Rotación derecha
    parameter SLA = 5'b01110;
    parameter SRA = 5'b01111;
    parameter SRL = 5'b10000;
    parameter BIT = 5'b10001;
    parameter SET = 5'b10010;
    parameter RES = 5'b10011;
   
    //-----------------------------------------Operaciones 16 bits-----------------------------------------//
    parameter ADD_16b = 0;
    parameter INC_16b = 0;
    parameter DEC_16b = 0;

endmodule
