# 1. Ev dizinine geç
cd ~

# 2. Verible'ı indir
wget https://github.com/google/verible/releases/download/v0.0-4013-gba3dc371/verible-v0.0-4013-gba3dc371-linux-static-x86_64.tar.gz

# 3. SHA256 kontrolü (isteğe bağlı ama önerilir)
echo "2e9b0b985bfca094ee6a11624494bfabd90789d3201e8f8fc40e9cda8b68d24d  verible-v0.0-4013-gba3dc371-linux-static-x86_64.tar.gz" | sha256sum -c

# 4. Arşivi çıkar
tar -xzf verible-v0.0-4013-gba3dc371-linux-static-x86_64.tar.gz

# 5. Dizin içine gir
cd verible-v0.0-4013-gba3dc371

# 6. Binary dosyalarını sistem PATH’ine kopyala
sudo cp bin/* /usr/local/bin/

# 7. Doğrula: sürüm numaraları görünmeli
verible-verilog-format --version
verible-verilog-lint --version
