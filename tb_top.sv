`include "uvm_macros.svh"
import uvm_pkg::*;

`include "fifo_seq_item.sv"
`include "fifo_driver.sv"
`include "fifo_monitor.sv"
`include "fifo_scoreboard.sv"
`include "fifo_coverage.sv"
`include "fifo_agent.sv"
`include "fifo_sequence.sv"
`include "fifo_env.sv"
`include "fifo_test.sv"

module tb_top;

  // Clock generation
  logic clk;
  initial clk = 0;
  always #5 clk = ~clk; // 100MHz clock

  // Interface instantiation
  fifo_if #(.DATA_WIDTH(8)) dut_if(.clk(clk));

  // DUT instantiation
  fifo #(
    .DATA_WIDTH(8),
    .DEPTH(16)
  ) dut (
    .clk     (clk),
    .rst_n   (dut_if.rst_n),
    .wr_en   (dut_if.wr_en),
    .rd_en   (dut_if.rd_en),
    .wr_data (dut_if.wr_data),
    .rd_data (dut_if.rd_data),
    .full    (dut_if.full),
    .empty   (dut_if.empty)
  );

  // Pass interface to UVM config DB
  initial begin
    uvm_config_db #(virtual fifo_if #(.DATA_WIDTH(8)))::set(
      null, "uvm_test_top.*", "vif", dut_if);
    // Run the test
    run_test("fifo_base_test");
  end

  // Timeout watchdog
  initial begin
    #10000;
    `uvm_fatal("TIMEOUT", "Simulation exceeded 10000ns")
  end

endmodule
