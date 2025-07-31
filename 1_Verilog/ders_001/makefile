# === Ayarlar ===
RTL_DIR=rtl
TB_DIR=tb
RTL_TOP_MODULE := $(basename $(notdir $(firstword $(wildcard $(RTL_DIR)/*.v))))
TB_TOP_MODULE  := $(basename $(notdir $(firstword $(wildcard $(TB_DIR)/*.v))))
WORK_DIR=work
WAVEFORM=wave.vcd
SYNTH_JSON=synth.json

# === Araçlar ===
VLIB=vlib
VLOG=vlog
VSIM=vsim
YOSYS=yosys
GTK=gtkwave

# === Dosyalar ===
RTL_FILES=$(wildcard $(RTL_DIR)/*.v)
TB_FILES=$(wildcard $(TB_DIR)/*.v)
ALL_FILES=$(TB_FILES) $(RTL_FILES)

# === Hedefler ===
.PHONY: all sim synth show wave clean

all: sim

# === 1. Simülasyon (ModelSim 3 aşamalı yapı) ===
setup:
	@echo "[🧱] 1. vlib work"
	$(VLIB) $(WORK_DIR)

compile: setup
	@echo "[📝] 2. vlog"
	$(VLOG) -work $(WORK_DIR) $(ALL_FILES)

sim_batch: compile
	@echo "[🚀] 3. vsim"
	$(VSIM) -c -work $(WORK_DIR) $(TB_TOP_MODULE) -do "run -all; quit"

	@echo "[✔] Simülasyon tamamlandı."

sim: compile
	@echo "[🚀] 3. vsim"
	$(VSIM) -work $(WORK_DIR) $(TB_TOP_MODULE) -do "run -all; quit"

	@echo "[✔] Simülasyon tamamlandı."

# === Sentez (Yosys) ===
synth:
	$(YOSYS) -p "read_verilog $(RTL_FILES); synth -top $(RTL_TOP_MODULE); write_json $(SYNTH_JSON)"
	@echo "[✔] Sentez tamamlandı. Çıktı: $(SYNTH_JSON)"

# === Şematik Göster (Yosys GUI) ===
show:
	$(YOSYS) -p "read_verilog $(RTL_FILES); synth -top $(RTL_TOP_MODULE); show"

# === Waveform Göster (GTKWave) ===
# wave:
# 	$(GTK) $(WAVEFORM)

# === Temizlik ===
clean:
	rm -rf $(WORK_DIR) transcript vsim.wlf $(SYNTH_JSON) $(WAVEFORM)
	@echo "[✔] Temizlik tamamlandı."

# === (İsteğe bağlı) Optimize ===
#opt:
#	vopt $(TOP_MODULE) -o $(TOP_MODULE)_opt -work $(WORK_DIR)
#	vsim $(TOP_MODULE)_opt -do "run -all; quit"
