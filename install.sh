#!/bin/bash

# symlink
ln -sf ~/.dotfiles/.gitconfig ~/
ln -sf ~/.dotfiles/.tigrc ~/
ln -sf ~/.dotfiles/.tmux.conf ~/
ln -sf ~/.dotfiles/.vimrc ~/
ln -sf ~/.dotfiles/.zshenv ~/
ln -sf ~/.dotfiles/.zshrc ~/
mkdir -p ~/.config
ln -sf ~/.dotfiles/.config/karabiner ~/.config/
ln -sf ~/.dotfiles/.config/powerline ~/.config/
ln -sf ~/.dotfiles/.config/nvim ~/.config/
ln -sf ~/.dotfiles/.vim ~/

# brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew bundle install --file=Mac/Brewfile

# python
pyenv install 3.8.1
pyenv global 3.8.1
pip install neovim
pip install powerline-gitstatus
pip install powerline-status
pip install awscli

# node
nodebrew install-binary latest
nodebrew use latest

source ~/.zshenv
source ~/.zshrc
