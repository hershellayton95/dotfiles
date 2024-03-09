#!/usr/bin/env bash

sudo pacman -Sy --needed neovim \
	alacritty \
	brightnessctl \
	timeshift \
	picom

yay -Sy --needed xkblayout-state timeshift-autosnap

rm -r ~/.config/i3 2>/dev/null
ln -s ~/dotfiles/i3 ~/.config/ 2>/dev/null
rm -r ~/.config/rofi 2>/dev/null
ln -s ~/dotfiles/rofi ~/.config/ 2>/dev/null
rm ~/.zshrc 2>/dev/null
ln -s ~/dotfiles/.zshrc ~ 2>/dev/null
rm -r ~/.zsh 2>/dev/null
ln -s ~/dotfiles/.zsh ~ 2>/dev/null
rm -r ~/.config/alacritty 2>/dev/null
ln -s ~/dotfiles/alacritty ~/.config/ 2>/dev/null
rm ~/.gitconfig 2>/dev/null
ln -s ~/dotfiles/git/.gitconfig ~/.gitconfig 2>/dev/null
rm -r ~/config/picom 2>/dev/null
ln -s ~/dotfiles/picom ~/.config/ 2>/dev/null
