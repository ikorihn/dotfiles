-- Automatically install lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  { "nvim-lua/plenary.nvim" }, -- Useful lua functions used by lots of plugins
  {
    "kevinhwang91/nvim-hlslens",
    config = function() require("pluginconfig/nvim-hlslens") end,
  },

  {
    "MunifTanjim/nui.nvim",
  },
  -- Notification
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    config = function() require("pluginconfig/noice") end,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
  },
  {
    "j-hui/fidget.nvim",
    config = function() require("fidget").setup() end,
  },

  {
    "phelipetls/jsonpath.nvim",
    ft = {
      "json",
      "yaml",
    },
    config = function() require("pluginconfig/jsonpath") end,
  },

  {
    "kylechui/nvim-surround",
    config = function() require("pluginconfig/nvim-surround") end,
  },
  { "haya14busa/vim-asterisk" },
  {
    "echasnovski/mini.align",
    config = function() require("mini.align").setup() end,
  },
  {
    "johmsalas/text-case.nvim",
    config = function() require("pluginconfig/text-case") end,
  },

  {
    "epwalsh/obsidian.nvim",
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("pluginconfig/obsidian") end,
  },
  {
    "xvzc/chezmoi.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("pluginconfig/chezmoi") end,
  },

  -- Colorschemes
  { "folke/tokyonight.nvim" },
  { "rebelot/kanagawa.nvim" },

  -- filer, status
  { "nvim-tree/nvim-web-devicons" },
  {
    "nvim-tree/nvim-tree.lua",
    config = function() require("pluginconfig/nvim-tree") end,
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function() require("pluginconfig/bufferline") end,
  },
  { "ojroques/nvim-bufdel" },
  {
    "nvim-lualine/lualine.nvim",
    config = function() require("pluginconfig/lualine") end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function() require("pluginconfig/indentline") end,
  },
  {
    "RRethy/vim-illuminate",
    config = function() require("pluginconfig/illuminate") end,
  },
  { "ntpeters/vim-better-whitespace" },
  {
    "folke/which-key.nvim",
    config = function() require("pluginconfig/which-key") end,
  },

  -- completion
  {
    "hrsh7th/nvim-cmp",
    config = function() require("pluginconfig/cmp") end,
  }, -- The completion plugin
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-nvim-lua" },
  { "onsails/lspkind.nvim" },
  { "saadparwaiz1/cmp_luasnip" }, -- luasnip completions

  -- snippets
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    config = function() require("pluginconfig/luasnip") end,
  },
  {
    "rafamadriz/friendly-snippets",
    dependencies = {
      "L3MON4D3/LuaSnip",
    },
    config = function() require("luasnip.loaders.from_vscode").lazy_load() end,
  }, -- a bunch of snippets to use

  -- LSP
  { "neovim/nvim-lspconfig" }, -- enable LSP
  { "mason-org/mason.nvim" },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
  },
  { "nvimtools/none-ls.nvim" }, -- for formatters and linters
  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
  },
  {
    "nvimdev/lspsaga.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
  },
  {
    "stevearc/aerial.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },

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

  -- Testing
  {
    "klen/nvim-test",
    config = function() require("pluginconfig/nvim-test") end,
  },
  {
    "yanskun/gotests.nvim",
    ft = "go",
    config = function() require("gotests").setup() end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    config = function() require("pluginconfig/telescope") end,
  },
  { "jvgrootveld/telescope-zoxide" },
  { "nvim-telescope/telescope-live-grep-args.nvim" },
  {
    "nvim-telescope/telescope-project.nvim",
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
  },
  {
    "ikorihn/monorepo.nvim",
    config = function()
      require("monorepo").setup({
        autoload_telescope = false, -- Automatically loads the telescope extension at setup
      })
    end,
  },
  {
    "nvim-telescope/telescope-frecency.nvim",
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    branch = "main",
    config = function() require("pluginconfig/treesitter") end,
  },
  { "nvim-treesitter/nvim-treesitter-context" },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    init = function()
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
      vim.g.no_plugin_maps = true

      -- Or, disable per filetype (add as you like)
      -- vim.g.no_python_maps = true
      -- vim.g.no_ruby_maps = true
      -- vim.g.no_rust_maps = true
      -- vim.g.no_go_maps = true
    end,
  },

  -- Git
  {
    "lewis6991/gitsigns.nvim",
    config = function() require("pluginconfig/gitsigns") end,
  },
  { "ruanyl/vim-gh-line" },
  {
    "sindrets/diffview.nvim",
    config = function() require("pluginconfig/diffview") end,
  },
  {
    "FabijanZulj/blame.nvim",
    lazy = false,
    config = function()
      require("blame").setup({
        date_format = "%Y-%m-%d",
        virtual_style = "float",
        focus_blame = true,
        merge_consecutive = false,
        max_summary_width = 30,
        blame_options = { "-w" },
        mappings = {
          commit_info = "i",
          stack_push = "[",
          stack_pop = "]",
          show_commit = "<CR>",
          close = { "<esc>", "q" },
        },
      })
    end,
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
}

require("lazy").setup(plugins, {
  defaults = {
    lazy = false,
  },
})
