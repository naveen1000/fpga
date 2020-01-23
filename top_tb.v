module top_tb;
  reg clk;
  wire LED1;
  wire LED2;
  wire LED3;
  wire LED4;
  wire LED5;
top tut(clk,LED1,LED2,LED3,LED4,LED5);
initial 
begin
$monitor($time,"clk=%d l1=%b %b %b %b %b",clk,LED1,LED2,LED3,LED4,LED5);
#5 clk=0;#5 clk=1;
#5 clk=0;#5 clk=1;

$finish;   
end
endmodule // top_tb