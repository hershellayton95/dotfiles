#!/usr/bin/env bash

sudo pacman -Sy --needed \
	neovim \
	zsh \
	alacritty \
	brightnessctl \
	timeshift \
	starship \
	picom \
	docker \
	docker-compose \
	podman \
	buildah \
	kubectl \
	xclip \
	xdotool \
	ydotool \
	xautolock \
	htop

yay -Sy --needed \
	timeshift-autosnap \
	volctl \
	vscodium-bin \
	google-chrome \
	openlens-bin \
	openfortivpn-webview-qt \
	pass \
	passmenu \
	xkblayout-state \
	pamac-aur   

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
rm -r ~/.config/starship* 2>/dev/null
ln -s ~/dotfiles/starship/* ~/.config/ 2>/dev/null
rm -r ~/.config/autostart 2>/dev/null
ln -s ~/dotfiles/autostart ~/.config/ 2>/dev/null
rm -r ~/.config/mimeapps.list 2>/dev/null
ln -s ~/dotfiles/mimeapps.list ~/.config/ 2>/dev/null

