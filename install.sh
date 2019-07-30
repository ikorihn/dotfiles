#!/bin/bash
git clone https://github.com/r57ty7/dotfiles ~/.dotfiles

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
