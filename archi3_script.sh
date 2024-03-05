#!/bin/bash

sudo pacman -Syu
sudo pacman -S --needed zsh base-devel git htop neofetch

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..

sudo rm -r yay

chsh -s zsh
