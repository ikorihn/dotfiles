-- LSP・フォーマッター・診断表示
return {
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
}
