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
    reg N,H;    

  
   assign ALU_out = Result;
   //Asignación de banderas 3 y 5 no se usan!
   //N y H eran banderas internas de la ALU de 4 bits,se eliminan
   assign F_out[7] = C;         //Carry 0
   assign F_out[6] = N;       //Suma resta
   assign F_out[5] = P_V;       //Paridad o desbordamiento
   assign F_out[4] = 0;         // NO utilizada
   assign F_out[3] = H;       //Medio acarreo
   assign F_out[2] = 0;       //NO utilizada
   assign F_out[1] = Z;         //Cero
   assign F_out[0] = S;         //Signo 
       

    always @(*)
    begin
        case(Sel)
        ADD:                     //SUMA 
        Result = A+B;
        ADC:
        Result = A+B;          //SUMA con acarreo
        SUB:        //RESTA
        Result = A-B;
        SBC:
        Result = A-B;           //RESTA con acarreo
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
        Result = {A[6:0],A[7]};
        RR:        //Rotacion derecha
        Result = {A[0],A[7:1]};
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
         
        case(Sel)   
        ADD:
        begin
        C = (A+B>255)?1:0;
        //N = 0;              //Reset para Suma
        P_V = (A+B>127)?1:0; //overflow en complemento a 2
        //H = (A[3:0] + B[3:0] > 15)?1:0;
        Z = (Result==0)?1:0;
        S = Result[7];
        end
        ADC:
        begin
        C = (A+B>255)?1:0;
        //N = 0;              //Reset para Suma
        P_V = (A+B>127)?1:0; //overflow en complemento a 2
        //H = (A[3:0] + B[3:0] > 15)?1:0;
        Z = (Result==0)?1:0;
        S = Result[7];
        end  
        SUB:
        begin
        C = (A-B<0)?1:0;
       // N = 1;              //Set para resta
        P_V = (Result>127 | Result<-128)?1:0; //overflow en complemento a 2
        //H = (A[3:0] - B[3:0] < 0)?1:0;
        Z = (Result==0)?1:0;
        S = Result[7];
        end
        SBC:
        begin
        C = (A-B<0)?1:0;
       // N = 1;              //Set para resta
        P_V = (Result>127 | Result<-128)?1:0; //overflow en complemento a 2
       // H = (A[3:0] - B[3:0] < 0)?1:0;
        Z = (Result==0)?1:0;
        S = Result[7];
        end 
        AND:
        begin
        C = 0;              //Reset para AND
       // N = 0;              //Reset para AND
        P_V = (Result>127 | Result<-128)?1:0; //overflow en complemento a 2
       // H = 1;              //Set para AND
        Z = (Result==0)?1:0;
        S = Result[7];
        end
        OR:
        begin
        C = 0;              //Reset para OR
       // N = 0;              //Reset para OR
        P_V = (Result>127 | Result<-128)?1:0; //overflow en complemento a 2
       // H = 0;              //Set para OR
        Z = (Result==0)?1:0;
        S = Result[7];
        end
        XOR:
        begin
        C = 0;              //Reset para XOR
        //N = 0;              //Reset para XOR
        P_V = ~^Result; //Set si el resultado es par
        //H = 0;              //Set para XOR
        Z = (Result==0)?1:0;
        S = Result[7];
        end
        CP:
        begin
        C = (A-B<0)?1:0;
        //N = 1;              //Set para resta
        P_V = (Result>127 | Result<-128)?1:0; //overflow en complemento a 2
        //H = (A[3:0] - B[3:0] < 0)?1:0;              //Condición de resta
        Z = (Result==0)?1:0; //Se activa si A es igual a B
        S = Result[7];
        end
        INC:
        begin
//        C no se afecta
        //N = 0;              //Reset para Suma
        P_V = (A==127)?1:0; //overflow 
        //H = (A[3:0] + B[3:0] > 15)?1:0;
        Z = (Result==0)?1:0;
        S = Result[7];
        end
        DCR:
        begin
        //C no se afecta
        //N = 1;              //Set para resta
        P_V = (A==-128)?1:0; //overflow  
        //H = (A[3:0] - B[3:0] < 0)?1:0;
        Z = (Result==0)?1:0;
        S = Result[7];
        end
        RLC:
        begin
        C = A[7];   // bit 7 pasa al carry
        //N = 0;              //Reset siempre
        P_V = ~^Result; //PAR  
        //H = 0;              //Reset siempre
        Z = (Result==0)?1:0;
        S = Result[7];
        end
        RRC:
        begin
        C = A[0];   // bit 0 pasa al carry
        //N = 0;              //Reset siempre
        P_V = ~^Result; //PAR  
        //H = 0;              //Reset siempre
        Z = (Result==0)?1:0;
        S = Result[7];
        end
        RL:
        begin
        C = A[7];   // bit 7 pasa al carry
        //N = 0;              //Reset siempre
        P_V = ~^Result; //PAR  
        //H = 0;              //Reset siempre
        Z = (Result==0)?1:0;
        S = Result[7];
        end
        RR:
        begin
        C = A[0];   // bit 0 pasa al carry
        //N = 0;              //Reset siempre
        P_V = ~^Result; //PAR  
        //H = 0;              //Reset siempre
        Z = (Result==0)?1:0;
        S = Result[7];
        end
        SLA:
        begin
        C = A[7];   // bit 7 pasa al carry
        //N = 0;              //Reset siempre
        P_V = ~^Result; //PAR  
        //H = 0;              //Reset siempre
        Z = (Result==0)?1:0;
        S = Result[7];
        end
        SRL:
        begin
        C = A[0];   // bit 0 pasa al carry
        //N = 0;              //Reset siempre
        P_V = ~^Result; //PAR  
        //H = 0;              //Reset siempre
        Z = (Result==0)?1:0;
        S = Result[7];
        end
        SRA:
        begin
        C = A[0];   // bit 0 pasa al carry
        //N = 0;              //Reset siempre
        P_V = ~^Result; //PAR  
        //H = 0;              //Reset siempre
        Z = (Result==0)?1:0;
        S = Result[7];
        end  
                    
        default:
        Z = 0;
        endcase
        N = 0;
        H = 0;
   
end
endmodule

