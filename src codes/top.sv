module top;
  bit clk;
  always #5 clk = ~clk;
  FIFO_it FIFOit (clk);
  FIFO dut (FIFOit);
  FIFO_test TEST (FIFOit);
  FIFO_monitor monitor (FIFOit);
endmodule