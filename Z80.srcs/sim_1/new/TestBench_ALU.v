`timescale 1ns / 1ps


module TestBench_ALU();
//Inputs
reg[7:0] A, B,F_in;
reg[3:0] Sel;

//Outputs
 wire[7:0] ALU_out, F_out;


//Aux
reg[3:0] i; 
 ALU test_unit(
        A,B,F_in,Sel,ALU_out,F_out
);

    initial begin
    //Primer caso A+B >255
        A = 8'hF0;
        B = 8'hFF;
        F_in = 0;
        Sel = 4'd0;
        i = 4'd0;
        #10;
        for (i=0; i<12;i=i+1)
        begin
             Sel = Sel +1;
             #10;
        
        end
       //Segundo caso B>A
        A = 8'hF0;
        B = 8'hF1;
        F_in = 0;
        Sel = 4'd0;
        i = 4'd0;
        #10;
        for (i=0; i<12;i=i+1)
        begin
             Sel = Sel +1;
             #10;
        
        end
        
    
    end
endmodule
