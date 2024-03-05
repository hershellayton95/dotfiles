#!/bin/bash

source ./yay/yay
source ./starship/starship

sudo pacman -Syu
sudo pacman -S --needed zsh base-devel git htop neofetch fontconfig

chsh -s zsh

installa_yay
install_starship

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

yay -S --needed timeshift timeshift-autosnap neovim

curl -sS https://starship.rs/install.sh | sh
