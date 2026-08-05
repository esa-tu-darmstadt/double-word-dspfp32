# You may override $(BIN_DIR) to a directory of your liking. For instance for parallel builds, you can `make U280/overlay_hw.xclbin BIN_DIR=U280_test` 

TMPDIR := /tmp/vivado_$(USER)
TOP = SUS_DWTimesDW_Fast

$(TMPDIR):
	mkdir -p $(TMPDIR)

FILES := 
FILES += hhrc.sus

v80/%: BIN_DIR ?= v80
v80/%: PART := xcv80-lsva4737-2MHP-e-S

v80/sus_codegen.sv: $(FILES)
	mkdir -p $(BIN_DIR)
	sus_compiler $(FILES) -o $(BIN_DIR)/$(TOP).sv --top $(TOP)
	cat dspfp32.sv >> $(BIN_DIR)/$(TOP).sv

v80/hhrc.zip: pack_kernel.tcl v80/sus_codegen.sv dspfp32_add.sv
	rm -f $(BIN_DIR)/SUSpMV_Full.xo
	rm -rf $(BIN_DIR)/pack_prj
	mkdir $(BIN_DIR)/pack_prj
	cd $(BIN_DIR)/pack_prj;\
	vivado -mode batch -source ../../pack_kernel.tcl -tclargs $(PART) ../SUSpMV_Full.xo $(SUS_FLOAT_LIB_PATH) ../../pblocks_v80.xdc
	rm -f $(BIN_DIR)/SUSpMV_Full.zip
	cd $(BIN_DIR)/pack_prj && zip -r ../SUSpMV_Full.zip SUSpMV_Full_ip

v80/tapasco: v80/SUSpMV_Full.zip
	tapasco import $(BIN_DIR)/SUSpMV_Full.zip as 100 -p v80
	tapasco --jobsFile tapasco/job_v80.json

clean: cleantmp
	rm -rf v80
	
cleantmp:
	rm -rf $(TMPDIR)

.PHONY: clean cleantmp v80/tapasco
