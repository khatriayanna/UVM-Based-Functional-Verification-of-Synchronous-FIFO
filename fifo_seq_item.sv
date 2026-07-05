class fifo_seq_item extends uvm_sequence_item;

  // UVM automation macros
  `uvm_object_utils_begin(fifo_seq_item)
    `uvm_field_int(wr_en,   UVM_ALL_ON)
    `uvm_field_int(rd_en,   UVM_ALL_ON)
    `uvm_field_int(wr_data, UVM_ALL_ON)
    `uvm_field_int(rd_data, UVM_ALL_ON)
    `uvm_field_int(full,    UVM_ALL_ON)
    `uvm_field_int(empty,   UVM_ALL_ON)
  `uvm_object_utils_end

  // Stimulus fields — driven into DUT
  rand logic       wr_en;
  rand logic       rd_en;
  rand logic [7:0] wr_data;

  // Observed fields — sampled from DUT
  logic [7:0] rd_data;
  logic       full;
  logic       empty;

  // Constraints
  // Prevent simultaneous write to full FIFO
  // and read from empty FIFO
  constraint valid_op_c {
    !(wr_en == 1 && full  == 1);
    !(rd_en == 1 && empty == 1);
  }

  // Weight write operations more than reads
  // to fill FIFO and observe full condition
  constraint wr_weight_c {
    wr_en dist {1 := 70, 0 := 30};
  }

  // Constructor
  function new(string name = "fifo_seq_item");
    super.new(name);
  endfunction

  // Print transaction details — useful for debug
  function string convert2string();
    return $sformatf(
      "wr_en=%0b rd_en=%0b wr_data=0x%0h rd_data=0x%0h full=%0b empty=%0b",
      wr_en, rd_en, wr_data, rd_data, full, empty
    );
  endfunction

endclass
