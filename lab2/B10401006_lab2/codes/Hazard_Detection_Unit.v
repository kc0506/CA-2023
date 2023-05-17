module Hazard_Detection_Unit (

         clk_i,
         rst_i,

         ID_Rs1,
         ID_Rs2,
         EX_Rd,
         EX_MemRead,

         NoOp,
         PCWrite,
         Stall,
       );

input [4:0] ID_Rs1,ID_Rs2, EX_Rd;
input EX_MemRead;
input rst_i, clk_i;

output reg NoOp, PCWrite, Stall;

always @(ID_Rs1 or ID_Rs2 or EX_Rd or EX_MemRead)
  begin
    // stall due to load
    if (EX_MemRead && (ID_Rs1 == EX_Rd || ID_Rs2 == EX_Rd))
      begin
        NoOp <= 1;
        PCWrite <= 0;
        Stall <= 1;
      end
    else
      begin
        NoOp <= 0;
        PCWrite <= 1;
        Stall <= 0;
      end
  end

endmodule
