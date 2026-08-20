# Double-Word DSPFP32

This is a collection of highly optimized hardware modules for double-word arithmetic on Versal FPGA.
Each double-word algorithm was carefully mapped onto the DSPFP32 primitive, which natively support FP32 mul and add operations.
The resulting hardware achieves very low LUT and FF utilization and high $F_{max}$.

## Build

Building the SystemVerilog modules requires the `sus_compiler` (https://sus-lang.org/installation/).

```sh
make build
```

The resulting modules can be found in `build/`.

## Supported Double-word Operations

Since the DSPFP32 available on Versal only support FP32 mul and add, this collection is limited to the double-word algorithms only using these operations.

| Operation   | FMAX | FF   | LUT  | DSP | Name in Joldes et al. 2017     | 
| ----------- | ---- | ---- | ---- | --- | ------------------------------ |
| FP **+** FP |  570 |      |      |  10 | Algorithm 4 ()         |
| DW **+** FP |  570 |      |      |  10 | Algorithm 4 (DWPlusFP)         |
| DW **+** DW |  570 |      |      |  11 | Algorithm 5 (SloppyDWPlusDW)   |
| DW **+** DW |  570 |  128 |   32 |  20 | Algorithm 6 (AccurateDWPlusDW) |
| FP **x** FP |  570 |      |      |  29 | Algorithm 7 ()       |
| DW **x** FP |  570 |      |      |  29 | Algorithm 7 (DWTimesFP1)       |
| DW **x** FP |  570 |      |      |  23 | Algorithm 8 (DWTimesFP2)       |
| DW **x** DW |  570 |      |      |  28 | Algorithm 10 (DWTimesDW1)      |

DW: Double-word, FP: Floating-point

## Reference

`main.cpp` contains a C++ reference implementation also used to generate test data.

```sh
make test_data
make test_bench
```

## Polynomial

`polynomial.sus` serves as a short example on how to combine multiple double-word operations to form a larger computation.
It computes a 10th-degree polynomial at $II=1$.

```sh
make polynomial
```
