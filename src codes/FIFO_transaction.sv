package FIFO_transaction_pkg;
  parameter FIFO_WIDTH = 16;
  class FIFO_transaction;
    rand bit [FIFO_WIDTH-1:0] data_in;
    rand bit rst_n, wr_en, rd_en;
    bit [FIFO_WIDTH-1:0] data_out;
    bit wr_ack, overflow;
    bit full, empty, almostfull, almostempty, underflow;

    int RD_EN_ON_DIST;
    int WR_EN_ON_DIST;

    function new(int RD_EN_ON_DIST = 30, int WR_EN_ON_DIST = 70);
      this.RD_EN_ON_DIST = RD_EN_ON_DIST;
      this.WR_EN_ON_DIST = WR_EN_ON_DIST;
    endfunction

    constraint reset_con {
      rst_n dist {
        0 :/ 10,
        1 :/ 90
      };
    }

    constraint wr_en_con {
      wr_en dist {
        1 :/ WR_EN_ON_DIST,
        0 :/ (100 - WR_EN_ON_DIST)
      };
    }

    constraint rd_en_con {
      rd_en dist {
        1 :/ RD_EN_ON_DIST,
        0 :/ (100 - RD_EN_ON_DIST)
      };
    }
  endclass
endpackage