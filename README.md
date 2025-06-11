# My dotfiles

This repository contains the dotfiles for my system.

## Requirements

Ensure you have the following installed on your system.

- Git
- Stow

```shell
sudo apt update
sudo apt install stow
```

Backup `.zshrc` file.

```shell
mv .zshrc .zshrc.bak
```

## Installation

Clone this repository into $HOME directory.

```shell
cd ~/dotfiles/
stow --adopt .
```

Verfiy that `~/.zshrc` is a symlink to `~/dotfiles/.zshrc`.

```shell
ls -lha ~/.zshrc
```
