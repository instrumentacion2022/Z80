// Zilog Z80 Project - INSTITUTO NACIONAL DE ATROFISICA OPTICA Y ELECTRONICA

// Z80 Controller Module
module Z80CU (

input iCLK,
input iRST,
input [7:0] iOPCODE,   
// Z80 External memory control signals
output wire oMREQ,
output wire oRD,
output wire oWR,
        
// Bus eneable
output wire oADR_EN,
output wire oIO_EN, 
        
// Z80 Internal control signals
output wire oLD_INSTREG,
output wire oLD_PC,
output wire oINC_PC,
output wire oWR_INT,
output wire [2:0] oWR_SEL,
output wire oRD_INT,
output wire [2:0] oRD_SEL);
//--------------------------------------------------------------------------
      
// No Blocking Assignments Control States
  reg [15:0] rSTATE_D;	reg [15:0] rSTATE_Q; 
  
// No Blocking Assignments External Memory Control Signals
  reg rMREQ;
  reg rRD;
  reg rWR;
  
// No Blocking Flip flop Assignments BUS eneable signals
  reg rADR_EN;
  reg rIO_EN;

// No Blocking Flip flop Assignments Internal Control Signals
  reg rLD_INSTREG;
  reg rLD_PC;
  reg rINC_PC;
  reg rWR_INT;
  reg [2:0] rWR_SEL;
  reg rRD_INT;
  reg [2:0] rRD_SEL;
  
// Output Assignments
  
 assign oMREQ = rMREQ;
 assign oRD = rRD;
 assign oWR = rWR;
 assign oADR_EN = rADR_EN;
 assign oIO_EN = rIO_EN;
 assign oLD_INSTREG = rLD_INSTREG;
 assign oLD_PC = rLD_PC;
 assign oINC_PC = rINC_PC;
 assign oWR_INT = rWR_INT;
 assign oWR_SEL = rWR_SEL;
 assign oRD_INT = rRD_INT;
 assign oRD_SEL =	rRD_SEL;

//Initial values of registers
initial 
  begin
      rSTATE_Q <= 16'h0000;
      rMREQ <= 1'b0;
      rRD <= 1'b0;
      rWR <= 1'b0;
      rADR_EN <= 1'b0;
      rIO_EN <= 1'b0;
      rLD_INSTREG <= 1'b0;
      rLD_PC <= 1'b0;
      rINC_PC <= 1'b0;
      rWR_INT <= 1'b0;
      rWR_SEL <= 3'b000;
      rRD_INT <= 1'b0;
      rRD_SEL <= 3'b000; 
    
      rSTATE_D <= 16'h0000;

end   
  
// Flip flops - Outputs Assignments 
  always @(posedge iCLK)
    begin
      rSTATE_Q <= rSTATE_D;
    end


// General secuential of States
  always @*
    begin
      if (iRST) begin
        rSTATE_D = 16'h0000;
      	end
      else begin
      		case(rSTATE_Q)
        	//Fetch------------------------------------------------------------------------------------------------
            //Initial STATE
        	16'h0000:
            begin
        	rSTATE_D = 16'h0001; rMREQ = 1'b0; rWR = 1'b0; rRD = 1'b0; 
            rADR_EN = 1'b0; rIO_EN = 1'b0; rLD_INSTREG = 1'b0; 		
            rLD_PC = 1'b0; 
            rINC_PC = 1'b0;
            rWR_INT = 1'b0;
            rWR_SEL = 3'b000;
            rRD_INT = 1'b0;
            rRD_SEL = 3'b000;
            end
           
            //Program Memorý Request
            16'h0001: 
            begin
        	rSTATE_D = 16'h0002; rMREQ = 1'b1; rWR = 1'b0; rRD = 1'b1; 
            rADR_EN = 1'b1; rIO_EN = 1'b1; rLD_INSTREG = 1'b0; 
            rLD_PC = 1'b0; rINC_PC = 1'b0; rWR_INT = 1'b0; 
            rRD_INT = 1'b0;  
            end
              
            //LD Instruction Register
            16'h0002:
            begin
        	rSTATE_D = 16'h0003; rMREQ = 1'b1; rWR = 1'b0; rRD = 1'b1; 
            rADR_EN = 1'b1; rIO_EN = 1'b1; rLD_INSTREG = 1'b1; 
            rLD_PC = 1'b0; rINC_PC = 1'b1; rWR_INT = 1'b0; rRD_INT = 1'b0; 
            end
              
            //DECODE------------------------------------------------------------------------------------------------
            16'h0003:	
            begin
            rMREQ = 1'b0; 
            rWR = 1'b0; 
            rRD = 1'b0; 
            rADR_EN = 1'b0; 
            rIO_EN = 1'b0; 
            rLD_INSTREG = 1'b0; 
            rLD_PC = 1'b0; 
            rINC_PC = 1'b0; 
            rWR_INT = 1'b0; 
            rRD_INT = 1'b0; 
              casex (iOPCODE)
        			8'b01xxxxxx:    //LD r<--r'
        			begin
          				if (iOPCODE[2:0] == 3'b110 || iOPCODE[5:3] == 3'b110) begin
          					rSTATE_D = 16'h0000; //Indirect adressing (pending)
          					end
          				else begin
            				rWR_SEL = iOPCODE[5:3];
            				rRD_SEL = iOPCODE[2:0];
            				rSTATE_D = 16'h0004;  
          				end
        			end
        
       				8'b00xxx110:    //LD r<--n
        			begin
          				if (iOPCODE[5:3] == 3'b110) begin
            				rSTATE_D = 16'h0000; //Indirect adressing (pending)
            				end
          				else begin
            				rWR_SEL = iOPCODE[5:3]; 
            				rSTATE_D = 16'h0006;
          				end
       		 		end
         
        			default: rSTATE_D = 16'h0000; //To Fetch Instruction States
       
     				endcase
            end
            //------------------------------------------------------------------------------------------------------
              
            //LD r<--r'
            16'h0004:
            begin
            rSTATE_D = 16'h0005; rMREQ = 1'b0; rWR = 1'b0; rRD = 1'b0; 
            rADR_EN = 1'b0; rIO_EN = 1'b0; rLD_INSTREG = 1'b0; 
            rLD_PC = 1'b0; rINC_PC = 1'b0; rWR_INT = 1'b0;
            rRD_INT = 1'b1; 
            end
            
            16'h0005:
            begin
            rSTATE_D = 16'h0000; rMREQ = 1'b0; rWR = 1'b0; rRD = 1'b0; 
            rADR_EN = 1'b0; rIO_EN = 1'b0; rLD_INSTREG = 0; 
            rLD_PC = 1'b0; rINC_PC = 1'b0; rWR_INT = 1'b1; 
            rRD_INT = 1'b1;
            end
              
            //LD r<--n
            16'h0006:
            begin
            rSTATE_D = 16'h0007; rMREQ = 1'b1; rWR = 1'b0; rRD = 1'b0; 
            rADR_EN = 1'b0; rIO_EN = 1'b1; rLD_INSTREG = 1'b0; 
            rLD_PC = 1'b0; rINC_PC = 1'b1; rWR_INT = 1'b0; 
            rRD_INT = 1'b0; 
            end
            
            16'h0007:
            begin
            rSTATE_D = 16'h0000; rMREQ = 1'b1; rWR = 1'b0; rRD = 1'b1; 
            rADR_EN = 1'b1; rIO_EN = 1'b1; rLD_INSTREG = 1'b0; 
            rLD_PC = 1'b0; rINC_PC = 1'b0; rWR_INT = 1'b1;
            rRD_INT = 1'b0; 
            end
            
            default rSTATE_D = 16'h0000;
            
            endcase
    	end
end
endmodule     
