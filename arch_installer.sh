#!/usr/bin/env bash
pacman_pkgs=(
    neovim
    zsh
    alacritty
    brightnessctl
    timeshift
    starship
    picom
    docker
    docker-compose
    podman
    buildah
    kubectl
    xclip
    xdotool
    ydotool
    xautolock
    htop
    gtk2
    gtk3
    gtk4
    xournalpp
    flameshot
    dive
    #code
    kleopatra
)
pacman -Sy --needed "${pacman_pkgs[@]}"

# Installazione dei pacchetti AUR
aur_pkgs=(
    timeshift-autosnap
    google-chrome
    openlens-bin
    openfortivpn-webview-qt
    pass
    passmenu
    xkblayout-state
    pamac-aur
    i3lock-color
    kind
    #postman
    rofi-greenclip
    #volctl
)
yay -Sy --needed "${aur_pkgs[@]}"


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
ln -s ~/dotfiles/mimeapps/mimeapps.list ~/.config/ 2>/dev/null
rm -r ~/.config/nvim 2>/dev/null
rm -r ~/.config/git 2>/dev/null
ln -s ~/dotfiles/git/git ~/.config/ 2>/dev/null

#nvim plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'


git clone -b custom https://github.com/hershellayton95/vecna-vim ~/.config/nvim 2>/dev/null