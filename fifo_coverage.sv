class fifo_coverage extends uvm_subscriber #(fifo_seq_item);
  `uvm_component_utils(fifo_coverage)

  fifo_seq_item trans;

  // Functional coverage group
  covergroup fifo_cg;
    // Cover write enable
    cp_wr_en: coverpoint trans.wr_en {
      bins write_active = {1};
      bins write_idle   = {0};
    }
    // Cover read enable
    cp_rd_en: coverpoint trans.rd_en {
      bins read_active = {1};
      bins read_idle   = {0};
    }
    // Cover FIFO status flags
    cp_full:  coverpoint trans.full  {bins full  = {1}; bins not_full  = {0};}
    cp_empty: coverpoint trans.empty {bins empty = {1}; bins not_empty = {0};}
    // Cross coverage — simultaneous read/write
    cx_rd_wr: cross cp_wr_en, cp_rd_en;
    // Cover boundary conditions
    cx_full_wr:  cross cp_wr_en,  cp_full;
    cx_empty_rd: cross cp_rd_en, cp_empty;
  endgroup

  function new(string name = "fifo_coverage", uvm_component parent = null);
    super.new(name, parent);
    fifo_cg = new();
  endfunction

  // Called automatically when monitor sends transaction
  function void write(fifo_seq_item t);
    trans = t;
    fifo_cg.sample();
  endfunction

  // Print coverage at end
  function void report_phase(uvm_phase phase);
    `uvm_info("COVERAGE",
      $sformatf("Functional Coverage: %0.2f%%",
      fifo_cg.get_coverage()), UVM_NONE)
  endfunction

endclass
