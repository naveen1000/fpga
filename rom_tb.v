module ROM_TB;
reg [7:0] address;
reg clk;
output wire [15:0] inst;

ROM RUT(address,clk,inst);
initial 
begin

$monitor($time,"add=%d clk=%d inst=%b",address,clk,inst);
address=8'b0;
#5 clk=0;#5 clk=1;
#5address=8'b1;
#5 clk=0;#5 clk=1;

$finish;   
end
endmodule