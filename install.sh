#!/bin/bash

# brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
cd Mac
brew bundle install

# symlink
ln -s ~/.dotfiles/.gitconfig ~/
ln -s ~/.dotfiles/.tigrc ~/
ln -s ~/.dotfiles/.tmux.conf ~/
ln -s ~/.dotfiles/.vimrc ~/
ln -s ~/.dotfiles/.zshenv ~/
ln -s ~/.dotfiles/.zshrc ~/
mkdir -p .config
ln -s ~/.dotfiles/.config/karabiner ~/.config/
ln -s ~/.dotfiles/.config/powerline ~/.config/
ln -s ~/.dotfiles/.config/nvim ~/.config/
mkdir -p .vim
ln -s ~/.dotfiles/.vim/rc ~/.vim/

# pip 

# node
curl -L git.io/nodebrew | perl - setup
nodebrew install-binary latest
npm i -g @google/clasp
npm i -g @types/google-apps-script
npm i -g npm
npm i -g npm-check-updates
npm i -g typescript
