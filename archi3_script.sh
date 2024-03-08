#!/bin/bash

sudo pacman -S --needed git base-devel

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
sudo rm -r yay

yay -Sy --needed timeshift timeshift-autosnap neovim google-chrome vscodium-bin vscodium-bin-marketplace

sudo pacman -S --needed git base-devel zsh htop neofetch fontconfig
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
curl -sS https://starship.rs/install.sh | sh

chsh -s zsh

