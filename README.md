# ikorihn's dotfiles

## Setup on macOS

### Apply dotfiles using chezmoi

```shell
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ikorihn
```

### Set ZDOTDIR

```shell
sudo sh -c 'echo "export ZDOTDIR=$HOME/.config/zsh" >> /etc/zshenv'
```

### Install softwares

#### [Homebrew](https://brew.sh/)

After install brew, run following command.

```shell
./Mac/brew_install_home.sh
```

#### [Alacritty](https://github.com/alacritty/alacritty)

```shell
git clone https://github.com/alacritty/alacritty.git ~/src/alacritty/
cd ~/src/alacritty

# https://github.com/alacritty/alacritty/blob/master/INSTALL.md#terminfo
infocmp alacritty
sudo tic -xe alacritty,alacritty-direct extra/alacritty.info

make app && rm -rf /Applications/Alacritty.app && cp -r target/release/osx/Alacritty.app /Applications
```

#### [Neovim](https://neovim.io)

```shell
# Install from binary
rm -r ~/src/nvim-macos-arm64 && curl -L -o - https://github.com/neovim/neovim/releases/latest/download/nvim-macos-arm64.tar.gz | tar -zxf - -C ~/src/
sudo ln -sf ~/src/nvim-macos-arm64/bin/nvim /usr/local/bin/nvim

# Install from source
git clone https://github.com/neovim/neovim.git ~/src/neovim/
cd ~/src/neovim
make CMAKE_BUILD_TYPE=Release
sudo make install
```
