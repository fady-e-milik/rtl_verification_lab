# RTL Verification Lab

A small SystemVerilog project demonstrating RTL design and automated simulation-based verification.

## Modules

- `mux4`: 4-bit, 2-to-1 multiplexer
- `alu4`: 4-bit ADD, SUB, AND, OR unit
- `comparator4`: equality, less-than, and greater-than outputs
- `register4`: 4-bit positive-edge-triggered register with synchronous reset and enable

## Requirements

- Icarus Verilog 12 or another compatible SystemVerilog simulator

## Run the testbench

From the repository directory, compile and run:

```bash
mkdir -p build
iverilog -g2012 -Wall -s tb -o build/rtl_lab.vvp rtl/rtl_lab.sv tb/tb.sv
vvp build/rtl_lab.vvp
```

The testbench exhaustively checks the combinational modules and checks reset, write, and hold behavior for the register.

## Scope

This project demonstrates RTL coding and simulation-based verification. It does not claim FPGA implementation, physical silicon validation, or formal verification.
