source $HOME/.zsh/zshrc
source $HOME/.zsh/zsh_env

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/filippo/.lmstudio/bin"
# End of LM Studio CLI section


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/filippo/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/filippo/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/home/filippo/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/home/filippo/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba shell init' !!
export MAMBA_EXE='/home/filippo/miniforge3/bin/mamba';
export MAMBA_ROOT_PREFIX='/home/filippo/miniforge3';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<
