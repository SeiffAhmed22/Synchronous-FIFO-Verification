package FIFO_scoreboard_pkg;
  import FIFO_transaction_pkg::*;
  import shared_pkg::*;

  class FIFO_scoreboard #(
      FIFO_WIDTH = 16,
      FIFO_DEPTH = 8
  );
    localparam max_fifo_addr = $clog2(FIFO_DEPTH);

    bit [FIFO_WIDTH-1:0] data_out_ref;

    bit [FIFO_WIDTH - 1 : 0] fifo_mem[FIFO_DEPTH-1:0];

    bit [max_fifo_addr - 1 : 0] write_ptr, read_ptr;
    bit [max_fifo_addr : 0] count;

    function void reference_model(FIFO_transaction trans_obj); 
        if (!trans_obj.rst_n) begin
            read_ptr = 0;
            write_ptr = 0;
            count = 0;
        end
        else begin
            if (trans_obj.rd_en && count != 0) begin
                data_out_ref = fifo_mem[read_ptr];
                read_ptr++;
            end
            if (trans_obj.wr_en && count != FIFO_DEPTH) begin
                fifo_mem[write_ptr] = trans_obj.data_in;
                write_ptr++;
            end
            if((trans_obj.wr_en && !trans_obj.rd_en && count != FIFO_DEPTH) || 
            (trans_obj.wr_en && trans_obj.rd_en && count == 0))begin
                count++; 
            end 
            if((!trans_obj.wr_en && trans_obj.rd_en && count != 0) || 
            (trans_obj.wr_en && trans_obj.rd_en && count == FIFO_DEPTH)) begin
                count--;
            end 
        end
    endfunction

    function void check_data(FIFO_transaction trans_obj);
        reference_model(trans_obj);
        if(trans_obj.data_out != data_out_ref) begin
            $display("Error at time = %0t: data_out mismatch: Expected = %0h, Got = %0h", 
                        $time, data_out_ref, trans_obj.data_out);
            shared_pkg::error_count++;
        end else begin
            $display("Correct at time = %0t!", $time);
            shared_pkg::correct_count++;
        end
    endfunction    
  endclass
endpackage