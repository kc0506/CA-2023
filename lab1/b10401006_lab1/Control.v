module Control(
         opcode,
         ALUOp,
         ALUSrc,
         RegWrite
       );

input [6:0] opcode;
output reg [1:0] ALUOp;
output reg ALUSrc;
output reg RegWrite;

wire R_type, I_type;
assign R_type = 7'b0110011;
assign I_type = 7'b0010011;

always@(opcode)
  begin
    case (opcode)
      7'b0110011:
        begin
          ALUOp  <= 2'b11;  // decided by funct code
          ALUSrc <= 0;  // from data2
          RegWrite <= 1;
        end
      7'b0010011:
        begin
          ALUOp <= 2'b10;  // decided by funct code, imme
          ALUSrc <= 1;  // from imme
          RegWrite <= 1;
        end
      default:
        begin
          ALUOp <= 0;
          ALUSrc <= 0;
          RegWrite <= 0;
        end
    endcase
  end

endmodule;
