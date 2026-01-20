#!/usr/bin/env bash

set -x

sudo pacman -Syy

sudo pacman -S --needed --noconfirm \
	neovim \
    git \
    zsh \
    curl \
    base-devel \
    k9s \
    nvim \
    btop \
    htop \
    kubectl \
    net-tools \
    docker \
    podman \
    docker-compose \
    podman-compose \
    meld \
    xclip \
    openssl \
    buildah \
    helm \
    krew \
    skopeo \
    chromium \
    kustomize \
	starship \
    zoxide \
    shellcheck \
    atuin
    
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

chsh -s /usr/bin/zsh

if ! command -v yay &> /dev/null; then
    echo "yay non trovato, installazione in corso..."
    # Creiamo una cartella temporanea per la build
    _temp_dir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$_temp_dir/yay"
    pushd "$_temp_dir/yay"
    makepkg -si --noconfirm
    popd
    rm -rf "$_temp_dir"
fi

yay -S --needed --noconfirm asdf-vm ttf-firacode-nerd kind

sudo sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sudo locale-gen
echo "LANG=en_US.UTF-8" | sudo tee /etc/locale.conf

echo "rm ~/.zshrc 2>/dev/null"
rm ~/.zshrc 2>/dev/null

echo "ln -s ~/dotfiles/.zshrc ~ 2>/dev/null"
ln -s ~/dotfiles/.zshrc ~ 2>/dev/null

echo "rm -r ~/.zsh 2>/dev/null"
rm -r ~/.zsh 2>/dev/null

echo "ln -s ~/dotfiles/.zsh ~ 2>/dev/null"
ln -s ~/dotfiles/.zsh ~ 2>/dev/null

echo "rm ~/.gitconfig 2>/dev/null"
rm ~/.gitconfig 2>/dev/null


echo "rm -r ~/.config/starship* 2>/dev/null"
rm -r ~/.config/starship* 2>/dev/null

echo "ln -s ~/dotfiles/starship/* ~/.config/ 2>/dev/null"
ln -s ~/dotfiles/starship/* ~/.config/ 2>/dev/null

echo "ln -s ~/dotfiles/git/.gitconfig ~/.gitconfig 2>/dev/null"
ln -s ~/dotfiles/git/.gitconfig ~/.gitconfig 2>/dev/null

echo "rm -r ~/.config/git 2>/dev/null"
rm -r ~/.config/git 2>/dev/null

echo "ln -s ~/dotfiles/git/git ~/.config/ 2>/dev/null"
ln -s ~/dotfiles/git/git ~/.config/ 2>/dev/null

git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search &> /dev/null;
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions &> /dev/null;
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions &> /dev/null;
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting &> /dev/null;

asdf plugin add crane https://github.com/dmpe/asdf-crane.git
asdf plugin add dive https://github.com/looztra/asdf-dive
asdf install


helm plugin install https://github.com/chartmuseum/helm-push

kubectl krew update
kubectl krew install neat
kubectl krew install oidc-login