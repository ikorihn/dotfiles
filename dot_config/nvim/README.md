# Neovim設定

chezmoiで管理している。実体は `~/.local/share/chezmoi/dot_config/nvim/`。

## ディレクトリ構成

```
init.lua              -- エントリポイント (読み込み順のみ)
lua/
  config/             -- プラグインに依存しない基本設定
    options.lua       -- vim.opt / vim.g
    keymaps.lua       -- 汎用キーマップ
    autocommands.lua  -- autocmd
    lazy.lua          -- lazy.nvimのブートストラップ
    vscode.lua        -- VSCode Neovim拡張用の最小構成 (vim-plug)
  plugins/            -- lazy.nvimのプラグイン定義 (カテゴリ別、自動読み込み)
    colorscheme.lua / ui.lua / editor.lua / coding.lua / lsp.lua
    treesitter.lua / telescope.lua / git.lua / lang.lua / tools.lua
  pluginconfig/       -- 長い設定 (目安50行超) だけをここに分離
  utils.lua           -- 自作コマンド (:Jq, :CopyFilePath* など)
after/lsp/            -- LSPサーバー個別の設定 (vim.lsp.config形式)
queries/              -- treesitterのカスタムクエリ (gotmplなど)
spell/                -- typos-lspの設定
```

## ルール

- プラグインの追加は `lua/plugins/` の該当カテゴリファイルにspecを追記する
- 設定が短いうちはspecの `opts` / `config` にインラインで書き、長くなったら
  `lua/pluginconfig/<plugin>.lua` に切り出して `require("pluginconfig.xxx")` で読む
- プラグイン固有のキーマップは各spec・pluginconfigに、汎用キーマップは
  `config/keymaps.lua` に書く
- LSPサーバーの追加: `pluginconfig/lsp.lua` の `servers` に追加し、
  個別設定が必要なら `after/lsp/<server>.lua` を作る
