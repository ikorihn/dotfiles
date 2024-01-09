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

#### [Rust](https://www.rust-lang.org/tools/install)

#### [Go](https://go.dev/learn/)

```shell
sudo rm -rf /usr/local/go && curl -L https://go.dev/dl/$(curl 'https://go.dev/dl/?mode=json' | jq -r '.[0].files[] | select(.os == "darwin" and .arch == "arm64" and .kind == "archive") | .filename') | sudo tar -zx -C /usr/local/
```

#### [Alacritty](https://github.com/alacritty/alacritty)

```shell
git clone https://github.com/alacritty/alacritty.git ~/src/alacritty/
cd ~/src/alacritty
make app
cp -r target/release/osx/Alacritty.app /Applications/
```

#### [Neovim](https://neovim.io)

```shell
git clone https://github.com/neovim/neovim.git ~/src/alacritty/
cd ~/src/alacritty
make CMAKE_BUILD_TYPE=Release
sudo make install
```
