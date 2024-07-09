# https://github.com/jdx/mise
curl https://mise.run | sh
# https://www.rust-lang.org/tools/install
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# https://bun.sh/docs/installation
curl -fsSL https://bun.sh/install | bash
# https://docs.deno.com/runtime/manual/getting_started/installation/
curl -fsSL https://deno.land/install.sh | sh

# https://go.dev/learn/
sudo rm -rf /usr/local/go && curl -L https://go.dev/dl/$(curl 'https://go.dev/dl/?mode=json' | jq -r '.[0].files[] | select(.os == "darwin" and .arch == "arm64" and .kind == "archive") | .filename') | sudo tar -zx -C /usr/local/

# Symlink
mkdir -p ~/.local/bin
ln -sf ~/.config/git/git-open ~/.local/bin/
ln -sf ~/.config/git/git-pr ~/.local/bin/

# Go
go install github.com/spf13/cobra-cli@latest
go install github.com/tomwright/dasel/v2/cmd/dasel@master
go install github.com/davidrjenni/reftools/cmd/fillstruct@latest
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/fatih/gomodifytags@latest
go install golang.org/x/tools/cmd/gonew@latest
go install github.com/jfeliu007/goplantuml/cmd/goplantuml@latest
go install github.com/x-motemen/gore/cmd/gore@latest
go install github.com/mdempsky/gocode@latest
go install github.com/cweill/gotests/gotests@latest
go install golang.org/x/vuln/cmd/govulncheck@latest
go install github.com/charmbracelet/gum@latest
go install github.com/rs/jaggr@latest
go install github.com/ikorihn/kuroneko@latest
go install github.com/oapi-codegen/oapi-codegen/v2/cmd/oapi-codegen@latest
go install mvdan.cc/sh/v3/cmd/shfmt@latest
go install honnef.co/go/tools/cmd/staticcheck@latest
go install github.com/open-telemetry/opentelemetry-collector-contrib/cmd/telemetrygen@latest
go install github.com/reproducible-containers/diffoci/cmd/diffoci@latest

# Rust
cargo install typos-cli
cargo install md-tui
cargo install stylua

# Python
pipx install cookiecutter
