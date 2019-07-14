#!/bin/bash

# brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
cd Mac
brew bundle install

# symlink
ln -sf ~/.dotfiles/.gitconfig ~/
ln -sf ~/.dotfiles/.tigrc ~/
ln -sf ~/.dotfiles/.tmux.conf ~/
ln -sf ~/.dotfiles/.vimrc ~/
ln -sf ~/.dotfiles/.zshenv ~/
ln -sf ~/.dotfiles/.zshrc ~/
mkdir -p .config
ln -sf ~/.dotfiles/.config/karabiner ~/.config/
ln -sf ~/.dotfiles/.config/powerline ~/.config/
ln -sf ~/.dotfiles/.config/nvim ~/.config/
mkdir -p .vim
ln -sf ~/.dotfiles/.vim/rc ~/.vim/

# pip 

# node
curl -L git.io/nodebrew | perl - setup
nodebrew install-binary latest
npm i -g @google/clasp
npm i -g @types/google-apps-script
npm i -g npm
npm i -g npm-check-updates
npm i -g typescript
