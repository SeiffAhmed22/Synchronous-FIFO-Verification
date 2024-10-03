////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_it.DUT FIFOit);
localparam max_fifo_addr = $clog2(FIFOit.FIFO_DEPTH);
reg [FIFOit.FIFO_WIDTH-1:0] mem [FIFOit.FIFO_DEPTH-1:0];
reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;
always @(posedge FIFOit.clk or negedge FIFOit.rst_n) begin
	if (!FIFOit.rst_n) begin
		wr_ptr <= 0;
	end
	else if (FIFOit.wr_en && count < FIFOit.FIFO_DEPTH) begin
		mem[wr_ptr] <= FIFOit.data_in;
		// FIFOit.wr_ack <= 1; // BUG HERE
		wr_ptr <= wr_ptr + 1;
	end
	// BUG HERE
	// else begin 
	// 	FIFOit.wr_ack <= 0;
	// 	if (FIFOit.full & FIFOit.wr_en)
	// 		FIFOit.overflow <= 1;
	// 	else
	// 		FIFOit.overflow <= 0;
	// end
end
always @(posedge FIFOit.clk or negedge FIFOit.rst_n) begin
	if (!FIFOit.rst_n) begin
		rd_ptr <= 0;
	end
	else if (FIFOit.rd_en && count != 0) begin
		FIFOit.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
end
always @(posedge FIFOit.clk or negedge FIFOit.rst_n) begin
	if (!FIFOit.rst_n) begin
		count <= 0;
	end
	else begin
		if	((({FIFOit.wr_en, FIFOit.rd_en} == 2'b10) && !FIFOit.full) || 
		(({FIFOit.wr_en, FIFOit.rd_en} == 2'b11) && FIFOit.empty)) // Added the part for the note
			count <= count + 1;
		else if ((({FIFOit.wr_en, FIFOit.rd_en} == 2'b01) && !FIFOit.empty) || 
		(({FIFOit.wr_en, FIFOit.rd_en} == 2'b11) && FIFOit.full)) // Added the part for the note
			count <= count - 1;
	end
end
assign FIFOit.full = (count == FIFOit.FIFO_DEPTH)? 1 : 0;
assign FIFOit.empty = (count == 0)? 1 : 0;
assign FIFOit.underflow = (FIFOit.empty && FIFOit.rd_en)? 1 : 0; 
// assign FIFOit.almostfull = (count == FIFOit.FIFO_DEPTH-2)? 1 : 0; // BUG HERE
assign FIFOit.almostempty = (count == 1)? 1 : 0;
// Fixed bugs
assign FIFOit.wr_ack = ((count != FIFOit.FIFO_DEPTH) && FIFOit.wr_en)? 1 : 0;
assign FIFOit.almostfull = (count == FIFOit.FIFO_DEPTH - 1)? 1 : 0;
assign FIFOit.overflow = (FIFOit.full && FIFOit.wr_en)? 1 : 0;

`ifdef SIM
	property write_count;
		@(posedge FIFOit.clk) disable iff(!FIFOit.rst_n) 
		(!FIFOit.rd_en && FIFOit.wr_en && count != FIFOit.FIFO_DEPTH) |=> ($past(count) + 1'b1 == count);
	endproperty
	property read_count;
		@(posedge FIFOit.clk) disable iff(!FIFOit.rst_n) 
		(FIFOit.rd_en && !FIFOit.wr_en && count != 0) |=> ($past(count) - 1'b1 == count);
	endproperty
	property read_write_count;
		@(posedge FIFOit.clk) disable iff(!FIFOit.rst_n) 
		(FIFOit.rd_en && FIFOit.wr_en && count != 0 && count != FIFOit.FIFO_DEPTH) |=> ($past(count) == count);
	endproperty
	property read_write_count_empty;
		@(posedge FIFOit.clk) disable iff(!FIFOit.rst_n) 
	 	(FIFOit.rd_en && FIFOit.wr_en && FIFOit.empty) |=> ($past(count) + 1'b1 == count);
	endproperty
	property read_write_count_full;
		@(posedge FIFOit.clk) disable iff(!FIFOit.rst_n) 
	 	(FIFOit.rd_en && FIFOit.wr_en && FIFOit.full) |=> ($past(count) - 1'b1 == count);
	endproperty
	property write_ptr;
		@(posedge FIFOit.clk) disable iff (!FIFOit.rst_n) 
		(FIFOit.wr_en && count != FIFOit.FIFO_DEPTH) |=> ($past(wr_ptr) + 1'b1 == wr_ptr);
	endproperty
	property read_ptr;
		@(posedge FIFOit.clk) disable iff (!FIFOit.rst_n)
		(FIFOit.rd_en && count != 0) |=> ($past(rd_ptr) + 1'b1 == rd_ptr);
	endproperty
	// Assertions
	wr_count_assert: assert property (write_count)
		else $error("Assertion failed: count did not increment when write correctly at time %0t, count = %0d, expected = %0d", 
						$time, count, $past(count) + 1'b1);
	rd_count_assert: assert property (read_count)
		else $error("Assertion failed: count did not decrement when read correctly at time %0t, count = %0d, expected = %0d", 
						$time, count, $past(count) - 1'b1);
	rd_wr_count_assert: assert property (read_write_count)
		else $error("Assertion failed: count should remain the same when read and write, and not empty or full at time %0t, count = %0d, expected = %0d", 
						$time, count, $past(count));
	rd_wr_count_empty_assert:assert property (read_write_count_empty)
		else $error("Assertion failed: count did not increment when write, read and empty correctly at time %0t, count = %0d, expected = %0d", 
						$time, count, $past(count) + 1'b1);
	rd_wr_count_full_assert:assert property (read_write_count_full)
		else $error("Assertion failed: count did not increment when write, read and full correctly at time %0t, count = %0d, expected = %0d", 
						$time, count, $past(count) - 1'b1);
	wr_ptr_assert: assert property (write_ptr)
		else $error("Assertion failed: wr_ptr did not increment correctly at time %0t, wr_ptr = %0d, expected = %0d", 
						$time, wr_ptr, $past(wr_ptr) + 1'b1);
	rd_ptr_assert: assert property (read_ptr)
		else $error("Assertion failed: rd_ptr did not increment correctly at time %0t, rd_ptr = %0d, expected = %0d", 
						$time, rd_ptr, $past(rd_ptr) + 1'b1);
	
	// Cover Assertions
	wr_count_cover: cover property (write_count);
	rd_count_cover: cover property (read_count);
	rd_wr_count_cover: cover property (read_write_count);
	rd_wr_count_empty_cover:cover property (read_write_count_empty);
	rd_wr_count_full_cover:cover property (read_write_count_full);
	wr_ptr_cover: cover property (write_ptr);
	rd_ptr_cover: cover property (read_ptr);

	always_comb begin
		if(!FIFOit.rst_n)begin
			rst_count_assert: assert final (count==0);
			rst_count_cover: cover final (count==0);

			rst_wr_ptr_assert: assert final (wr_ptr==0);
			rst_wr_ptr_cover: cover final (wr_ptr==0);

			rst_rd_ptr_assert: assert final (rd_ptr==0);
			rst_rd_ptr_cover: cover final (rd_ptr==0);
		end
		if(count == FIFOit.FIFO_DEPTH) begin
			full_assert: assert final (FIFOit.full);
			full_cover: cover final (FIFOit.full);
		end
		if(count == 0) begin
			empty_assert: assert final (FIFOit.empty);
			empty_cover: cover final (FIFOit.empty);
		end
		if(count == 0 && FIFOit.rd_en) begin
			underflow_assert: assert final (FIFOit.underflow);
			underflow_cover: cover final (FIFOit.underflow);
		end
		if(count == FIFOit.FIFO_DEPTH && FIFOit.wr_en) begin
			overflow_assert: assert final (FIFOit.overflow);
			overflow_cover: cover final (FIFOit.overflow);
		end
		if(count == FIFOit.FIFO_DEPTH - 1) begin
			almostfull_assert: assert final (FIFOit.almostfull);
			almostfull_cover: cover final (FIFOit.almostfull);
		end
		if(count == 1) begin
			almostempty_assert: assert final (FIFOit.almostempty);
			almostempty_cover: cover final (FIFOit.almostempty);
		end
		if((count != FIFOit.FIFO_DEPTH) && FIFOit.wr_en) begin
			wr_ack_assert: assert final (FIFOit.wr_ack);
			wr_ack_cover: cover final (FIFOit.wr_ack);
		end
	end
`endif
endmodule