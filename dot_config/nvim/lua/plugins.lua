-- プラグイン定義 (lazy.nvim のspec)
-- 設定が短いものはここにインラインで書き、長いものは lua/pluginconfig/ に分離する
return {
  ---------------------------------------------------------------------------
  -- カラースキーム
  ---------------------------------------------------------------------------
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000, -- 他のプラグインより先に読み込む
    config = function()
      require("kanagawa").setup({
        compile = true,
        background = {
          dark = "dragon",
          light = "lotus",
        },
      })
      vim.cmd.colorscheme("kanagawa")
    end,
  },

  ---------------------------------------------------------------------------
  -- ライブラリ
  ---------------------------------------------------------------------------
  { "nvim-lua/plenary.nvim", lazy = true },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "MunifTanjim/nui.nvim", lazy = true },

  ---------------------------------------------------------------------------
  -- UI
  ---------------------------------------------------------------------------
  -- ファイラー
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("pluginconfig.nvim-tree") end,
  },

  -- バッファをタブ風に表示
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          numbers = "both",
          max_name_length = 30,
          max_prefix_length = 20, -- prefix used when a buffer is de-duplicated
          truncate_names = true,
          diagnostics = "nvim_lsp",
          custom_filter = function(buf_number)
            if vim.bo[buf_number].filetype == "qf" then return false end
            if vim.bo[buf_number].buftype == "terminal" then return false end
            return true
          end,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "left",
              separator = true,
            },
          },
          sort_by = "insert_after_current",
        },
      })
    end,
  },

  -- ステータスライン
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("pluginconfig.lualine") end,
  },

  -- インデントガイド
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      exclude = {
        buftypes = { "terminal", "nofile" },
        filetypes = { "help", "NvimTree" },
      },
    },
  },

  -- カーソル下の単語と同じ単語をハイライト
  {
    "RRethy/vim-illuminate",
    config = function()
      vim.g.Illuminate_ftblacklist = { "alpha", "NvimTree" }
      require("config.keymaps").setup_illuminate()
    end,
  },

  -- 行末の不要な空白をハイライト
  { "ntpeters/vim-better-whitespace" },

  -- キーマップのヘルプ表示
  { "folke/which-key.nvim", opts = {} },

  -- コマンドライン・メッセージのUI置き換え
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          signature = {
            enabled = false,
          },
        },
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false,
          lsp_doc_border = false,
          filter = {
            event = "msg_show",
            min_height = 10,
            max_width = 10,
          },
        },
      })
      require("config.keymaps").setup_noice()
    end,
  },

  ---------------------------------------------------------------------------
  -- 編集操作・移動
  ---------------------------------------------------------------------------
  -- 括弧やクォートで囲む操作
  { "kylechui/nvim-surround", opts = {} },

  -- * 検索の強化 + 検索マッチ数の表示 (キーマップは config/keymaps.lua)
  { "haya14busa/vim-asterisk" },
  {
    "kevinhwang91/nvim-hlslens",
    config = function() require("hlslens").setup() end,
  },

  -- テキストの整列 (gaで起動)
  {
    "echasnovski/mini.align",
    version = "*",
    config = function() require("mini.align").setup() end,
  },

  -- camelCase/snake_caseなどの変換
  {
    "johmsalas/text-case.nvim",
    config = function()
      require("textcase").setup({})
      local tele_status_ok, telescope = pcall(require, "telescope")
      if tele_status_ok then telescope.load_extension("textcase") end
    end,
  },

  -- json/yamlのカーソル位置のパスをwinbarに表示
  {
    "phelipetls/jsonpath.nvim",
    ft = { "json", "yaml" },
    config = function()
      if vim.fn.exists("+winbar") == 1 then
        vim.opt_local.winbar = "%{%v:lua.require'jsonpath'.get()%}"
      end
      require("config.keymaps").setup_jsonpath()
    end,
  },

  ---------------------------------------------------------------------------
  -- 補完・スニペット
  ---------------------------------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "onsails/lspkind.nvim",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
    config = function() require("pluginconfig.cmp") end,
  },

  -- スニペットエンジン (自作スニペットは pluginconfig/luasnip.lua)
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    config = function() require("pluginconfig.luasnip") end,
  },
  -- VSCode形式のスニペット集
  {
    "rafamadriz/friendly-snippets",
    dependencies = { "L3MON4D3/LuaSnip" },
    config = function() require("luasnip.loaders.from_vscode").lazy_load() end,
  },

  ---------------------------------------------------------------------------
  -- LSP・フォーマッター・診断表示
  ---------------------------------------------------------------------------
  { "neovim/nvim-lspconfig" },
  { "mason-org/mason.nvim" },
  -- LSPサーバーの設定本体は pluginconfig/lsp.lua
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function() require("pluginconfig.lsp") end,
  },

  -- フォーマッター・リンター (none-ls)
  { "nvimtools/none-ls.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function() require("pluginconfig.null-ls") end,
  },

  -- 引数のシグネチャ表示
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
  },

  -- 診断の一覧表示
  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
  },

  -- シンボルのアウトライン表示
  {
    "stevearc/aerial.nvim",
    opts = {},
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },

  ---------------------------------------------------------------------------
  -- Treesitter
  ---------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    branch = "main",
    config = function() require("pluginconfig.treesitter") end,
  },
  -- 現在のスコープの先頭行を画面上部に固定表示
  { "nvim-treesitter/nvim-treesitter-context" },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    init = function()
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
      vim.g.no_plugin_maps = true
    end,
  },

  ---------------------------------------------------------------------------
  -- Telescope
  ---------------------------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "jvgrootveld/telescope-zoxide",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "ikorihn/monorepo.nvim",
      "xvzc/chezmoi.nvim",
    },
    config = function() require("pluginconfig.telescope") end,
  },

  -- monorepo内のプロジェクト切り替え
  {
    "ikorihn/monorepo.nvim",
    config = function()
      require("monorepo").setup({
        autoload_telescope = false, -- telescope側で明示的にload_extensionする
      })
    end,
  },

  ---------------------------------------------------------------------------
  -- Git
  ---------------------------------------------------------------------------
  -- 変更行の表示・hunk操作
  {
    "lewis6991/gitsigns.nvim",
    config = function() require("pluginconfig.gitsigns") end,
  },

  -- 現在行のGitHub URLを開く
  { "ruanyl/vim-gh-line" },

  -- diff表示・ファイル履歴
  {
    "sindrets/diffview.nvim",
    config = function()
      local actions = require("diffview.actions")
      require("diffview").setup({
        view = {
          default = {
            layout = "diff2_horizontal",
          },
          merge_tool = {
            layout = "diff3_horizontal",
            disable_diagnostics = true,
            winbar_info = true,
          },
          file_history = {
            layout = "diff2_horizontal",
          },
        },
        keymaps = require("config.keymaps").diffview(actions),
      })
    end,
  },

  -- git blameの表示 (<leader>gb)
  {
    "FabijanZulj/blame.nvim",
    opts = {
      date_format = "%Y-%m-%d",
      virtual_style = "float",
      focus_blame = true,
      merge_consecutive = false,
      max_summary_width = 30,
      blame_options = { "-w" },
      mappings = require("config.keymaps").blame(),
    },
  },

  -- Git操作UI (<leader>gg)
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },

  ---------------------------------------------------------------------------
  -- 言語別
  ---------------------------------------------------------------------------
  -- Go開発の統合ツール (保存時にgoimportsを実行)
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
    },
    config = function(lp, opts)
      require("go").setup(opts)
      local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function() require("go.format").goimports() end,
        group = format_sync_grp,
      })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
  },

  ---------------------------------------------------------------------------
  -- 外部ツール連携
  ---------------------------------------------------------------------------
  -- Obsidianノートの編集支援
  {
    "epwalsh/obsidian.nvim",
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = function()
      -- workspaceのパスはマシン固有なので config/local.lua から読む
      local local_ok, local_config = pcall(require, "config.local")
      local workspaces = local_ok and local_config.obsidian_workspaces or nil
      return {
        workspaces = workspaces or {
          { name = "personal", path = "~/obsidian" },
        },
        ui = {
          enable = false,
        },
        disable_frontmatter = true,
        daily_notes = {
          folder = "daily",
          date_format = "%Y-%m-%d",
          template = nil,
        },
        completion = {
          nvim_cmp = true,
        },
      }
    end,
  },

  -- chezmoi管理ファイルの編集時に自動でapply
  {
    "xvzc/chezmoi.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      edit = {
        watch = true, -- Set true to automatically apply on save.
        force = false,
      },
      notification = {
        on_open = true,
        on_apply = true,
      },
    },
  },
}
