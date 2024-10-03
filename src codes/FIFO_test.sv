import shared_pkg::*;
import FIFO_transaction_pkg::*;

module FIFO_test (
    FIFO_it.TEST FIFOit
);
  FIFO_transaction trans;

  initial begin
    trans = new();

    // FIFO_1
    assert_reset;

    // FIFO_2
    repeat (9999) begin
      assert (trans.randomize());
      FIFOit.data_in = trans.data_in;
      FIFOit.wr_en   = trans.wr_en;
      FIFOit.rd_en   = trans.rd_en;
      FIFOit.rst_n   = trans.rst_n;
      @(negedge FIFOit.clk);
    end
    shared_pkg::test_finished = 1;
  end

  task assert_reset;
    FIFOit.rst_n = 0;
    @(negedge FIFOit.clk);
    FIFOit.rst_n = 1;
  endtask
endmodule