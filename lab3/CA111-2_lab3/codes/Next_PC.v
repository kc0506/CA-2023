module Next_PC (

         Wrong_predict_i,
         Predict_i,

         pc_adder_i,
         jmp_ID_i,
         jmp_EX_i,

         next_pc_o,
       );

// ? Signals
input Wrong_predict_i, Predict_i, Branch_ID;

// ? Possible pc
input [31:0] pc_adder_i, jmp_ID_i, jmp_EX_i;

output reg next_pc_o;

always @(*)
  begin
    if (Wrong_predict_i)
      next_pc_o <= jmp_EX_i;
    else if(Branch_ID && Predict_i)
      next_pc_o <= jmp_ID_i;
    else
      next_pc_o <= pc_adder_i;
  end

endmodule
