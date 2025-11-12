ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
# zinit light Aloxaf/fzf-tab # Fuzzy completion and more

zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found
zinit snippet OMZP::docker

autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
# zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'


alias ls='ls --color'
alias vim='nvim'
alias v='nvim'
alias cl='clear'
alias la='tree'

#dev
alias bund="bun run dev"
alias bunrnd="bun run dev"

# System
alias fuckoff="shutdown now"
alias foff='shutdown now'
alias re="shutdown -r now"

# Dirs
alias 0="cd ~/"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Git
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin "
alias gpm="git push origin main"
alias gpu="git pull origin"
alias gst="git status"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gadd='git add'
alias gax='git add .'
alias ga='git add -p'
alias gcoall='git checkout -- .'
alias gr='git remote'
alias gre='git reset'

# Eza
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"

#clip
alias xpwd="pwd | xclip -selection clipboard" # for x11
alias pwdy="pwd | wl-copy" # for wayland

alias fs='yazi'

## tmux
alias t='tmux'
alias ta='tmux attach'
# navigation
cx() { cd "$@" && l; }
fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)" && l; }
f() { echo "$(find . -type f -not -path '*/.*' | fzf)" | pbcopy }
fv() { nvim "$(find . -type f -not -path '*/.*' | fzf)" }

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd z zsh)"

#. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh --disable-up-arrow)"

# bun completions
[ -s "/home/abhi/.bun/_bun" ] && source "/home/abhi/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="/home/abhi/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export PATH=$PATH:/home/abhi/.spicetify

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# paths
export PATH="$HOME/.local/bin:$PATH"

export TERM=xterm-256color
export LANG=en_US.UTF-8

# Check if we're running in VS Code integrated terminal
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
    export STARSHIP_CONFIG="/home/abhi/dotfiles/.config/starship/starship-minimal.toml"
else
    export STARSHIP_CONFIG="/home/abhi/.config/starship/starship.toml"
fi

# Initialize starship
eval "$(starship init zsh)"

# # Kamal
# alias kamal='/home/abhi/.gem/ruby/3.4.0/bin/kamal'
# export PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"

# Xan completions
function __xan {
    xan compgen "$1" "$2" "$3"
}

alias players="curl http://100.78.89.96:8080/players"

# View JustPlay logs
justplay-logs() {
    docker logs -f justplay-app
}

export PATH=~/.npm-global/bin:$PATH

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# imagemagick
alias ap21p='magick *.png output.pdf' //all png to pdf
alias aj21p='magick *.jpg output.pdf' //all jpg to pdf
export PATH=~/.npm-global/bin:$PATH


#if [ -f ~/.gemini_keys ]; then
#    source ~/.gemKeys
#fi#
source ~/.gemKeys

#export ANDROID_HOME=$HOME/Android/Sdk
#export PATH=$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH


# export JAVA_HOME=/usr/lib/jvm/default
# export PATH=$JAVA_HOME/bin:$PATH

# export JAVA_HOME=/usr/lib/jvm/default

# # Android SDK
# export ANDROID_HOME=/home/abhi/Android/Sdk
# export PATH=$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$PATH


# export ANDROID_HOME=$HOME/Android/Sdk
# export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH
export PATH=$JAVA_HOME/bin:$PATH
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk

export ANDROID_SDK_ROOT=$HOME/Android/Sdk
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/tools/bin:$ANDROID_SDK_ROOT/platform-tools
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# ${UserConfigDir}/zsh/.zshrc
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

mkcd() {
  mkdir -p "$1" && cd "$1"
}
export GPG_TTY=$(tty)
