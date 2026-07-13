# --- 0. PWD guard ---
# If the shell was spawned while a parent terminal's zinit was mid-Turbo-load,
# the inherited PWD may be a plugin dir. Bounce back to $HOME in that case.
case "$PWD" in
    */.local/share/zinit/plugins/*|*/.local/share/zinit/snippets/*) cd ~ ;;
esac

# --- 1. Path & Zinit Setup ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# --- 2. Plugins & Snippets ---
# Deferred via Turbo mode (wait'0' lucid): loaded ~50ms after first prompt
zinit wait'0' lucid for \
    zsh-users/zsh-completions \
    zsh-users/zsh-autosuggestions \
    zsh-hooks/zsh-hooks \
    OMZP::sudo \
    OMZP::archlinux \
    OMZP::command-not-found \
    OMZP::docker

# Syntax highlighting must load late (after other widgets) — fast-syntax-highlighting variant is faster
zinit wait'0' lucid atinit'zicompinit; zicdreplay' light-mode for \
    zsh-users/zsh-syntax-highlighting

# --- 3. Completion Initialization ---
# Cache compinit; do security check at most once per day
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Bash completion support (for 'compgen' used by xan)
autoload -U +X bashcompinit && bashcompinit

# --- 4. History Settings (XDG Clean) ---
# Stores history in ~/.local/state/zsh/history instead of cluttering home
[ -d "$HOME/.local/state/zsh" ] || mkdir -p "$HOME/.local/state/zsh"
HISTFILE="$HOME/.local/state/zsh/history"
HISTSIZE=10000
SAVEHIST=$HISTSIZE
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

# Shell Integrations (deferred — load after first prompt)
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'

zinit wait'0a' lucid as'null' id-as'fzf-keybindings' \
    atload'eval "$(fzf --zsh)"' for zdharma-continuum/null
zinit wait'0a' lucid as'null' id-as'zoxide-init' \
    atload'eval "$(zoxide init --cmd z zsh)"' for zdharma-continuum/null
zinit wait'0b' lucid as'null' id-as'atuin-init' \
    atload'eval "$(atuin init zsh --disable-up-arrow)"' for zdharma-continuum/null
zinit wait'0b' lucid as'null' id-as'carapace-init' \
    atload'source <(carapace _carapace)' for zdharma-continuum/null

# --- 8. Modular Config Loader ---
# Loads everything from ~/.config/zsh/*.zsh (aliases, exports, etc.)
for conf in ~/.config/zsh/*.zsh; do
  [ -f "$conf" ] && source "$conf"
done
unset conf
# GOPATH default ($HOME/go) — avoid subprocess call on every shell start
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/Projects/dev-cli"

eval "$(starship init zsh)"
export PATH="/home/opx/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/home/opx/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/opx/.lmstudio/bin"
# End of LM Studio CLI section

zinit wait'1' lucid as'null' id-as'dev-cli-init' \
    atload'eval "$(dev-cli init zsh)"' for zdharma-continuum/null
export JAVA_HOME=/usr/lib/jvm/default
export PATH="$JAVA_HOME/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"

# Added by Antigravity CLI installer
export PATH="/home/opx/.local/bin:$PATH"
