# My dotfiles

This directory contains the dotfiles for my system

## Requirements

Ensure you have the following installed on your system

### Git

```sh
pacman -S git
```

### Stow

```sh
pacman -S stow
```

## Installation

First, check out the dotfiles repo in your $HOME directory using git

```sh
git clone https://github.com/aura-zero/dotfiles.git
cd dotfiles
```

then use GNU stow to create symlinks

```sh
stow .
```

**if incounter some error in `stow .` then run**

```sh
stow --adopt .
```

## System Setup with usefull packages

Installation of packages for development and general purpose use

```sh
cd dotfiles/scripts
bash install.sh
```

## Making your shell magical with atuin

Sync, search and backup shell history with Atuin

```sh
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
```

> to add symlinks to gitignore

```zsh
#find . -type l | sed -e s'/^\.\///g' >> .gitignore
find . -type l -exec git rm --cached {} \;
```
