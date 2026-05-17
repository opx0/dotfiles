alias ls='ls --color'
alias vim='nvim'
alias v='nvim'
alias cl='clear'
alias la='tree'

#dev
alias bund="bun run dev"
alias bunrnd="bun run dev"
alias code="code-insiders"

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

# imagemagick
alias ap21p='magick *.png output.pdf'  # all png to pdf
alias aj21p='magick *.jpg output.pdf'  # all jpg to pdf

#zed-cli
alias zed="zeditor"
