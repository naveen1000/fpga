`define NOP   4'd0  // 0 filled
`define LOAD  4'd1  // dest, op1, offset  : R[dest] = M[R[op1] + offset]
`define STORE 4'd2  // dest, src, offset  : M[R[op1] + offset] = R[src]
`define SET   4'd3  // dest, const        : R[dest] = const
`define LT    4'd4  // dest, op1, op2     : R[dest] = R[op1] < R[op2]
`define EQ    4'd5  // dest, op1, op2     : R[dest] = R[op1] == R[op2]
`define BEQ   4'd6  // dest, op1, op2     : R[0] = R[op2] if (R[dest] == const ? 2 : 1)
`define BNEQ  4'd7  // dest, op1, op2     : R[0] = R[op2] if (R[dest] != const ? 2 : 1)
`define ADD   4'd8  // dest, op1, op2     : R[dest] = R[op1] + R[op2]
`define SUB   4'd9  // dest, op1, op2     : R[dest] = R[op1] - R[op2]
`define SHL   4'd10 // dest, op1, op2     : R[dest] = R[op1] << R[op2]
`define SHR   4'd11 // dest, op1, op2     : R[dest] = R[op1] >> R[op2]
`define AND   4'd12 // dest, op1, op2     : R[dest] = R[op1] & R[op2]
`define OR    4'd13 // dest, op1, op2     : R[dest] = R[op1] | R[op2]
`define INV   4'd14 // dest, op1          : R[dest] = ~R[op1]
`define XOR   4'd15 // dest, op1, op2     : R[dest] = R[op1] ^ R[op2]

module top (
  input clk,
  output LED1,
  output LED2,
  output LED3,
  output LED4,
  output LED5
  );

  //reg [10:0] slow_clk;
  reg [7:0] r [15:0];
  reg [3:0] op;        // opcode
  reg [3:0] arg1;      // first arg
  reg [3:0] arg2;      // second arg
  reg [3:0] dest;      // destination arg
  reg [3:0] constant;  // constant arg
  wire [15:0] ROMinst;
  //wire clk;

  ROM ROM (
    .clk(clk),
    .address(r[0]),
    .inst(ROMinst)
    );
/*
  always @ (posedge clk) begin
    slow_clk <= slow_clk + 1;
  end
*/
  always @(posedge clk) begin

  r[0] = r[0] + 1;      // increment PC by default

  op = ROMinst[15:12];     // opcode is top 4 bits
  dest = ROMinst[11:8];    // dest is next 4 bits
  arg1 = ROMinst[7:4];     // arg1 is next 4 bits
  arg2 = ROMinst[3:0];     // arg2 is last 4 bits
  constant = ROMinst[7:0]; // constant is last 8 bits

  case (op)
    `LOAD:
      r[dest] <= r[arg1] + arg2;              // set the address
    `STORE:
      r[dest] <= r[arg1] + arg2;              // set the address
    `SET:
      r[dest] <= constant;                    // set the reg to constant
    `LT:
      r[dest] <= r[arg1] < r[arg2];   // less-than comparison
    `EQ:
      r[dest] <= r[arg1] == r[arg2];  // equals comparison
    `BEQ:
        if (r[dest] == r[arg1]) r[0] <= r[arg2];                 // skip next instruction
    `BNEQ:
        if (r[dest] != r[arg1]) r[0] <= r[arg2];                 // skip next instruction
    `ADD:
      r[dest] <= r[arg1] + r[arg2];   // addition
    `SUB:
      r[dest] <= r[arg1] - r[arg2];   // subtraction
    `SHL:
      r[dest] <= r[arg1] << r[arg2];  // shift left
    `SHR:
      r[dest] <= r[arg1] >> r[arg2];  // shift right
    `AND:
      r[dest] <= r[arg1] & r[arg2];   // bit-wise AND
    `OR:
      r[dest] <= r[arg1] | r[arg2];   // bit-wise OR
    `INV:
      r[dest] <= ~r[arg1];                // bit-wise invert
    `XOR:
      r[dest] <= r[arg1] ^ r[arg2];   // bit-wise XOR
  endcase
  end

  assign {LED1,LED2,LED3,LED4,LED5} = r[1][4:0];

endmodule // top

module ROM (
input [7:0] address,
input clk,
output reg [15:0] inst
);

reg [15:0] rom [0:255];
initial begin
  $readmemb("./asm/rom_asm.txt", rom);
  inst <= {`NOP, 12'b0};
end

always @(posedge clk) begin
  inst <= rom[address];
end

endmodule // ROM
