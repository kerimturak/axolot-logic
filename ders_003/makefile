# === Ayarlar ===
RTL_DIR=rtl
TB_DIR=tb
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
.PHONY: all sim synth show clean

all: sim

check-top:
ifndef RTL_TOP
	$(error ❌ RTL_TOP tanımlanmalı. Örn: make sim RTL_TOP=cpu)
endif

setup: check-top
	@echo "[🧱] 1. vlib work"
	$(VLIB) $(WORK_DIR)

compile: check-top setup
	@echo "[📝] 2. vlog"
	$(VLOG) -work $(WORK_DIR) $(ALL_FILES)

sim_batch: check-top compile
	@echo "[🚀] 3. vsim -c"
	$(VSIM) -c -work $(WORK_DIR) tb_$(RTL_TOP) -do "run -all; quit"
	@echo "[✔] Simülasyon tamamlandı."

sim: check-top compile
	@echo "[🚀] 3. vsim"
	$(VSIM) -work $(WORK_DIR) tb_$(RTL_TOP) -do "run -all; quit"
	@echo "[✔] Simülasyon tamamlandı."

synth: check-top
	$(YOSYS) -p "read_verilog $(RTL_FILES); synth -top $(RTL_TOP); write_json $(SYNTH_JSON)"
	@echo "[✔] Sentez tamamlandı. Çıktı: $(SYNTH_JSON)"

show: check-top
	$(YOSYS) -p "read_verilog $(RTL_FILES); synth -top $(RTL_TOP); show"

clean:
	rm -rf $(WORK_DIR) transcript
