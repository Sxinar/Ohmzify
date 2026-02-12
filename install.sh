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

# Fonksiyon: Hata Kontrolü
check_status() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[TAMAMLANDI]${NC} $1"
    else
        echo -e "${RED}[HATA]${NC} $1 sırasında bir sorun oluştu."
        exit 1
    fi
}

# 1. Zsh Yükleme
echo -e "${BLUE}>>>${NC} Sistem kontrol ediliyor..."
if ! command -v zsh &> /dev/null; then
    sudo apt update && sudo apt install -y zsh
    check_status "Zsh Kurulumu"
else
    echo -e "${GREEN}[+]${NC} Zsh zaten yüklü."
fi

# 2. Oh My Zsh Yükleme
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${BLUE}>>>${NC} Oh My Zsh yükleniyor..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    check_status "Oh My Zsh"
fi

# 3. Ohmzify Eklenti Paketi
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
echo -e "${BLUE}>>>${NC} Eklentiler enjekte ediliyor..."

# Autosuggestions
[ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions --quiet

# Syntax Highlighting
[ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ] && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting --quiet

check_status "Eklenti Kurulumları"

# 4. .zshrc Yapılandırması
echo -e "${BLUE}>>>${NC} Ohmzify ayarları uygulanıyor..."
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/g' ~/.zshrc

# Final
echo -e "\n${GOLD}${BOLD}Ohmzify Başarıyla Kuruldu!${NC}"
echo -e "Lütfen terminali kapatıp açın veya ${BLUE}'source ~/.zshrc'${NC} çalıştırın."
echo "-------------------------------------------------------"
