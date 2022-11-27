`timescale 1ns / 1ps
//ALU DE 8 bits para Z80


 module ALU(
    input [7:0] A, B,F_in,
    input [4:0] Sel,
    output [7:0] ALU_out, F_out
    
    );
    `include "NEM.vh"
    reg[7:0] Result;
    reg C,P_V,Z,S;
    //reg N,H;    
  
   assign ALU_out = Result;
   //Asignación de banderas 3 y 5 no se usan!
   //N y H eran banderas internas de la ALU de 4 bits,se eliminan
   assign F_out[0] = C | F_in[0];         //Carry 0
   assign F_out[1] =0 | F_in[1];       //Suma resta  -  No implementado
   assign F_out[2] =P_V | F_in[2];       //Paridad o desbordamiento
   assign F_out[3] =0 | F_in[3];         // NO utilizada
   assign F_out[4] = 0 | F_in[4];       //Medio acarreo - No implementado
   assign F_out[5] =0 | F_in[5];       //NO utilizada
   assign F_out[6] = Z | F_in[6];         //Cero
   assign F_out[7] = S | F_in[7];         //Signo 
 
//    assign F_out[0] = C;         //Carry 0
//   assign F_out[1] = 0;       //Suma resta  -  No implementado
//   assign F_out[2] = P_V;       //Paridad o desbordamiento
//   assign F_out[3] = 0 ;         // NO utilizada
//   assign F_out[4] = 0 ;       //Medio acarreo - No implementado
//   assign F_out[5] = 0 ;       //NO utilizada
//   assign F_out[6] = Z ;         //Cero
//   assign F_out[7] = S ;         //Signo       

    always @(*)
    begin
        case(Sel)
        ADD:                     //SUMA 
        Result = A+B;
        ADC:
        Result = A+B+ C;          //SUMA con acarreo
        SUB:        //RESTA
        Result = A-B;
        SBC:
        Result = A-B-C;           //RESTA con acarreo
        AND:       //AND
        Result = A & B;
        OR:       //OR
        Result = A | B;
        XOR:       //XOR
        Result = A ^ B;
        CP:        //Comparador igual
        Result = A;       //El comparador no afecta el acumulador, sólo afecta la bandera
        INC:        //Incremento
        Result = A+1;
        DCR:        //Decremento
        Result = A-1;
        RLC:        //Rotación izquierda
        Result = {A[6:0],A[7]};
        RRC:        //Rotacion derecha
        Result = {A[0],A[7:1]};
        RL:        //Rotación izquierda
        Result = {A[6:0],C};
        RR:        //Rotacion derecha
        Result = {C,A[7:1]};
        SLA:        //Corrimiento a la izquierda
        Result = A<<1;
        SRL:
        Result = A>>1;
        SRA:
        Result = {A[7],A[7:1]};
        //
        default: Result = 8'h00;
        endcase
        
//---------------------------------Banderas--------------------//
        //S no cambian
        S = Result[7];
        case(Sel)   
        ADD:
        begin
        C = (A+B>255)?1:0;
        //P_V = (Result>127)?1:0; //overflow
        P_V = (A+B>127)?1:0; 
        Z = (Result==0)?1:0;
        end
        ADC:
        begin
        C = (A+B>255)?1:0;
        P_V = (A+B>127)?1:0; //overflow
        Z = (Result==0)?1:0;
        end  
        SUB:
        begin
        C = (B>A)?1:0;
        P_V = (B>A)?(B-A>128?1:0):(A-B>127?1:0); //overflow 
        Z = (Result==0)?1:0;
        end
        SBC:
        begin
        C = (B>A)?1:0;
        P_V = (B>A)?(B-A>128?1:0):(A-B>127?1:0);        //Overflow
        Z = (Result==0)?1:0;
        end 
        AND:
        begin
        C = 0;              //Reset para AND
        P_V = (Result>127)?1:0; //overflow 
        Z = (Result==0)?1:0;
        end
        OR:
        begin
        C = 0;              //Reset para OR
        P_V = (Result>127)?1:0; //overflow 
        Z = (Result==0)?1:0;
        end
        XOR:
        begin
        C = 0;              //Reset para XOR
        P_V = ~^Result; //Set si el resultado es par
        Z = (Result==0)?1:0;
        end
        CP:     //Se puede ver como una resta que no afecta el valor del acumulador 
        begin
        C = (B>A)?1:0;
        P_V = (B>A)?(B-A>128?1:0):(A-B>127?1:0); //overflow 
        Z = (A-B==0)?1:0; //Se activa si A es igual a B
        end
        INC:
        begin
//        C no se afecta
        P_V = (A+1>127)?1:0; //overflow 
        Z = (Result==0)?1:0;
        end
        DCR:
        begin
        //C no se afecta
        P_V = (Result>127)?1:0; //overflow  
        Z = (Result==0)?1:0;
        end
        RLC:
        begin
        C = A[7];   // bit 7 pasa al carry
        //N = 0;              //Reset siempre
        P_V = ~^Result; //PAR  
        //H = 0;              //Reset siempre
        Z = (Result==0)?1:0;
        end
        RRC:
        begin
        C = A[0];   // bit 0 pasa al carry
        //N = 0;              //Reset siempre
        P_V = ~^Result; //PAR  
        //H = 0;              //Reset siempre
        Z = (Result==0)?1:0;
        end
        RL:
        begin
        C = A[7];   // bit 7 pasa al carry
        //N = 0;              //Reset siempre
        P_V = ~^Result; //PAR  
        //H = 0;              //Reset siempre
        Z = (Result==0)?1:0;
        end
        RR:
        begin
        C = A[0];   // bit 0 pasa al carry
        //N = 0;              //Reset siempre
        P_V = ~^Result; //PAR  
        //H = 0;              //Reset siempre
        Z = (Result==0)?1:0;
        end
        SLA:
        begin
        C = A[7];   // bit 7 pasa al carry
        //N = 0;              //Reset siempre
        P_V = ~^Result; //PAR  
        //H = 0;              //Reset siempre
        Z = (Result==0)?1:0;
        end
        SRL:
        begin
        C = A[0];   // bit 0 pasa al carry
        //N = 0;              //Reset siempre
        P_V = ~^Result; //PAR  
        //H = 0;              //Reset siempre
        Z = (Result==0)?1:0;
        end
        SRA:
        begin
        C = A[0];   // bit 0 pasa al carry
        //N = 0;              //Reset siempre
        P_V = ~^Result; //PAR  
        //H = 0;              //Reset siempre
        Z = (Result==0)?1:0;
        end  
                    
        default:
        Z = 0;
        endcase

   
end
endmodule

