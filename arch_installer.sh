#!/usr/bin/env bash
# sudo pacman -Rc i3lock

sudo pacman -Sy --needed \
	neovim \
	zsh \
	timeshift \
	starship \
	picom \
	docker \
	docker-compose \
	podman \
	buildah \
	kubectl \
	xclip \
	htop \
	xournalpp \
	flameshot \
	dive \
    qtpass \
    kleopatra
#	code \
# 	gtk2 \
# 	gtk3 \
# 	gtk4 \
# 	xdotool \
# 	ydotool \
# 	xautolock \
# 	alacritty \
# 	brightnessctl \

yay -Sy --needed \
	timeshift-autosnap \
	google-chrome \
# 	openfortivpn-webview-qt \
	pass \
	passmenu \
	kind
# 	openfortivpn-webview-qt \
# 	xkblayout-state \
# 	pamac-aur \
# 	i3lock-color \
# 	rofi-greenclip
#	postman \
	#volctl

# echo "rm -r ~/.config/i3 2>/dev/null"
# rm -r ~/.config/i3 2>/dev/null
#
# echo "ln -s ~/dotfiles/i3 ~/.config/ 2>/dev/null"
# ln -s ~/dotfiles/i3 ~/.config/ 2>/dev/null
#
# echo "rm -r ~/.config/rofi 2>/dev/null"
# rm -r ~/.config/rofi 2>/dev/null
#
# echo "ln -s ~/dotfiles/rofi ~/.config/ 2>/dev/null"
# ln -s ~/dotfiles/rofi ~/.config/ 2>/dev/null

echo "rm ~/.zshrc 2>/dev/null"
rm ~/.zshrc 2>/dev/null

echo "ln -s ~/dotfiles/.zshrc ~ 2>/dev/null"
ln -s ~/dotfiles/.zshrc ~ 2>/dev/null

echo "rm -r ~/.zsh 2>/dev/null"
rm -r ~/.zsh 2>/dev/null

echo "ln -s ~/dotfiles/.zsh ~ 2>/dev/null"
ln -s ~/dotfiles/.zsh ~ 2>/dev/null

# echo "rm -r ~/.config/alacritty 2>/dev/null"
# rm -r ~/.config/alacritty 2>/dev/null
#
# echo "ln -s ~/dotfiles/alacritty ~/.config/ 2>/dev/null"
# ln -s ~/dotfiles/alacritty ~/.config/ 2>/dev/null

# echo "rm ~/.gitconfig 2>/dev/null"
# rm ~/.gitconfig 2>/dev/null
#
# echo "ln -s ~/dotfiles/git/.gitconfig ~/.gitconfig 2>/dev/null"
# ln -s ~/dotfiles/git/.gitconfig ~/.gitconfig 2>/dev/null
#
# echo "rm -r ~/config/picom 2>/dev/null"
# rm -r ~/config/picom 2>/dev/null
#
# echo "ln -s ~/dotfiles/picom ~/.config/ 2>/dev/null"
# ln -s ~/dotfiles/picom ~/.config/ 2>/dev/null

echo "rm -r ~/.config/starship* 2>/dev/null"
rm -r ~/.config/starship* 2>/dev/null

echo "ln -s ~/dotfiles/starship/* ~/.config/ 2>/dev/null"
ln -s ~/dotfiles/starship/* ~/.config/ 2>/dev/null
#
# echo "rm -r ~/.config/mimeapps.list 2>/dev/null"
# rm -r ~/.config/mimeapps.list 2>/dev/null
#
# echo "ln -s ~/dotfiles/mimeapps/mimeapps.list ~/.config/ 2>/dev/null"
# ln -s ~/dotfiles/mimeapps/mimeapps.list ~/.config/ 2>/dev/null

echo "sudo rm -r ~/.config/nvim 2>/dev/null"
sudo rm -r ~/.config/nvim 2>/dev/null
#
# echo "rm -r ~/.config/git 2>/dev/null"
# rm -r ~/.config/git 2>/dev/null
#
# echo "ln -s ~/dotfiles/git/git ~/.config/ 2>/dev/null"
# ln -s ~/dotfiles/git/git ~/.config/ 2>/dev/null

#
# echo "rm -r ~/.config/autostart 2>/dev/null"
# rm -r ~/.config/autostart 2>/dev/null
#
# echo "ln -s ~/dotfiles/autostart ~/.config/ 2>/dev/null"
# ln -s ~/dotfiles/autostart ~/.config/ 2>/dev/null

#nvim plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone -b custom https://github.com/hershellayton95/vecna-vim ~/.config/nvim 2>/dev/null

git clone https://aur.archlinux.org/asdf-vm.git && cd asdf-vm && makepkg -si;
sudo rm -r asdf-vm
