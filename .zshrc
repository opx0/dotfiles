# --- 1. Path & Zinit Setup ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"


if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# --- 2. Plugins & Snippets ---
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-hooks/zsh-hooks
# OMZ Snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found
zinit snippet OMZP::docker

# --- 3. Completion Initialization ---
# Enable standard completion
autoload -Uz compinit && compinit

# Enable bash completion support (Fixes 'compgen' error for xan)
autoload -U +X bashcompinit && bashcompinit

zinit cdreplay -q

# --- 4. History Settings (XDG Clean) ---
# Stores history in ~/.local/state/zsh/history instead of cluttering home
[ -d "$HOME/.local/state/zsh" ] || mkdir -p "$HOME/.local/state/zsh"
HISTFILE="$HOME/.local/state/zsh/history"
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# --- 5. Styles & Keybindings ---
# Ensure LS_COLORS is populated for completion colors
if [[ -z "$LS_COLORS" ]]; then
  eval "$(dircolors -b)"
fi

zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
# Removed fzf-tab styles as requested
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# --- 6. Functions ---
mkcd() { mkdir -p "$1" && cd "$1"; }
cx() { cd "$@" && l; }
fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)" && l; }
fv() { nvim "$(find . -type f -not -path '*/.*' | fzf)" }

# Fixed: Uses 'wl-copy' (Wayland/Hyprland) instead of 'pbcopy' (macOS)
f() { echo "$(find . -type f -not -path '*/.*' | fzf)" | wl-copy }

# Fixed: __xan wrapper now works because bashcompinit is loaded above
function __xan {
    xan compgen "$1" "$2" "$3"
}

# --- 7. Integrations & Env ---
export PATH="$HOME/.local/bin:$PATH"
export TERM=xterm-256color
export LANG=en_US.UTF-8
export GPG_TTY=$(tty)

# Custom Tools
[ -f ~/.gemKeys ] && source ~/.gemKeys
export PATH="$PATH:$HOME/.lmstudio/bin"

# Shell Integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd z zsh)"
eval "$(atuin init zsh --disable-up-arrow)"

# Carapace
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

# --- 8. Modular Config Loader ---
# Loads everything from ~/.config/zsh/*.zsh (aliases, exports, etc.)
for conf in ~/.config/zsh/*.zsh; do
  [ -f "$conf" ] && source "$conf"
done
unset conf
export PATH=$PATH:$(go env GOPATH)/bin
# eval $(thefuck --alias)
export PATH="$PATH:/home/opx/Projects/dev-cli"
eval "$(dev-cli hook zsh)"
