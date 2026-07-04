# UVM-Based Functional Verification of Synchronous FIFO
A complete UVM (Universal Verification Methodology) testbench 
environment for verifying a parameterized synchronous FIFO design, 
built using SystemVerilog and simulated on Aldec Riviera-PRO via 
EDA Playground.

## Architecture
tb_top
└── fifo_base_test
└── fifo_env
├── fifo_agent
│     ├── uvm_sequencer ← fifo_base_seq
│     ├── fifo_driver   → fifo_if → DUT
│     └── fifo_monitor  ← fifo_if ← DUT
├── fifo_scoreboard (correctness checking)
└── fifo_coverage   (functional coverage)

## DUT Specifications
| Parameter  | Value         |
|------------|---------------|
| Data Width | 8-bit         |
| FIFO Depth | 16 entries    |
| Type       | Synchronous   |
| Reset      | Active-low    |
| Clock      | 100 MHz       |

## Verification Environment — File
| File                | Description                                      |
|---------------------|--------------------------------------------------|
| `fifo.v`            | DUT — Parameterized synchronous FIFO             |
| `fifo_if.sv`        | Interface with clocking blocks and modports      |
| `fifo_seq_item.sv`  | Transaction class with constraints               |
| `fifo_driver.sv`    | Drives randomized transactions into DUT          |
| `fifo_monitor.sv`   | Observes DUT signals, sends to scoreboard        |
| `fifo_scoreboard.sv`| Reference model, checks DUT output correctness  |
| `fifo_coverage.sv`  | Functional coverage collector                    |
| `fifo_agent.sv`     | Encapsulates driver, monitor, sequencer          |
| `fifo_sequence.sv`  | Base, write-only, and read-only sequences        |
| `fifo_env.sv`       | Top-level environment                            |
| `fifo_test.sv`      | Base test and write-read test                    |
| `tb_top.sv`         | Top-level testbench module                       |

## Verification Features
- Constrained random stimulus generation
- Protocol-level constraints (no write-to-full, no read-from-empty)
- Weighted randomization (70% writes, 30% reads)
- Self-checking scoreboard with reference queue model
- Functional coverage including cross coverage
- Multiple test scenarios:
  - Random read/write test (50 transactions)
  - Write-then-read test (fill then drain FIFO)
- Boundary condition checking (full/empty flag verification)

## How to Run
1. Open [EDA Playground] 
2. Load all files from this repository
3. Select **Aldec Riviera-PRO** as simulator
4. Select **UVM 1.2**
5. Set top module to **tb_top**
6. Click **Run**

## Results
- ✅ All transactions verified by scoreboard (FAIL = 0)
- ✅ Functional coverage achieved
- ✅ Full and empty flag boundary conditions verified

## Tools Used
- Language: SystemVerilog (UVM 1.2)
- Simulator: Aldec Riviera-PRO (EDA Playground)
- Methodology: Universal Verification Methodology (UVM)
