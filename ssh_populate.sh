#!/usr/bin/env bash

set -euo pipefail

# --- Configurazione ---
DB_PATH="$HOME/OneDrive/KeepassXC/passdatabase.kdbx"
SSH_DIR="$HOME/dotfiles/.ssh"
KP_GROUP="/Chiavi/ssh"
MAX_ATTEMPTS=3

# --- Funzioni di Base ---

# Verifica che il DB esista e crea un backup di sicurezza
prepare_database() {
    if [[ ! -f "$DB_PATH" ]]; then
        echo "❌ Errore: Il database non esiste in: $DB_PATH" >&2
        exit 1
    fi
    
    local backup_path="${DB_PATH}.bak"
    cp "$DB_PATH" "$backup_path"
    echo "🛡️  Backup del database creato: $(basename "$backup_path")"
}

# Chiede la password e valida l'accesso con un massimo di tentativi
authenticate_keepass() {
    local attempt=1
    local password=""

    while [ $attempt -le $MAX_ATTEMPTS ]; do
        read -rs -p "[$attempt/$MAX_ATTEMPTS] Inserisci la Master Password di KeepassXC: " password < /dev/tty
        echo "" >&2

        if keepassxc-cli ls "$DB_PATH" <<< "$password" > /dev/null 2>&1; then
            echo "🔐 Accesso verificato." >&2
            echo "$password"
            return 0
        fi

        echo "❌ Password errata. Riprova." >&2
        ((attempt++))
    done

    echo "🚫 Troppi tentativi falliti. Uscita." >&2
    exit 1
}

setup_ssh_dir() {
    if [[ ! -d "$SSH_DIR" ]]; then
        echo "⚠️  Cartella $SSH_DIR non trovata. Creazione in corso..."
        mkdir -p "$SSH_DIR"
        chmod 700 "$SSH_DIR"
    fi
}

# --- Funzione di confronto Hash ---
compare_file_hashes() {
    local pass="$1"
    local key_name="$2"
    local local_file="$3"
    local attachment_name="$4"

    # Calcola SHA256 del file locale
    local local_hash
    local_hash=$(sha256sum "$local_file" | awk '{print $1}')

    # Estrae l'allegato da KP in stdout e ne calcola subito lo SHA256
    local kp_hash
    kp_hash=$(keepassxc-cli attachment-export "$DB_PATH" "$KP_GROUP/$key_name" "$attachment_name" --stdout <<< "$pass" 2>/dev/null | sha256sum | awk '{print $1}')

    if [[ "$local_hash" == "$kp_hash" ]]; then
        return 0 # True: sono identici
    else
        return 1 # False: differiscono
    fi
}

# --- Funzioni di Sincronizzazione Chiavi ---

sync_kp_to_local() {
    local pass="$1"
    shift
    local keys_keepass=("$@")

    echo "--- 📥 Verifica e Importazione Chiavi verso Locale ---"

    if [ ${#keys_keepass[@]} -eq 0 ]; then
        echo "ℹ️  Nessuna chiave trovata nel gruppo $KP_GROUP."
        return
    fi

    for key in "${keys_keepass[@]}"; do
        local key_clean
        key_clean=$(echo "$key" | xargs)
        
        [[ -z "$key_clean" ]] && continue
        # IMPORTANTE: Salta la voce 'config' perché viene gestita dalla funzione dedicata
        [[ "$key_clean" == "config" ]] && continue 

        local priv_path="$SSH_DIR/$key_clean"
        local pub_path="$priv_path.pub"

        if [[ -f "$priv_path" && -f "$pub_path" ]]; then
            # Controllo Hash se i file esistono
            if compare_file_hashes "$pass" "$key_clean" "$priv_path" "$key_clean" && \
               compare_file_hashes "$pass" "$key_clean" "$pub_path" "$key_clean.pub"; then
                echo "✅ [OK] Chiave '$key_clean' presente e identica."
            else
                echo -e "\n⚠️  [DIFF] I contenuti di '$key_clean' differiscono! Sovrascrivo con la versione di KeePassXC..."
                read -p "Vuoi aggiornare il file Locale (l), aggiornare KeePassXC (k) o saltare (s)? [l/k/s]: " choice < /dev/tty
                case "$choice" in
                    l|L )
                        echo "   -> Sovrascrivo i file locali con quelli di KeePassXC..."
                        keepassxc-cli attachment-export "$DB_PATH" "$KP_GROUP/$key_clean" "$key_clean" --stdout <<< "$pass" > "$priv_path" 2>/dev/null
                        chmod 600 "$priv_path"
                        keepassxc-cli attachment-export "$DB_PATH" "$KP_GROUP/$key_clean" "$key_clean.pub" --stdout <<< "$pass" > "$pub_path" 2>/dev/null
                        chmod 644 "$pub_path"
                        ;;
                    k|K )
                        echo "   -> Aggiorno gli allegati su KeePassXC..."
                        # Rimuoviamo preventivamente i vecchi allegati per evitare l'errore "already exists"
                        keepassxc-cli attachment-rm "$DB_PATH" "$KP_GROUP/$key_clean" "$key_clean" <<< "$pass" > /dev/null 2>&1 || true
                        keepassxc-cli attachment-rm "$DB_PATH" "$KP_GROUP/$key_clean" "$key_clean.pub" <<< "$pass" > /dev/null 2>&1 || true
                        
                        keepassxc-cli attachment-import "$DB_PATH" "$KP_GROUP/$key_clean" "$key_clean" "$priv_path" <<< "$pass" > /dev/null 2>&1
                        keepassxc-cli attachment-import "$DB_PATH" "$KP_GROUP/$key_clean" "$key_clean.pub" "$pub_path" <<< "$pass" > /dev/null 2>&1
                        echo "✅ [OK] Allegati aggiornati nel database."
                        ;;
                    * )
                        echo "   -> Operazione saltata."
                        ;;
                esac
            fi
        else
            echo "❌ [MISS] Chiave '$key_clean' mancante in locale. Estrazione..."
            echo "ℹ️  Download $key_clean."
            keepassxc-cli attachment-export "$DB_PATH" "$KP_GROUP/$key_clean" "$key_clean" --stdout <<< "$pass" > "$priv_path" 2>/dev/null
            chmod 600 "$priv_path"
            
            echo "ℹ️  Download $key_clean.pub."
            keepassxc-cli attachment-export "$DB_PATH" "$KP_GROUP/$key_clean" "$key_clean.pub" --stdout <<< "$pass" > "$pub_path" 2>/dev/null
            chmod 644 "$pub_path"
        fi
    done
}

sync_local_to_kp() {
    local pass="$1"
    shift
    local keys_keepass=("$@")

    echo -e "\n--- 📤 Verifica chiavi orfane (Locale -> KeePassXC) ---"
    
    # mapfile prende solo i .pub, quindi il file config viene ignorato automaticamente qui
    mapfile -t local_files < <(find "$SSH_DIR" -maxdepth 1 -name "*.pub" -exec basename {} .pub \;)

    for local_key in "${local_files[@]}"; do
        local found=false
        for kp_key in "${keys_keepass[@]}"; do
            [[ "$local_key" == "$(echo "$kp_key" | xargs)" ]] && found=true && break
        done

        local priv_path="$SSH_DIR/$local_key"
        local pub_path="$priv_path.pub"

        if [[ "$found" == false ]]; then
            echo -e "\n⚠️  [ORPHAN] Chiave '$local_key' è presente in Locale ma non in KeepassXC."
            
            if [[ ! -f "$priv_path" ]]; then
                echo "❌ Errore: Manca la chiave privata per $local_key, non è possibile importarla."
                continue
            fi

            # CHIEDE CONFERMA PRIMA DELL'IMPORTAZIONE
            read -p "Vuoi importare la nuova chiave '$local_key' in KeePassXC? [y/N]: " choice < /dev/tty
            case "$choice" in
                y|Y )
                    echo "   -> Creazione voce e importazione allegati in corso..."
                    printf "%s\n\n\n" "$pass" | keepassxc-cli add "$DB_PATH" "$KP_GROUP/$local_key" > /dev/null 2>&1
                    keepassxc-cli attachment-import "$DB_PATH" "$KP_GROUP/$local_key" "$local_key" "$priv_path" <<< "$pass" > /dev/null 2>&1
                    keepassxc-cli attachment-import "$DB_PATH" "$KP_GROUP/$local_key" "$local_key.pub" "$pub_path" <<< "$pass" > /dev/null 2>&1
                    echo "✅ [OK] '$local_key' importata correttamente!"
                    ;;
                * )
                    echo "   -> Importazione saltata."
                    ;;
            esac
        fi
    done
}

# --- Funzione di Sincronizzazione per file Config ---

sync_ssh_config() {
    local pass="$1"
    shift
    local keys_keepass=("$@")

    echo -e "\n--- ⚙️ Sincronizzazione file 'config' ---"

    local config_path="$SSH_DIR/config"
    local has_kp_config=false

    # Controlliamo se la voce 'config' esiste nel database
    for kp_key in "${keys_keepass[@]}"; do
        if [[ "$(echo "$kp_key" | xargs)" == "config" ]]; then
            has_kp_config=true
            break
        fi
    done

    if [[ "$has_kp_config" == true && -f "$config_path" ]]; then
        if compare_file_hashes "$pass" "config" "$config_path" "config"; then
            echo "✅ [OK] Il file 'config' è presente e identico."
        else
            echo -e "\n⚠️  [DIFF] Il file 'config' differisce tra Locale e KeePassXC!"
            read -p "Vuoi aggiornare il file Locale (l), aggiornare KeePassXC (k) o saltare (s)? [l/k/s]: " choice < /dev/tty
            case "$choice" in
                l|L )
                    echo "   -> Sovrascrivo il file 'config' locale con quello di KeePassXC..."
                    keepassxc-cli attachment-export "$DB_PATH" "$KP_GROUP/config" "config" --stdout <<< "$pass" > "$config_path"
                    chmod 600 "$config_path"
                    ;;
                k|K )
                    echo "   -> Rimuovo la vecchia versione di 'config' da KeePassXC..."
                    keepassxc-cli attachment-rm "$DB_PATH" "$KP_GROUP/config" "config" <<< "$pass" > /dev/null 2>&1 || true
                    
                    echo "   -> Carico la nuova versione..."
                    if keepassxc-cli attachment-import "$DB_PATH" "$KP_GROUP/config" "config" "$config_path" <<< "$pass" > /dev/null 2>&1; then
                        echo "✅ [OK] 'config' aggiornato su KeePassXC!"
                    else
                        echo "❌ Errore durante l'aggiornamento dell'allegato su KeePassXC."
                    fi
                    ;;
                * )
                    echo "   -> Operazione saltata."
                    ;;
            esac
        fi
    elif [[ "$has_kp_config" == true && ! -f "$config_path" ]]; then
        echo "❌ [MISS] File 'config' mancante in locale. Estrazione..."
        keepassxc-cli attachment-export "$DB_PATH" "$KP_GROUP/config" "config" --stdout <<< "$pass" > "$config_path"
        chmod 600 "$config_path"
    elif [[ "$has_kp_config" == false && -f "$config_path" ]]; then
        echo -e "\n⚠️  [ORPHAN] File 'config' presente in Locale ma non in KeepassXC."
        read -p "Vuoi importare il file 'config' in KeePassXC? [y/N]: " choice < /dev/tty
        case "$choice" in
            y|Y )
                echo "   -> Creazione voce 'config' e importazione in corso..."
                
                # 1. Crea la voce (silenziosamente)
                printf "%s\n\n\n" "$pass" | keepassxc-cli add "$DB_PATH" "$KP_GROUP/config" > /dev/null 2>&1
                
                # 2. Tenta l'importazione dell'allegato, questa volta VISIBILE se fallisce
                if keepassxc-cli attachment-import "$DB_PATH" "$KP_GROUP/config" "config" "$config_path" <<< "$pass" > /dev/null 2>&1; then
                    echo "✅ [OK] 'config' importato correttamente!"
                else
                    echo "❌ [ERRORE] Importazione fallita. Verifica manualmente KeePassXC."
                fi
                ;;
            * )
                echo "   -> Importazione saltata."
                ;;
        esac
    fi
}

# --- Main ---

main() {
    setup_ssh_dir
    prepare_database
    
    local KEEPASS_PASS
    KEEPASS_PASS=$(authenticate_keepass)

    # Caricamento lista chiavi (usiamo || true per non interrompere se la cartella è vuota)
    mapfile -t keys_on_keepass < <(keepassxc-cli ls "$DB_PATH" "$KP_GROUP" <<< "$KEEPASS_PASS" 2>/dev/null || true)

    # 1. Sync chiavi (KP -> Locale)
    sync_kp_to_local "$KEEPASS_PASS" "${keys_on_keepass[@]}"
    
    # 2. Sync chiavi orfane (Locale -> KP)
    sync_local_to_kp "$KEEPASS_PASS" "${keys_on_keepass[@]}"
    
    # 3. Sync del file config
    sync_ssh_config "$KEEPASS_PASS" "${keys_on_keepass[@]}"

    echo -e "\n✨ Operazione completata con successo!"
}

main "$@"