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
RTL_FILES := $(wildcard $(RTL_DIR)/*.v)
TB_FILES  := $(wildcard $(TB_DIR)/*.v)
ALL_FILES := $(TB_FILES) $(RTL_FILES)

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
	@if [ -z "$(RTL_FILES)" ]; then \
	  echo "⚠️  RTL dosyası bulunamadı, sentez atlanıyor."; \
	else \
	  echo "[🛠️] RTL dosyaları bulundu, sentez başlatılıyor..."; \
	  $(YOSYS) -p "read_verilog $(RTL_FILES); synth -top $(RTL_TOP); write_json $(SYNTH_JSON)"; \
	  echo "[✔] Sentez tamamlandı. Çıktı: $(SYNTH_JSON)"; \
	fi

show: check-top
	@if [ -z "$(RTL_FILES)" ]; then \
	  echo "⚠️  RTL dosyası bulunamadı, şematik gösterim atlanıyor."; \
	else \
	  echo "[📈] Şematik oluşturuluyor..."; \
	  $(YOSYS) -p "read_verilog $(RTL_FILES); synth -top $(RTL_TOP); show -format dot -prefix show_$(RTL_TOP) $(RTL_TOP)"; \
	fi

showview: show
	@if [ -f show_$(RTL_TOP).dot ]; then \
	  xdot show_$(RTL_TOP).dot; \
	else \
	  echo "⚠️  .dot dosyası bulunamadı. Önce 'make show RTL_TOP=...' komutunu çalıştırın."; \
	fi

clean:
	rm -rf $(WORK_DIR) transcript vsim.wlf $(SYNTH_JSON) show_*.dot
	@echo "[✔] Temizlik tamamlandı."
