#!/bin/bash
mkdir -p build/zip

TOPS=(FPPlusFP DWPlusFP DWPlusDW_Sloppy DWPlusDW_Accurate FPTimesFP DWTimesFP_Fast DWTimesFP_Accurate DWTimesDW_Fast)
for TOP in "${TOPS[@]}"; do
	rm -rf build/ipxact/
	python3 ipxact.py -f build/SUS_$TOP.sv
	mv build/ipxact/SUS_$TOP.zip build/zip/
done
