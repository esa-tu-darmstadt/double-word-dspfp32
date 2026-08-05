#!/bin/bash
mkdir -p done/

TOPS=(FPPlusFP DWPlusFP DWPlusDW_Sloppy DWPlusDW_Accurate FPTimesFP DWTimesFP_Fast DWTimesFP_Accurate DWTimesDW_Fast)
IDX=0
for TOP in "${TOPS[@]}"; do
    echo $TOP
	sed -i "2s/.*/module SUS_$TOP {/" hhrc.sus
	sed -i "5s/.*/    gen int TYPE = $IDX/" hhrc.sus
    IDX=$((IDX + 1))
	sus_compiler hhrc.sus -o done/SUS_$TOP.sv --top SUS_$TOP
	cat dspfp32.sv >> done/SUS_$TOP.sv
done
