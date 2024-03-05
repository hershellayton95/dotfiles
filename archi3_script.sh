#!/bin/bash

source ./zsh/zsh
source ./yay/yay
source ./starship/starship

sudo pacman -Syu
sudo pacman -S --needed base-devel git htop neofetch fontconfig

install_zsh
installa_yay
install_starship

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

yay -S --needed timeshift timeshift-autosnap neovim
