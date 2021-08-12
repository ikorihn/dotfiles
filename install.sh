#!/bin/bash

# symlink
ln -sf ~/dotfiles/.gitconfig ~/
ln -sf ~/dotfiles/.git_commit_template ~/
ln -sf ~/dotfiles/.tigrc ~/
ln -sf ~/dotfiles/.tmux.conf ~/
ln -sf ~/dotfiles/.vimrc ~/
ln -sf ~/dotfiles/.zshenv ~/
ln -sf ~/dotfiles/.zsh ~/
ln -sf ~/dotfiles/.vim ~/
mkdir -p ~/.config
ln -sf ~/dotfiles/.config/karabiner ~/.config/
ln -sf ~/dotfiles/.config/nvim ~/.config/
ln -sf ~/dotfiles/.config/starship.toml ~/.config/

# brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew bundle install --file=Mac/Brewfile

# python
LATEST_PYTHON=$(pyenv install --list | rg "^\s+([0-9]+\.?){3}$" | sed 's/\s\+//' | tail -1)

pyenv install $LATEST_PYTHON
pyenv global $LATEST_PYTHON
pip install powerline-gitstatus
pip install powerline-status
pip install togglCli

# node
nodebrew install-binary latest
nodebrew use latest
