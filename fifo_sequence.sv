class fifo_base_seq extends uvm_sequence #(fifo_seq_item);
  `uvm_object_utils(fifo_base_seq)

  function new(string name = "fifo_base_seq");
    super.new(name);
  endfunction

  // Send 50 random transactions
  task body();
    fifo_seq_item item;
    repeat(50) begin
      item = fifo_seq_item::type_id::create("item");
      start_item(item);
      if(!item.randomize())
        `uvm_fatal("RAND_FAIL", "Randomization failed")
      finish_item(item);
    end
  endtask

endclass

// Write-only sequence — fills FIFO completely
class fifo_write_seq extends uvm_sequence #(fifo_seq_item);
  `uvm_object_utils(fifo_write_seq)

  function new(string name = "fifo_write_seq");
    super.new(name);
  endfunction

  task body();
    fifo_seq_item item;
    repeat(20) begin
      item = fifo_seq_item::type_id::create("item");
      start_item(item);
      if(!item.randomize() with {wr_en == 1; rd_en == 0;})
        `uvm_fatal("RAND_FAIL", "Randomization failed")
      finish_item(item);
    end
  endtask

endclass

// Read-only sequence — drains FIFO completely
class fifo_read_seq extends uvm_sequence #(fifo_seq_item);
  `uvm_object_utils(fifo_read_seq)

  function new(string name = "fifo_read_seq");
    super.new(name);
  endfunction

  task body();
    fifo_seq_item item;
    repeat(20) begin
      item = fifo_seq_item::type_id::create("item");
      start_item(item);
      if(!item.randomize() with {wr_en == 0; rd_en == 1;})
        `uvm_fatal("RAND_FAIL", "Randomization failed")
      finish_item(item);
    end
  endtask

endclass
