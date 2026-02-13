#!/usr/bin/env bash

# Interrompe l'esecuzione se un comando fallisce (più sicuro)
set -ex

# Variabili
DOTFILES_DIR="$HOME/dotfiles"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

PACMAN_PACKAGES=(
    man neovim tree age git zsh curl base-devel wl-clipboard xclip
    meld k9s btop htop kubectl net-tools inetutils
    docker podman docker-compose podman-compose
    openssl buildah helm krew skopeo chromium kustomize
    zoxide fzf gettext shellcheck starship
    kleopatra screen atuin dive crane keepassxc
)

if ! grep -qi "microsoft" /proc/version; then
    PACMAN_PACKAGES+=( xournalpp timeshift )
fi

echo ">>> Inizio configurazione..."

echo ">>> Aggiornamento pacchetti Pacman..."
sudo pacman -Syyu --noconfirm


sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"

# # 2. Installazione Oh My Zsh (Non interattivo)
# if [ ! -d "$HOME/.oh-my-zsh" ]; then
#     echo ">>> Installazione Oh My Zsh..."
#     sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
# else
#     echo ">>> Oh My Zsh già installato."
# fi

if [[ "$SHELL" != *"/zsh"* ]]; then
    echo ">>> Cambio shell a Zsh..."
    chsh -s $(which zsh)
fi

# 3. Installazione YAY (AUR Helper)
if ! command -v yay &> /dev/null; then
    echo ">>> yay non trovato, installazione in corso..."
    _temp_dir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$_temp_dir/yay"
    pushd "$_temp_dir/yay"
    makepkg -si --noconfirm
    popd
    rm -rf "$_temp_dir"
fi

# 4. Pacchetti AUR
echo ">>> Installazione pacchetti AUR..."


AUR_PACKAGE=(
    asdf-vm kind ttf-firacode-nerd
    logseq-desktop
)

if ! grep -qi "microsoft" /proc/version; then
    AUR_PACKAGE+=( timeshift-autosnap )
fi

yay -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"
    

# 5. Gestione Dotfiles (Symlinks)
echo ">>> Configurazione Symlinks..."

# Funzione helper per creare link simbolici in sicurezza
link_file() {
    local src=$1
    local dest=$2
    
    # Crea la directory di destinazione se non esiste
    mkdir -p "$(dirname "$dest")"
    
    # Rimuove il file/link esistente o fa il backup (opzionale, qui uso force)
    rm -rf "$dest"
    ln -sf "$src" "$dest"
    echo "Linked: $src -> $dest"
}

# Mapping dei file
link_file "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/.zsh" "$HOME/.zsh"
link_file "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship/starship.toml"
link_file "$DOTFILES_DIR/git/git" "$HOME/.config/git"
link_file "$DOTFILES_DIR/k9s" "$HOME/.config/k9s"
link_file "$DOTFILES_DIR/atuin" "$HOME/.config/atuin"


# 6. Plugin Zsh
echo ">>> Installazione plugin Zsh..."
install_zsh_plugin() {
    local repo=$1
    local dest_name=$(basename "$repo")
    local target="$ZSH_CUSTOM/plugins/$dest_name"
    
    if [ ! -d "$target" ]; then
        git clone "https://github.com/$repo" "$target"
    else
        echo "Plugin $dest_name già presente."
    fi
}

install_zsh_plugin "zsh-users/zsh-history-substring-search"
install_zsh_plugin "zsh-users/zsh-completions"
install_zsh_plugin "zsh-users/zsh-autosuggestions"
install_zsh_plugin "zsh-users/zsh-syntax-highlighting"

# 7. Configurazione ASDF
# Nota: asdf necessita di essere 'caricato' per funzionare. 
# Su Arch via AUR solitamente è in /opt/asdf-vm/asdf.sh
if [ -f /opt/asdf-vm/asdf.sh ]; then
    . /opt/asdf-vm/asdf.sh
    
    echo ">>> Configurazione plugin ASDF..."
    # Aggiunge il plugin solo se non esiste già
    asdf plugin list | grep -q "crane" || asdf plugin add crane https://github.com/dmpe/asdf-crane.git
    asdf plugin list | grep -q "dive" || asdf plugin add dive https://github.com/looztra/asdf-dive
    
    # Installa le versioni definite nel .tool-versions (se presente nella home o nella dir corrente)
    # Se non hai un file .tool-versions globale, questo comando potrebbe fallire o non fare nulla.
    asdf install || echo "Nessun .tool-versions trovato o errore nell'installazione."
fi

# 8. Helm Plugins
if command -v helm &> /dev/null; then
    if ! helm plugin list | grep -q "push"; then
        helm plugin install https://github.com/chartmuseum/helm-push
    fi
fi

# 9. Kubectl Krew
# NOTA: Hai installato 'krew' via pacman all'inizio. 
# Non serve scaricare il tar.gz manualmente. Configuriamo solo i plugin.
if command -v kubectl-krew &> /dev/null || command -v krew &> /dev/null; then
    echo ">>> Aggiornamento Krew..."
    kubectl krew update
    
    echo ">>> Installazione plugin Krew..."
    # Lista di plugin da installare
    KREW_PLUGINS=(neat oidc-login cnf)
    
    for plugin in "${KREW_PLUGINS[@]}"; do
        if ! kubectl krew list | grep -q "^$plugin "; then
            kubectl krew install "$plugin"
        fi
    done
fi

echo ">>> Configurazione completata con successo! Riavvia la shell."