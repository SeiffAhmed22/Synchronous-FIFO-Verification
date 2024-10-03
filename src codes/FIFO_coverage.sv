package FIFO_coverage_pkg;
    import FIFO_transaction_pkg::*;
    class FIFO_coverage;
        FIFO_transaction F_cvg_txn;
        covergroup cg_FIFO;
            cp_wr_en: coverpoint F_cvg_txn.wr_en;
            cp_rd_en: coverpoint F_cvg_txn.rd_en;
            cp_wr_ack: coverpoint F_cvg_txn.wr_ack;
            cp_overflow: coverpoint F_cvg_txn.overflow;
            cp_full: coverpoint F_cvg_txn.full;
            cp_empty: coverpoint F_cvg_txn.empty;
            cp_almostfull: coverpoint F_cvg_txn.almostfull;
            cp_almostempty: coverpoint F_cvg_txn.almostempty;
            cp_underflow: coverpoint F_cvg_txn.underflow;
        
            // Cross coverage
            // Write Ack cross with ignored bins
            cx_wr_ack: cross cp_wr_en, cp_rd_en, cp_wr_ack {
                ignore_bins auto_wr_ack_0 = binsof(cp_wr_en) intersect {0} &&
                                               binsof(cp_rd_en) intersect {1} &&
                                               binsof(cp_wr_ack) intersect {1};
                ignore_bins auto_wr_ack_1 = binsof(cp_wr_en) intersect {0} &&
                                               binsof(cp_rd_en) intersect {0} &&
                                               binsof(cp_wr_ack) intersect {1};
                ignore_bins auto_wr_ack_2 = binsof(cp_wr_en) intersect {1} &&
                                               binsof(cp_rd_en) intersect {1} &&
                                               binsof(cp_wr_ack) intersect {0};
            }
            // Overflow cross with ignored bins
            cx_overflow: cross cp_wr_en, cp_rd_en, cp_overflow {
                ignore_bins auto_overflow_0 = binsof(cp_wr_en) intersect {0} &&
                                               binsof(cp_rd_en) intersect {1} &&
                                               binsof(cp_overflow) intersect {1};
                ignore_bins auto_overflow_1 = binsof(cp_wr_en) intersect {0} &&
                                               binsof(cp_rd_en) intersect {0} &&
                                               binsof(cp_overflow) intersect {1};
                ignore_bins auto_overflow_2 = binsof(cp_wr_en) intersect {1} &&
                                               binsof(cp_rd_en) intersect {1} &&
                                               binsof(cp_overflow) intersect {1};
            }
            // Full cross with ignored bins
            cx_full: cross cp_wr_en, cp_rd_en, cp_full {
                ignore_bins auto_full_0 = binsof(cp_wr_en) intersect {0} &&
                                          binsof(cp_rd_en) intersect {1} &&
                                          binsof(cp_full) intersect {1};
                ignore_bins auto_full_1 = binsof(cp_wr_en) intersect {1} &&
                                          binsof(cp_rd_en) intersect {1} &&
                                          binsof(cp_full) intersect {1};
            }
            // Empty cross coverage
            cx_empty: cross cp_wr_en, cp_rd_en, cp_empty;
        
            // Almost full cross coverage
            cx_almostfull: cross cp_wr_en, cp_rd_en, cp_almostfull;
        
            // Almost empty cross coverage
            cx_almostempty: cross cp_wr_en, cp_rd_en, cp_almostempty;
        
            // Underflow cross with ignored bins
            cx_underflow: cross cp_wr_en, cp_rd_en, cp_underflow {
                ignore_bins auto_underflow_0 = binsof(cp_wr_en) intersect {1} &&
                                               binsof(cp_rd_en) intersect {0} &&
                                               binsof(cp_underflow) intersect {1};
                ignore_bins auto_underflow_1 = binsof(cp_wr_en) intersect {0} &&
                                               binsof(cp_rd_en) intersect {0} &&
                                               binsof(cp_underflow) intersect {1};
            }
        endgroup: cg_FIFO
        
        function new;
            cg_FIFO = new;
            cg_FIFO.start();
        endfunction

        function void sample_data(FIFO_transaction F_txn);
            this.F_cvg_txn = F_txn;
            cg_FIFO.sample();
        endfunction
    endclass
endpackage