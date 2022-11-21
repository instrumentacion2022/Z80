`timescale 1ns / 1ps


module TestBench_ALU();
//Inputs
reg[7:0] A, B,F_in,Data_res,Data_flags;
reg[4:0] Sel;
reg [36:0]TstVector;
reg COMP, COMP_F;
//Outputs
 wire[7:0]  ALU_out,F_out;
integer infile, i,Errors, Errors_F;

//Aux 
 ALU test_unit(
        A,B,F_in,Sel,ALU_out,F_out
);

    initial begin
    //Primer caso A+B >255
//        A = 8'hF0;
//        B = 8'hFF;
        F_in = 8'h00;
        Sel = 4'd0;
        Errors = 0;
        Errors_F = 0;
        infile = $fopen("Datain.csv","r");
       // $display("primera linea %b, ",TstVector);
        //#10;
        //while(!feof(infile))
        for (i=0; i<170;i=i+1)
        begin
        $fscanf(infile,"%b\n",TstVector);
        A = TstVector[36:29];
        B = TstVector[28:21];
        Sel = TstVector[20:16];
        Data_res=TstVector[15:8];
        Data_flags = TstVector[7:0];
        assign COMP = (Data_res==ALU_out)?1:0;      //Sin el assign el valor de la ALU pasa a COMP hasta el segundo ciclo
        //assign COMP_F = (Data_flags ==F_out)?1:0;
        assign COMP_F = (Data_flags[2] ==F_out[2])?1:0;
        //assign Errors = (COMP==1)?Errors:Errors+1;
         #10;
        COMP = (TstVector[7:0]==ALU_out)?1:0;
        if (COMP == 1)
        begin
           Errors = Errors;
        end
        else begin
            Errors = Errors + 1;
        end
        if (COMP_F == 1)
        begin
           Errors_F = Errors_F;
        end
        else begin
            Errors_F = Errors_F + 1;
        end

       
        end
        $fclose(infile);
    end
endmodule
