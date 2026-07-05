class fifo_agent extends uvm_agent;
  `uvm_component_utils(fifo_agent)

  fifo_driver  driver;
  fifo_monitor monitor;
  uvm_sequencer #(fifo_seq_item) sequencer;

  function new(string name = "fifo_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor   = fifo_monitor::type_id::create("monitor", this);
    // Only create driver and sequencer for active agent
    if(get_is_active() == UVM_ACTIVE) begin
      driver    = fifo_driver::type_id::create("driver", this);
      sequencer = uvm_sequencer #(fifo_seq_item)::type_id::create(
                  "sequencer", this);
    end
  endfunction

  // Connect driver to sequencer
  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE)
      driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction

endclass
