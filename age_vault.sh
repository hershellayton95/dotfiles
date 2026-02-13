#!/usr/bin/env bash

set -euo pipefail

# --- Configurazione ---
DB_PATH="$HOME/OneDrive/KeepassXC/passdatabase.kdbx"
ATTACHMENT_PATH="/Chiavi/age/age"
ATTACHMENT_NAME="age-key.txt"
OUTPUT_FILE="encrypted_store.tar.gz.age"
SOURCE_DIR="$HOME/dotfiles"
TARGET_SUBDIR="decrypted_store"

for cmd in keepassxc-cli age tar; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Errore: '$cmd' non è installato."
        exit 1
    fi
done


usage() {
    echo "Utilizzo: $0 [-c | -x]"
    echo "  -c    Comprime e cripta (Store -> Age)"
    echo "  -x    Decripta ed estrae (Age -> Store)"
    exit 1
}

# Funzione per recuperare le chiavi da KeePassXC
get_keys() {
    read -rs -p "Inserisci la Master Password di KeepassXC: " KEEPASSXC_MASTERPASSWORD
    
    if [[ -z "${KEEPASSXC_MASTERPASSWORD:-}" ]]; then
        echo "Errore: Variabile KEEPASSXC_MASTERPASSWORD non impostata."
        exit 1
    fi
    
    local output
    output=$(keepassxc-cli attachment-export "$DB_PATH" "$ATTACHMENT_PATH" "$ATTACHMENT_NAME" --stdout <<< "$KEEPASSXC_MASTERPASSWORD")

    pub_key=$(awk '/public key:/ {print $NF}' <<< "$output")
    sec_key=$(awk '/AGE-SECRET-KEY-/ {print $NF}' <<< "$output")

    if [[ -z "$pub_key" || -z "$sec_key" ]]; then
        echo "Errore: Chiavi non trovate nel database."
        exit 1
    fi
}

do_compress() {
    echo "🔒 Compressione e criptazione in corso..."
    get_keys
    tar -cz -C "$SOURCE_DIR" "$TARGET_SUBDIR" | age -r "$pub_key" > "$OUTPUT_FILE"
    echo "✅ Archivio creato: $OUTPUT_FILE"
}

do_extract() {
    echo "🔓 Decriptazione ed estrazione in corso..."
    if [[ ! -f "$OUTPUT_FILE" ]]; then
        echo "Errore: File $OUTPUT_FILE non trovato."
        exit 1
    fi
    get_keys
    # Passiamo la secret_key tramite stdin (-) ad age
    if echo "$sec_key" | age --decrypt -i - "$OUTPUT_FILE" | tar -xvz -C "$SOURCE_DIR"; then
        echo "✅ Estrazione completata in $SOURCE_DIR/$TARGET_SUBDIR"
    else
        echo "❌ Errore durante l'estrazione."
        exit 1
    fi
}

# --- Logica Principale (Parsing Opzioni) ---
if [[ $# -eq 0 ]]; then usage; fi

while getopts "cx" opt; do
    case "$opt" in
        c) do_compress ;;
        x) do_extract ;;
        *) usage ;;
    esac
done