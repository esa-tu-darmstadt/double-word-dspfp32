BIN_DIR = build

TOP = SUS_DWTimesDW_Fast

FILES := 
FILES += dspfp32_dw_arith.sus
FILES += polynomial.sus

v80/%: BIN_DIR ?= v80
v80/%: PART := xcv80-lsva4737-2MHP-e-S

build:
	./build.sh

polynomial:
	mkdir -p $(BIN_DIR)
	sus_compiler $(FILES) -o $(BIN_DIR)/polynomial.sv --top polynomial
	cat dspfp32.sv >> $(BIN_DIR)/polynomial.sv

ipxact:
	./pack.sh

test_data:
	mkdir -p $(BIN_DIR)
	g++ main.cpp -fno-fast-math -o build/main && build/main build/test_data.hex

test_bench:
	mkdir -p $(BIN_DIR)
	sus_compiler dspfp32_dw_arith.sus -o build/testbench.sv --top testbench
	cp testbench.sv build/testbench_top.sv
	cat build/testbench.sv >> build/testbench_top.sv
	cat dspfp32.sv >> build/testbench_top.sv

clean:
	rm -rf $(BIN_DIR)

.PHONY: build polynomial ipxact test_data test_bench clean
