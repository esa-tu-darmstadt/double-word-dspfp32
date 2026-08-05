#!/bin/bash
mkdir -p zip

TOPS=(FPPlusFP DWPlusFP DWPlusDW_Sloppy DWPlusDW_Accurate FPTimesFP DWTimesFP_Fast DWTimesFP_Accurate DWTimesDW_Fast)
for TOP in "${TOPS[@]}"; do
	rm -rf ipxact/
	python3 ipxact.py -f build/SUS_$TOP.sv
	mv ipxact/SUS_$TOP.zip zip/
done
