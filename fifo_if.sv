interface fifo_if #(
  parameter DATA_WIDTH = 8
)(
  input logic clk
);

  // Signals connecting DUT to testbench
  logic                  rst_n;
  logic                  wr_en;
  logic                  rd_en;
  logic [DATA_WIDTH-1:0] wr_data;
  logic [DATA_WIDTH-1:0] rd_data;
  logic                  full;
  logic                  empty;

  // Clocking block for driver
  // Defines timing: drive inputs 1ns after clock edge
  clocking driver_cb @(posedge clk);
    default input #1 output #1;
    output rst_n;
    output wr_en;
    output rd_en;
    output wr_data;
    input  rd_data;
    input  full;
    input  empty;
  endclocking

  // Clocking block for monitor
  // Monitor only observes — never drives
  clocking monitor_cb @(posedge clk);
    default input #1 output #1;
    input rst_n;
    input wr_en;
    input rd_en;
    input wr_data;
    input rd_data;
    input full;
    input empty;
  endclocking

  // Modports — define perspective for each actor
  modport DRIVER  (clocking driver_cb,  input clk);
  modport MONITOR (clocking monitor_cb, input clk);

endinterface
