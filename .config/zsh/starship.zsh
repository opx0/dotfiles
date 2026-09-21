if [[ "$TERM_PROGRAM" == "vscode" ]]; then
    export STARSHIP_CONFIG="$HOME/.config/starship/starship-minimal.toml"
else
    export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
fi
