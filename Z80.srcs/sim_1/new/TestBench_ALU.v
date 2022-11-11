`timescale 1ns / 1ps


module TestBench_ALU();
//Inputs
reg[7:0] A, B,F_in,Data_res;
reg[4:0] Sel;
reg [29:0]TstVector;
reg[7:0] COMP;
//Outputs
 wire[7:0]  ALU_out,F_out;
integer infile, i;

//Aux 
 ALU test_unit(
        A,B,F_in,Sel,ALU_out,F_out
);

    initial begin
    //Primer caso A+B >255
//        A = 8'hF0;
//        B = 8'hFF;
        F_in = 0;
        Sel = 4'd0;
        i =0;
        COMP = ALU_out;
        infile = $fopen("Datain.csv","r");
       // $display("primera linea %b, ",TstVector);
        //#10;
        //while(!feof(infile))
        for (i=0; i<80;i=i+1)
        begin
        $fscanf(infile,"%b\n",TstVector);
        A = TstVector[28:21];
        B = TstVector[20:13];
        Sel = TstVector[12:8];
        Data_res=TstVector[7:0];
        assign COMP = ALU_out;      //Sin el assign el valor de la ALU pasa a COMP hasta el segundo ciclo
        #10;
        //COMP = (TstVector[7:0]==ALU_out)?1:0; 
        end
        $fclose(infile);
    end
endmodule
