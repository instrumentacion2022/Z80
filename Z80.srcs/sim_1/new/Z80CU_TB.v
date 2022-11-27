//ZILOG Z80 Control Unit Test Bench
`timescale 1ns/1ps
module Z80CU_TB();
  reg CLK; 
  reg RST_TB;
  reg [2:0] ADR1;
  reg [2:0] ADR2;
  reg [7:0] OPCODE_TB;
  wire MREQ_TB;
  wire RD_TB;
  wire WR_TB;
  wire ADR_EN_TB;
  wire IO_EN_TB;
  wire LD_INSTREG_TB;
  wire LD_PC_TB;
  wire INC_PC_TB;
  wire WR_INT_TB;
  wire [2:0] WR_SEL_TB; 
  wire RD_INT_TB; 
  wire [2:0] RD_SEL_TB; 
   
Z80CU DUT (.iCLK(CLK),
           .iRST(RST_TB), 
           .iOPCODE(OPCODE_TB), 
           .oMREQ(MREQ_TB), 
           .oRD(RD_TB), 
           .oWR(WR_TB), 
           .oADR_EN(ADR_EN_TB), 
           .oIO_EN(IO_EN_TB), 
           .oLD_INSTREG(LD_INSTREG_TB), 
           .oLD_PC(LD_PC_TB), 
           .oINC_PC(INC_PC_TB), 
           .oWR_INT(WR_INT_TB), 
           .oWR_SEL(WR_SEL_TB), 
           .oRD_INT(RD_INT_TB), 
           .oRD_SEL(RD_SEL_TB));

//OPCODES FILE REGISTER'S ADRESSES
//assign ADR1 = 3'b011;
//assign   ADR2 = 3'b101; //Las moví adentro del initial XD
  
initial begin
  CLK <= 1'b0;
  RST_TB <= 1'b0;
  assign ADR1 = 3'b011;
  assign   ADR2 = 3'b101;
  //LD r(ADR1)<---r'(ADR2)
  OPCODE_TB <= {2'b01, ADR1, ADR2};
  
  //LD r(ADR1)<---n
  #100 OPCODE_TB <= {2'b00, ADR1, 3'b110};
  #160
  
  //RESET AND FETCH LOOP
  OPCODE_TB <= 8'h00;
  RST_TB <= 1'b1;
  #20 RST_TB <= 1'b0;
  #100 $finish; 
  end
  
always begin
    #10;
  	CLK <= ~CLK;
	end
	
  
initial begin
    $dumpvars;
    $dumpfile("dump.vcd");
  end   
  
endmodule