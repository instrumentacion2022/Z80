`timescale 1ns / 1ps
//ALU DE 8 bits para Z80

module ALU(
    input [7:0] A, B,F_in,
    input [3:0] Sel,
    output [7:0] ALU_out, F_out
    );
    
    reg[7:0] Result;
    reg[7:0] Flags;
    
    //-----------------------------------------Operaciones-----------------------------------------//
    parameter ADD = 4'b0000;
    parameter SBST = 4'b0001;
    parameter AND = 4'b0010;
    parameter OR = 4'b0011;
    parameter XOR = 4'b0100;
    parameter CMP = 4'b0101;
    parameter LSHF = 4'b0110;
    parameter RSHF = 4'b0111;
    parameter INC = 4'b1000;
    parameter DCR = 4'b1001;
    parameter ROT = 4'b1010;
    parameter RST = 4'b1011;
     //-----------------------------------------Banderas-----------------------------------------//
   //Banderas 3 y 5 no se ocupan
    parameter C = 1;    //Carry
    parameter N = 1;     //Add/Substract
    parameter P_V = 1;    //Parity/Overflow
    parameter H = 1;      //Half Carry
    parameter Z = 1;      //Zero
    parameter S = 1;      //Sign
     
   
   assign ALU_out = Result;
   assign F_out = Flags;
    
    always @(*)
    begin
        Flags = 8'h00;
        case(Sel)
        ADD:        //SUMA
        Result = A+B;
        SBST:        //RESTA
        Result = A-B;
        AND:       //AND
        Result = A & B;
        OR:       //OR
        Result = A | B;
        XOR:       //XOR
        Result = A ^ B;
        CMP:        //Comparador mayor
        Result = (A>=B) ? A:B;
        LSHF:        // Corrimiento izquierda
        Result = A<<1;
        RSHF:        //Corrimiento derecha
        Result = A>>1;
        INC:        //Incremento
        Result = A+1;
        DCR:        //Decremento
        Result = A-1;
        ROT:        //Girar
        Result ={A[6:0],A[7]};
        RST:        //Reset
        Result =8'h00;
        //
        default: Result = 8'h00;
        endcase
        
//---------------------------------Banderas--------------------//
         
        case(Sel)   //SUMA
        ADD:
        Flags[0] =(A+B>255)? C :0;//Acarreo   
        SBST:      
        Flags[0] =(B>A)? C :0;         //Resta
        default:
        Flags=8'h00;
        endcase
   
end
endmodule

