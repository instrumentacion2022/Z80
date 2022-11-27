`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: INAOE
// Engineer: CA
// Project: Z80
//////////////////////////////////////////////////////////////////////////////////

module REGALU(
input [7:0] DATA_IN,
input CLK,
input LOAD_B,
input LOAD_A_OUT,LOAD_A_IN,SEL_A_IN,SEL_A_OUT, RST_A,
input LOAD_F_OUT, LOAD_F_IN,SEL_F_IN,SEL_F_OUT, RST_F,
input [4:0] SEL,
output [7:0] DATA_A_OUT,
output [7:0] DATA_F_OUT
    );

    reg [7:0] A_IN, A_BUFF;
    reg [7:0] ALU_IB, ALU_IA;
    reg [7:0] ALU_IF;
    wire [7:0] ALU_OA;
    wire [7:0] ALU_OF;
    wire [7:0] A_OUT;
    reg [7:0] F_IN,F_BUFF;
    wire [7:0] F_OUT;
    
    register #(.W(8)) A (.CLK(CLK),.RST_N(RST_A),.LOAD(LOAD_A_IN),.DATA_IN(A_IN),.DATA_OUT(A_OUT));
    register #(.W(8)) F (.CLK(CLK),.RST_N(RST_F),.LOAD(LOAD_F_IN),.DATA_IN(F_IN),.DATA_OUT(F_OUT));
    
    always @(*) begin
        ///MUX A
        if(SEL_A_IN) begin
            A_IN = DATA_IN;
        end
        else begin
            A_IN = ALU_OA;
        end
        //DEMUX A
        if(SEL_A_OUT) begin
            A_BUFF <= A_OUT;
        end
        else begin
            ALU_IA <= A_OUT;
        end
        //BUFFER B
        if (LOAD_B) begin
            ALU_IB = DATA_IN;
        end
        else begin
            ALU_IB = 8'hZZ;
        end
        ////MUX F
        if (SEL_F_IN) begin
            F_IN = DATA_IN;
        end 
        else begin
            F_IN = ALU_OF;
        end
        //DEMUX F
        if (SEL_F_OUT) begin
            F_BUFF <= F_OUT;
        end
        else begin
            ALU_IF <=F_OUT;
        end
    end
    assign DATA_A_OUT =(LOAD_A_OUT)? A_BUFF:8'hZZ;      //BUFFER A
    assign DATA_F_OUT=(LOAD_F_OUT)? F_BUFF:8'hZZ;       //BUFFER F
    ALU ALU1 (ALU_IA,ALU_IB,ALU_IF,SEL,ALU_OA,ALU_OF);
    
    initial begin
    ALU_IF = 8'h00;
    end
    
endmodule

