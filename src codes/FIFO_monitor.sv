import FIFO_transaction_pkg::*;
import FIFO_scoreboard_pkg::*;
import FIFO_coverage_pkg::*;
import shared_pkg::*;
module FIFO_monitor (FIFO_it.monitor FIFOit);
    FIFO_transaction f_txn;
    FIFO_scoreboard f_scoreboard = new();
    FIFO_coverage f_coverage = new();
    initial begin
        f_txn = new();
        forever begin
            f_txn.data_in = FIFOit.data_in;
            f_txn.wr_en = FIFOit.wr_en;
            f_txn.rd_en = FIFOit.rd_en;
            f_txn.rst_n = FIFOit.rst_n;
            @(negedge FIFOit.clk);
            f_txn.data_out = FIFOit.data_out;
            f_txn.full = FIFOit.full;
            f_txn.almostfull = FIFOit.almostfull;
            f_txn.empty = FIFOit.empty;
            f_txn.almostempty = FIFOit.almostempty;
            f_txn.overflow = FIFOit.overflow;
            f_txn.underflow = FIFOit.underflow;
            f_txn.wr_ack = FIFOit.wr_ack;
            @(posedge FIFOit.clk);
            
            fork
                begin
                    f_coverage.sample_data(f_txn);
                end

                begin
                    f_scoreboard.check_data(f_txn);
                end
            join

            if (shared_pkg::test_finished) begin
                $display("--------------------Summary--------------------");
                $display("Test finished. Correct: %0d, Errors: %0d", correct_count, error_count);
                $stop;    
            end
        end
    end
endmodule