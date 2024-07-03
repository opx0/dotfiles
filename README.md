# My dotfiles

This directory contains the dotfiles for my system
## Requirements

Ensure you have the following installed on your system
### Git

```shell
pacman -S git
```

### Stow

```shell
pacman -S stow
```

## Installation

First, check out the dotfiles repo in your $HOME directory using git

```shell
$ git clone https://github.com/aura-zero/dotfiles.git
$ cd dotfiles
```

then use GNU stow to create symlinks

```shell
$ stow .
```

