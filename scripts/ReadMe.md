# Scripts

These are some helper scripts and an HLS implementation for doing various tests and comparisons with the generated modules.

## Vitis HLS

These files implement the same double-word algorithms and equivalent conventional floating-point operations: `polynomial.cpp`, `streamdw.cpp`, `hls_config.cfg`.
Using Vitis HLS, the can be synthesized by running `cmd.sh`.


## Vivado

`generate.tcl` contains helper functions for generating connections between the AXI4-Stream NoC on Versal FPGAs and the double-word modules.
