# H2RC

https://github.com/esa-tu-darmstadt/twofloat

## TODO:

DSP

Mult
- correct dsp use
- optimize

Add
- dsp carry
- optimize
- Verify results

HLS

### Double-word arithmetic (Joldes et al. 2017)

The double-word arithmetic by Joldes et al. provides error bounds for each operation. The error bounds are given in units u of the roundoff error of the underlying floating-point type (see table above). For example, when using `two<float>`, u is equal to u<sub>float</sub>. 

The number of floating-point operations (FP ops) required for each operation is different to Table 1 in Joldes et al. 2017 for several reasons:
- We take negations and comparisons into account
- The non-FMA algorithms use the non-FMA version of the `TwoProd` algorithm, which requires significantly more FP ops than the FMA version (called `FastTwoProd`). This is more realistic because if an FMA is available, the user will likely use the FMA version.

| Operation   | FMA | Mode     | Error bound formally proved     | # of FP ops | Name in Joldes et al. 2017     | 
| ----------- | --- | -------- | ------------------------------- | ----------- | ------------------------------ |
| DW **+** FP | No  |          | 2u<sup>2</sup>                  | 10          | Algorithm 4 (DWPlusFP)         |
| DW **+** DW | No  | Sloppy   | N/A                             | 11          | Algorithm 5 (SloppyDWPlusDW)   |
| DW **+** DW | No  | Accurate | 3u<sup>2</sup>+13u<sup>3</sup>  | 20          | Algorithm 6 (AccurateDWPlusDW) |
| DW **x** FP | No  | Accurate | 1.5u<sup>2</sup>+4u<sup>3</sup> | 29          | Algorithm 7 (DWTimesFP1)       |
| DW **x** FP | No  | Fast     | 3u<sup>2</sup>                  | 23          | Algorithm 8 (DWTimesFP2)       |
| DW **x** DW | No  | Fast     | 7u<sup>2</sup>                  | 28          | Algorithm 10 (DWTimesDW1)      |

DW: Double-word (`two<T>`), FP: Floating-point (`T`)

## Resources

**SUS**

| Operation   | FMAX | FF   | LUT  | SLICES | DSP | Name in Joldes et al. 2017     | 
| ----------- | ---- | ---- | ---- | ------ | --- | ------------------------------ |
| DW **+** FP |      |      |      |        |  10 | Algorithm 4 (DWPlusFP)         |
| DW **+** DW |      |      |      |        |  11 | Algorithm 5 (SloppyDWPlusDW)   |
| DW **+** DW |  470 |  128 |   32 |      8 |  20 | Algorithm 6 (AccurateDWPlusDW) |
| DW **x** FP |      |      |      |        |  29 | Algorithm 7 (DWTimesFP1)       |
| DW **x** FP |      |      |      |        |  23 | Algorithm 8 (DWTimesFP2)       |
| DW **x** DW |      |      |      |        |  28 | Algorithm 10 (DWTimesDW1)      |

**HLS**

| Operation   | FMAX | FF   | LUT  | SLICES | DSP | Name in Joldes et al. 2017     | 
| ----------- | ---- | ---- | ---- | ------ | --- | ------------------------------ |
| DW **+** FP |      |      |      |        |  10 | Algorithm 4 (DWPlusFP)         |
| DW **+** DW |      |      |      |        |  11 | Algorithm 5 (SloppyDWPlusDW)   |
| DW **+** DW |      | 2538 |  865 |    264 |  20 | Algorithm 6 (AccurateDWPlusDW) |
| DW **x** FP |      |      |      |        |  29 | Algorithm 7 (DWTimesFP1)       |
| DW **x** FP |      |      |      |        |  23 | Algorithm 8 (DWTimesFP2)       |
| DW **x** DW |      |      |      |        |  28 | Algorithm 10 (DWTimesDW1)      |

**HLS**

| Operation   | FMAX | FF   | LUT  | SLICES | DSP |
| ----------- | ---- | ---- | ---- | ------ | --- |
| DW **+** FP |      |      |      |        |     |
| DW **+** DW |      | 1710 |  983 |    207 |   0 |
| DW **x** FP |      |      |      |        |     |
| DW **x** DW |      |      |      |        |     |
