#!/bin/bash

sudo pacman -S --needed git base-devel

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
sudo rm -r yay

yay -Sy --needed timeshift timeshift-autosnap 
sudo pacman -S --needed zsh htop neofetch fontconfig firefox pass
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
curl -sS https://starship.rs/install.sh | sh

chsh -s zsh

yay -Sy --needed neovim google-chrome vscodium-bin vscodium-bin-marketplace 

rm -r  ~/.zshrc
rm -r ~/.oh-my-git

cp -r ./zsh/ ~
cp -r ./oh-my-git/ ~
cp ./starship/ ~/.config/starship.toml
