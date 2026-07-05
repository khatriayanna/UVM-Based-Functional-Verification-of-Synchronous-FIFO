class fifo_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fifo_scoreboard)

  // Receives transactions from monitor
  uvm_analysis_imp #(fifo_seq_item, fifo_scoreboard) analysis_export;

  // Reference model — mimics expected FIFO behavior
  logic [7:0] ref_mem [$]; // SystemVerilog queue as reference FIFO
  int         pass_count;
  int         fail_count;

  function new(string name = "fifo_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    analysis_export = new("analysis_export", this);
    pass_count = 0;
    fail_count = 0;
  endfunction

  // Called automatically every time monitor writes a transaction
  function void write(fifo_seq_item trans);
    // Write operation — push to reference queue
    if(trans.wr_en && !trans.full)
      ref_mem.push_back(trans.wr_data);

    // Read operation — compare DUT output vs reference
    if(trans.rd_en && !trans.empty) begin
      if(ref_mem.size() > 0) begin
        logic [7:0] expected = ref_mem.pop_front();
        if(trans.rd_data === expected) begin
          pass_count++;
          `uvm_info("SCOREBOARD",
            $sformatf("PASS: Expected=0x%0h Got=0x%0h",
            expected, trans.rd_data), UVM_LOW)
        end
        else begin
          fail_count++;
          `uvm_error("SCOREBOARD",
            $sformatf("FAIL: Expected=0x%0h Got=0x%0h",
            expected, trans.rd_data))
        end
      end
    end

    // Check full/empty flags
    if(trans.full && ref_mem.size() != 16)
      `uvm_error("SCOREBOARD", "Full flag asserted incorrectly")
    if(trans.empty && ref_mem.size() != 0)
      `uvm_error("SCOREBOARD", "Empty flag asserted incorrectly")
  endfunction

  // Print final results
  function void report_phase(uvm_phase phase);
    `uvm_info("SCOREBOARD",
      $sformatf("\n=== RESULTS: PASS=%0d FAIL=%0d ===",
      pass_count, fail_count), UVM_NONE)
  endfunction

endclass
