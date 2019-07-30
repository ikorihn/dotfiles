#!/bin/bash
git clone https://github.com/r57ty7/dotfiles ~/.dotfiles

# symlink
ln -s ~/.dotfiles/.zshenv ~/.zshenv
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.vimrc ~/.vimrc
ln -s ~/.dotfiles/.tigrc ~/.tigrc
ln -s ~/.dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/.vim ~/.vim
ln -s ~/.dotfiles/.config/karabiner ~/.config/karabiner
ln -s ~/.dotfiles/.config/nvim ~/.config/nvim
ln -s ~/.dotfiles/.config/powerline ~/.config/powerline

# brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew bundle install --file=Mac/Brewfile

# python
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

# node
curl -L git.io/nodebrew | perl - setup
nodebrew install-binary latest
npm i -g @google/clasp
npm i -g @types/google-apps-script
npm i -g npm
npm i -g npm-check-updates
npm i -g typescript

# font
curl -L -O 'https://github.com/tomokuni/Myrica/raw/master/product/Myrica.zip'
curl -L -O 'https://github.com/tomokuni/Myrica/raw/master/product/MyricaM.zip'
unzip -o Myrica.zip -d temp/
unzip -o MyricaM.zip -d temp/
cp -f temp/Myrica*.TTC ~/Library/Fonts/
fc-cache -vf
rm -rf temp
rm -f Myrica.zip MyricaM.zip

source ~/.zshenv
source ~/.zshrc
