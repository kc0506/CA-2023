
// `include "./PC.v"
// `include "./Instruction_Memory.v"
// `include "./Registers.v"
// `include "./Control.v"
// `include "./Adder.v"
// `include "./Sign_Extend.v"
// `include "./ALU.v"
// `include "./ALU_Control.v"

module CPU
       (
         clk_i,
         rst_i,
       );

// * Ports
input               clk_i;
input               rst_i;

// * Wires
wire [31:0] pc;
wire [31:0] pc_o, instr_out;
wire [1:0] ALUOp;
wire ALUSrc, RegWrite;
wire [2:0] ALUctl;

reg [31:0] instr_addr;  // ? delay
wire [31:0] instr;

wire [31:0] data1, data2, imme, MUXres, ALUres;

PC PC (
     .clk_i(clk_i),
     .rst_i(rst_i),
     .pc_i(pc),
     .pc_o(pc_o)
   );


Instruction_Memory Instruction_Memory(
                     .addr_i(instr_addr),
                     .instr_o(instr_out)
                   );

assign instr = instr_out;

always @(posedge clk_i or negedge rst_i)
  begin
    #1
     instr_addr = pc_o;
  end


Registers Registers(
            .rst_i(rst_i),
            .clk_i(clk_i),
            .RS1addr_i(instr[19:15]),
            .RS2addr_i(instr[24:20]),
            .RDaddr_i(instr[11:7]),
            .RDdata_i(ALUres),
            .RegWrite_i(RegWrite),
            .RS1data_o(data1),
            .RS2data_o(data2)
          );

Control Control(
          .opcode(instr[6:0]),
          .ALUOp(ALUOp),
          .ALUSrc(ALUSrc),
          .RegWrite(RegWrite)
        );

Adder_32 Add_PC(
           .a(instr_addr),
           .b(32'd4),
           .c(pc)
         );

MUX32 MUX_ALUSrc(
        .in0(data2),
        .in1(imme),
        .swt(ALUSrc),
        .res(MUXres)
      );

Sign_Extend Sign_Extend(
              .in(instr[31:20]),
              .out(imme)
            );

ALU ALU(
      .op1(data1),
      .op2(MUXres),
      .res(ALUres),
      .ctl(ALUctl)
    );

ALU_Control ALU_Control(
              .ALUOp(ALUOp),
              .funct7(instr[31:25]),
              .funct3(instr[14:12]),
              .ALUctl(ALUctl)
            );

endmodule

