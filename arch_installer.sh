#!/usr/bin/env bash

sudo pacman -Sy --needed \
	dex \
	xss-lock \
	arandr \
	neovim \
	timeshift \
	less \
	starship \
	feh \
	htop \
	xclip \
	numlockx \
	alacritty \
	firefox \
	alsa-utils \
	pavucontrol \
	thunar \
	kubectl \
	openconnect \
	man-db \
	man-pages \
	reflector \
	lxappearance-gtk3 \
	materia-gtk-theme \
	papirus-icon-theme \
	polkit-gnome \
	brightnessctl \
	archlinux-xdg-menu \
	gvfs \
	gvfs-afc \
	gvfs-gphoto2 \
	gvfs-mtp \
	gvfs-nfs \
	gvfs-smb \
	thunar \
	thunar-archive-plugin \
	thunar-volman \
	net-tools \
	netctl \
	ntfs-3g \
	networkmanager \
	networkmanager-openconnect \
	networkmanager-openvpn \
	openssh \
	reflector \
	nfs-utils \
	nilfs-utils \
	ntp \
	firewalld \
	pipewire-jack \
	rsync \
	hwinfo \
	hwdetect 

yay -Sy --needed \
	timeshift-autosnap \
	volctl \
	vscodium-bin \
	google-chrome \
	openlens-bin \
	openfortivpn-webview-qt \
	pass \
	passmenu \
	picom \
	dunst \
	downgrade \
	reflector-simple \
	xkblayout-state 

rm -r ~/.config/i3 2>/dev/null
ln -s ~/dotfiles/i3 ~/.config/ 2>/dev/null
# rm -r ~/.config/rofi 2>/dev/null
# ln -s ~/dotfiles/rofi ~/.config/ 2>/dev/null
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
