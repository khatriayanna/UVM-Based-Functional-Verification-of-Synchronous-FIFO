module fifo #(
  parameter DATA_WIDTH = 8,
  parameter DEPTH      = 16
)(
  input  logic                  clk,
  input  logic                  rst_n,
  input  logic                  wr_en,
  input  logic                  rd_en,
  input  logic [DATA_WIDTH-1:0] wr_data,
  output logic [DATA_WIDTH-1:0] rd_data,
  output logic                  full,
  output logic                  empty
);

  // Memory array
  logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];
  
  // Pointers
  logic [$clog2(DEPTH):0] wr_ptr;
  logic [$clog2(DEPTH):0] rd_ptr;
  logic [$clog2(DEPTH):0] count;

  // Full and Empty flags
  assign full  = (count == DEPTH);
  assign empty = (count == 0);

  // Write logic
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      wr_ptr <= 0;
    else if (wr_en && !full) begin
      mem[wr_ptr[$clog2(DEPTH)-1:0]] <= wr_data;
      wr_ptr <= wr_ptr + 1;
    end
  end

  // Read logic
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rd_ptr  <= 0;
      rd_data <= 0;
    end
    else if (rd_en && !empty) begin
      rd_data <= mem[rd_ptr[$clog2(DEPTH)-1:0]];
      rd_ptr  <= rd_ptr + 1;
    end
  end

  // Count logic
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      count <= 0;
    else begin
      case ({wr_en && !full, rd_en && !empty})
        2'b10:   count <= count + 1;
        2'b01:   count <= count - 1;
        default: count <= count;
      endcase
    end
  end

endmodule
