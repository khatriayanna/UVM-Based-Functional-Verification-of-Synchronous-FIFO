class fifo_driver extends uvm_driver #(fifo_seq_item);
  `uvm_component_utils(fifo_driver)

  // Virtual interface handle
  virtual fifo_if #(.DATA_WIDTH(8)) vif;

  function new(string name = "fifo_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Get interface from config DB
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual fifo_if #(.DATA_WIDTH(8)))::get(
      this, "", "vif", vif))
      `uvm_fatal("NO_VIF", "Driver: Virtual interface not found in config DB")
  endfunction

  // Main run loop — get item, drive it, repeat
  task run_phase(uvm_phase phase);
    fifo_seq_item req;
    // Initialize all signals
    vif.driver_cb.wr_en   <= 0;
    vif.driver_cb.rd_en   <= 0;
    vif.driver_cb.wr_data <= 0;
    vif.driver_cb.rst_n   <= 0;
    // Apply reset for 5 cycles
    repeat(5) @(vif.driver_cb);
    vif.driver_cb.rst_n <= 1;
    forever begin
      seq_item_port.get_next_item(req);
      drive_item(req);
      seq_item_port.item_done();
    end
  endtask

  // Drive one transaction onto interface
  task drive_item(fifo_seq_item req);
    @(vif.driver_cb);
    vif.driver_cb.wr_en   <= req.wr_en;
    vif.driver_cb.rd_en   <= req.rd_en;
    vif.driver_cb.wr_data <= req.wr_data;
  endtask

endclass
