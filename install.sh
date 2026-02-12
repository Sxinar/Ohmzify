#!/bin/bash

# Renkler ve Stil
BOLD='\033[1m'
GOLD='\033[0;33m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

clear

# Ohmzify ASCII Logo
echo -e "${GOLD}${BOLD}"
echo "  ____  _                      _  __       "
echo " / __ \| |                    (_)/ _|      "
echo "| |  | | |__  _ __ ___  _____ _  |_ _   _  "
echo "| |  | | '_ \| '_ \` _ \|_  / |  _| | | | | "
echo "| |__| | | | | | | | | |/ /| | | | | |_| | "
echo " \____/|_| |_|_| |_| |_/___|_|_| |_|\__, | "
echo "                                     __/ | "
echo "                                    |___/  "
echo -e "          ${BLUE}⚡ Resist the Ordinary Shell ⚡${NC}"
echo "-------------------------------------------------------"

# 1. Paket Listesi Güncelleme (Hatalı depolarda takılmaması için timeout eklendi)
echo -e "${BLUE}>>>${NC} Paket listesi güncelleniyor (Sorunlu depolar atlanacak)..."
# 20 saniye içinde cevap vermeyen depoları pas geçer
sudo timeout 20 apt update || echo -e "${RED}[!] Bazı depolar güncellenemedi ancak kuruluma devam ediliyor...${NC}"

# 2. Zsh Yükleme
if ! command -v zsh &> /dev/null; then
    echo -e "${BLUE}>>>${NC} Zsh kuruluyor..."
    sudo apt install -y zsh
else
    echo -e "${GREEN}[+]${NC} Zsh zaten yüklü."
fi

# 3. Oh My Zsh Yükleme
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${BLUE}>>>${NC} Oh My Zsh yükleniyor..."
    # --unattended bayrağı kurulumun etkileşim gerektirmeden bitmesini sağlar
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 4. Eklentilerin İndirilmesi
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
echo -e "${BLUE}>>>${NC} Eklentiler indiriliyor..."

# Autosuggestions
if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions --quiet
fi

# Syntax Highlighting
if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting --quiet
fi

# 5. .zshrc Yapılandırması
echo -e "${BLUE}>>>${NC} Ayarlar dosyasına ( .zshrc ) işleniyor..."

# Plugin satırını güncelle (git, autosuggestions ve syntax-highlighting ekle)
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc

# Temayı Agnoster yap
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/g' ~/.zshrc

# 6. Varsayılan Shell Değiştirme
if [ "$SHELL" != "$(which zsh)" ]; then
    echo -e "${BLUE}>>>${NC} Varsayılan kabuk Zsh olarak değiştiriliyor..."
    sudo chsh -s $(which zsh) $USER
fi

# Final Mesajı
echo -e "\n${GOLD}${BOLD}Ohmzify Başarıyla Kuruldu!${NC}"
echo -e "${BLUE}NOT:${NC} Değişiklikleri görmek için terminali kapatıp açın veya şu komutu çalıştırın:"
echo -e "${GREEN}source ~/.zshrc${NC}"
echo "-------------------------------------------------------"
