#!/bin/bash
cd /scratch/dv/2026/h2rc/workspace/hls/streamdw/

TOPS=(F32PlusF32 F64PlusF32 F64PlusF64 F32TimesF32 F64TimesF32 F64TimesF64 FPPlusFP DWPlusFP DWPlusDW_Sloppy DWPlusDW_Accurate FPTimesFP DWTimesFP_Fast DWTimesFP_Accurate DWTimesDW_Fast F32PlusF32toFP56 F56PlusF32 F56PlusF64 F32TimesF32toFP56 F56TimesF32 F56TimesF56)

IDX=0

mkdir -p ../core/ip

for TOP in "${TOPS[@]}"; do
    sed -i "7s/.*/syn.top=$TOP/" hls_config.cfg
    sed -i "5s/.*/#define SELECT $IDX/" streamdw.cpp
    IDX=$((IDX + 1))

    v++ -c --mode hls --config hls_config.cfg --work_dir "stream_$TOP"
    vitis-run --mode hls --package --config hls_config.cfg --work_dir "stream_$TOP"
    mkdir -p ../core/$TOP/
    cp stream_$TOP/$TOP.zip ../core/$TOP/
    cp stream_$TOP/hls/hls_data.json ../core/$TOP/
done

cd ../core
cp $(find -name **.zip) ip/
