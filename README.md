# Synchronous FIFO Verification

This repository contains the **SystemVerilog-based verification** environment for a Synchronous FIFO design. The verification focuses on thoroughly testing the FIFO’s functionality using constrained randomization, functional coverage, and assertions.

## Project Description
The full project description is attached in this repository for more detailed information on the design, testbench structure, and verification flow.

## File Structure

- **FIFO.sv**: The Synchronous FIFO design with configurable width and depth.
- **FIFO_coverage.sv**: Functional coverage module to track cross-coverage between read, write, and output signals.
- **FIFO_it.sv**: Interface for connecting the testbench, monitor, and scoreboard to the FIFO design.
- **FIFO_monitor.sv**: Monitor module that samples data from the DUT and passes it to the coverage and scoreboard classes.
- **FIFO_scoreboard.sv**: Scoreboard module containing a reference model to compare expected and actual results.
- **FIFO_test.sv**: Testbench is used to generate a stimulus, initialize, and control the simulation flow.
- **FIFO_transaction.sv**: Transaction class that holds randomized input data and defines constraints for FIFO operations.
- **shared_pkg.sv**: Shared package defining constants, utility functions, and the transaction class for reuse across modules.
- **src_files.list**: File containing the list of source files for easier simulation setup.
- **FIFO.do**: Script for automating the simulation process with a single command.
- **top.sv**: Top-level module for connecting all components of the testbench and DUT.

## How to Run

1. **Setup**: Ensure you have a SystemVerilog simulator (e.g., QuestaSim) properly configured.
2. **Simulation**:
   - Run the provided `FIFO.do` script to compile and simulate the design.
   - Use the following command:
     ```bash
     do FIFO.do
     ```
3. **Testbench Flow**: 
   - The testbench will reset the FIFO, randomize the inputs, and apply the stimulus.
   - The monitor samples data and verifies it against the reference model.
   - Coverage data is collected for thorough verification.
   - The test will stop automatically once finished, displaying a summary of correct vs. incorrect operations.

## Assertions

The FIFO design file includes assertions to validate output signals and internal counters during simulation. These are conditionally compiled using the `SIM` macro and can be controlled by passing the `+define+SIM` option during compilation.

