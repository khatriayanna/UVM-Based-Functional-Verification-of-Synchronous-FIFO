class fifo_monitor extends uvm_monitor;
  `uvm_component_utils(fifo_monitor)

  virtual fifo_if #(.DATA_WIDTH(8)) vif;

  // Analysis port — sends transactions to scoreboard
  uvm_analysis_port #(fifo_seq_item) ap;

  function new(string name = "fifo_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap", this);
    if(!uvm_config_db #(virtual fifo_if #(.DATA_WIDTH(8)))::get(
      this, "", "vif", vif))
      `uvm_fatal("NO_VIF", "Monitor: Virtual interface not found in config DB")
  endfunction

  // Continuously sample DUT outputs every clock
  task run_phase(uvm_phase phase);
    fifo_seq_item trans;
    forever begin
      @(vif.monitor_cb);
      trans = fifo_seq_item::type_id::create("trans");
      // Capture driven inputs
      trans.wr_en   = vif.monitor_cb.wr_en;
      trans.rd_en   = vif.monitor_cb.rd_en;
      trans.wr_data = vif.monitor_cb.wr_data;
      // Capture DUT outputs
      trans.rd_data = vif.monitor_cb.rd_data;
      trans.full    = vif.monitor_cb.full;
      trans.empty   = vif.monitor_cb.empty;
      // Send to scoreboard
      ap.write(trans);
    end
  endtask

endclass
