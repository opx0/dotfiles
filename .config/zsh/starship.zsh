if [[ "$TERM_PROGRAM" == "vscode" ]]; then
    export STARSHIP_CONFIG="/home/abhi/dotfiles/.config/starship/starship-minimal.toml"
else
    export STARSHIP_CONFIG="/home/abhi/.config/starship/starship.toml"
fi

eval "$(starship init zsh)"
