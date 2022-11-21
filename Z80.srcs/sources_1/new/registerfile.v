// Code your design here
module registerfile #(parameter W = 8, parameter R = 15) (
input CLK,
input RST_N,
input OE,

//input LOAD,
input [4:0] SEL_LOAD, 
input [3:0] SEL_DATA_OUT,
input [W-1:0] DATA_IN,
output [W-1:0] DATA_OUT
);


reg [R-1:0] LOAD_REGS;
wire [W-1:0] A;             //Acumulador A(ALU)
wire [W-1:0] F;             //Banderas F(ALU)
wire [W-1:0] B;             //Registro general
wire [W-1:0] C;             //Registro general
wire [W-1:0] D;             //Registro general
wire [W-1:0] E;             //Registro banderas general
wire [W-1:0] H;             //Registro banderas general
wire [W-1:0] L;             //Registro banderas general
wire [W-1:0] IXH;           //Registro de indice IX(16 bits) 8 más significativos
wire [W-1:0] IXL;           //Registro de indice IX(16 bits) 8 menos significativos
wire [W-1:0] IYH;           //Registro de indice IY(16 bits) 8 más significativos
wire [W-1:0] IYL;           //Registro de indice IX(16 bits) 8 menos significativos
wire [W-1:0] SPH;           // Stack pointer 8 MSB
wire [W-1:0] SPL;           // Stack pointer 8 LSB
wire [W-1:0] PCH;           //  Program counter 8MSB
wire [W-1:0] PCL;           //  Program couter 8LSB 

reg [W-1:0] DATA_PRE_OUT;
// reg [W-1:0] MEM_REG [R-1:0];
// reg [W-1:0] MEM_REG2 [R-1:0];
// reg [W-1:0] DATA_OUT_PRE;
assign DATA_OUT =  OE? DATA_PRE_OUT : 8'bZZZZZZZZ;


always @(SEL_LOAD) begin
case (SEL_LOAD)
16: LOAD_REGS = 16'h0001;       //000{0001}
17: LOAD_REGS = 16'h0002;       //000{0010}
18: LOAD_REGS = 16'h0004;       //000{0100}
19: LOAD_REGS = 16'h0008;       //000{1000}
20: LOAD_REGS = 16'h0010;       //00{0001}0
21: LOAD_REGS = 16'h0020;       //etc
22: LOAD_REGS = 16'h0040;
23: LOAD_REGS = 16'h0080;
24: LOAD_REGS = 16'h0100;
25: LOAD_REGS = 16'h0200;
26: LOAD_REGS = 16'h0400;
27: LOAD_REGS = 16'h0800;
28: LOAD_REGS = 16'h1000;
29: LOAD_REGS = 16'h2000;
30: LOAD_REGS = 16'h4000;
31: LOAD_REGS = 16'h8000;
default: LOAD_REGS = 0;
endcase
end
//  genvar i;
//  generate
//    for (i=0; i<R; i = i+1) begin
//      register #(.W(8)) u0 (.CLK(CLK),.RST_N(RST_N),.LOAD(LOAD_REGS[R]),.DATA_IN(DATA_IN),.DATA_OUT(MEM_REG[R]));
//    end    
//  endgenerate

register #(.W(8)) AR (.CLK(CLK),.RST_N(RST_N),.LOAD(LOAD_REGS[0]),.DATA_IN(DATA_IN),.DATA_OUT(A));
register #(.W(8)) FR (.CLK(CLK),.RST_N(RST_N),.LOAD(LOAD_REGS[1]),.DATA_IN(DATA_IN),.DATA_OUT(F));
register #(.W(8)) BR (.CLK(CLK),.RST_N(RST_N),.LOAD(LOAD_REGS[2]),.DATA_IN(DATA_IN),.DATA_OUT(B));
register #(.W(8)) CR (.CLK(CLK),.RST_N(RST_N),.LOAD(LOAD_REGS[3]),.DATA_IN(DATA_IN),.DATA_OUT(C));
register #(.W(8)) DR (.CLK(CLK),.RST_N(RST_N),.LOAD(LOAD_REGS[4]),.DATA_IN(DATA_IN),.DATA_OUT(D));
register #(.W(8)) ER (.CLK(CLK),.RST_N(RST_N),.LOAD(LOAD_REGS[5]),.DATA_IN(DATA_IN),.DATA_OUT(E));
register #(.W(8)) HR (.CLK(CLK),.RST_N(RST_N),.LOAD(LOAD_REGS[6]),.DATA_IN(DATA_IN),.DATA_OUT(H));
register #(.W(8)) LR (.CLK(CLK),.RST_N(RST_N),.LOAD(LOAD_REGS[7]),.DATA_IN(DATA_IN),.DATA_OUT(L));
register #(.W(8)) IXHR (.CLK(CLK),.RST_N(RST_N),.LOAD(LOAD_REGS[8]),.DATA_IN(DATA_IN),.DATA_OUT(IXH));
register #(.W(8)) IXLR (.CLK(CLK),.RST_N(RST_N),.LOAD(LOAD_REGS[9]),.DATA_IN(DATA_IN),.DATA_OUT(IXL));
register #(.W(8)) IYHR (.CLK(CLK),.RST_N(RST_N),.LOAD(LOAD_REGS[1]),.DATA_IN(DATA_IN),.DATA_OUT(IYH));
register #(.W(8)) IYLR (.CLK(CLK),.RST_N(RST_N),.LOAD(LOAD_REGS[1]),.DATA_IN(DATA_IN),.DATA_OUT(IYL));
register #(.W(8)) SPHR (.CLK(CLK),.RST_N(RST_N),.LOAD(LOAD_REGS[10]),.DATA_IN(DATA_IN),.DATA_OUT(SPH));
register #(.W(8)) SPLR (.CLK(CLK),.RST_N(RST_N),.LOAD(LOAD_REGS[11]),.DATA_IN(DATA_IN),.DATA_OUT(SPL));
register #(.W(8)) PCHR (.CLK(CLK),.RST_N(RST_N),.LOAD(LOAD_REGS[12]),.DATA_IN(DATA_IN),.DATA_OUT(PCH));
register #(.W(8)) PCLR (.CLK(CLK),.RST_N(RST_N),.LOAD(LOAD_REGS[13]),.DATA_IN(DATA_IN),.DATA_OUT(PCL));


always @(SEL_DATA_OUT) begin
case (SEL_DATA_OUT)
0: DATA_PRE_OUT = A;
1: DATA_PRE_OUT = F;
2: DATA_PRE_OUT = B;
3: DATA_PRE_OUT = C;
4: DATA_PRE_OUT = D;
5: DATA_PRE_OUT = E;
6: DATA_PRE_OUT = H;
7: DATA_PRE_OUT = L;
8: DATA_PRE_OUT = IXH;
9: DATA_PRE_OUT = IXL;
10: DATA_PRE_OUT = IYH;
11: DATA_PRE_OUT = IYL;
12: DATA_PRE_OUT = SPH;
13: DATA_PRE_OUT = SPL;
14: DATA_PRE_OUT = PCH;
15: DATA_PRE_OUT = PCL;
endcase

end

endmodule 