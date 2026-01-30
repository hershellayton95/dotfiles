#!/usr/bin/env bash

set -x

sudo pacman -Syy

sudo pacman -S --needed --noconfirm \
	neovim \
    tree \
    age \
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
    zfz\
    shellcheck \
    gettext \
    kleopatra \
    keepassxc \
    screen \
    atuin

if ! command -v omz &> /dev/null; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [[ "$SHELL" != *"zsh"* ]]; then
    chsh -s /usr/bin/zsh
fi

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

yay -S --needed --noconfirm asdf-vm ttf-firacode-nerd kind envsubst

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

if ! kubectl krew &> /dev/null; then
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
fi

kubectl krew update
kubectl krew install neat
kubectl krew install oidc-login
kubectl krew install cnf