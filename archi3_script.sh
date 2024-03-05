#!/bin/bash

source ./yay/yay

sudo pacman -Syu
sudo pacman -S --needed zsh base-devel git htop neofetch fontconfig

chsh -s zsh

installa_yay

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

yay -S --needed timeshift timeshift-autosnap neovim

curl -sS https://starship.rs/install.sh | sh
