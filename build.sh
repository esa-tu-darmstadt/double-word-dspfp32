#!/bin/bash
mkdir -p done/

TOPS=(FPPlusFP DWPlusFP DWPlusDW_Sloppy DWPlusDW_Accurate FPTimesFP DWTimesFP_Fast DWTimesFP_Accurate DWTimesDW_Fast)
IDX=0
for TOP in "${TOPS[@]}"; do
    echo $TOP
	sed -i "2s/.*/module SUS_$TOP {/" dspfp32_dw_arith.sus
	sed -i "5s/.*/    gen int TYPE = $IDX/" dspfp32_dw_arith.sus
    IDX=$((IDX + 1))
	sus_compiler dspfp32_dw_arith.sus -o done/SUS_$TOP.sv --top SUS_$TOP
	cat dspfp32.sv >> done/SUS_$TOP.sv
done
