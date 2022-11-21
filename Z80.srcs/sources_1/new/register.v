// Code your design here
module register #(parameter W = 8) (
  input CLK,
  input RST_N,
  input LOAD,
  input [W-1:0] DATA_IN,
  output reg [W-1:0] DATA_OUT
);
always @(posedge CLK or negedge RST_N)
begin
  if (!RST_N) begin
    DATA_OUT <=  0; end
  else if (LOAD) begin
    DATA_OUT <= DATA_IN; end
end
endmodule
    
 