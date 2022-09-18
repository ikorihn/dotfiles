local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

local util = require("packer.util")
-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return util.float { border = "rounded" }
    end,
  },
}

local nocode = function()
  return vim.g.vscode == nil
end

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here

  use { "wbthomason/packer.nvim" } -- Have packer manage itself
  use { "nvim-lua/plenary.nvim" } -- Useful lua functions used by lots of plugins

  use { "windwp/nvim-autopairs" }
  use { "numToStr/Comment.nvim" }
  use { "JoosepAlviste/nvim-ts-context-commentstring" }
  use { "lewis6991/impatient.nvim" }
  use { "rlane/pounce.nvim" }
  use { "kevinhwang91/nvim-hlslens", cond = { nocode }  }

  use { "kylechui/nvim-surround" }
  use { "jeetsukumaran/vim-indentwise" }
  use { "haya14busa/vim-asterisk" }
  use { "junegunn/vim-easy-align" }

  -- Colorschemes
  use { "EdenEast/nightfox.nvim" }
  use { "folke/tokyonight.nvim" }
  use { "ellisonleao/gruvbox.nvim" }
  use { "lunarvim/darkplus.nvim" }

  -- filer, status
  use { "kyazdani42/nvim-web-devicons" }
  use { "kyazdani42/nvim-tree.lua" }
  use { "akinsho/bufferline.nvim" }
  use { "moll/vim-bbye" }
  use { "nvim-lualine/lualine.nvim" }
  use { "akinsho/toggleterm.nvim" }
  use { "ahmedkhalf/project.nvim" }
  use { "lukas-reineke/indent-blankline.nvim" }
  use { "RRethy/vim-illuminate", cond = { nocode } }
  use { "ntpeters/vim-better-whitespace" }
  use { "folke/which-key.nvim" }

  -- cmp plugins
  use { "hrsh7th/nvim-cmp" } -- The completion plugin
  use { "hrsh7th/cmp-buffer" } -- buffer completions
  use { "hrsh7th/cmp-path" } -- path completions
  use { "saadparwaiz1/cmp_luasnip" } -- snippet completions
  use { "hrsh7th/cmp-nvim-lsp" }
  use { "hrsh7th/cmp-nvim-lua" }

  -- snippets
  use { "L3MON4D3/LuaSnip" } --snippet engine
  use { "rafamadriz/friendly-snippets" } -- a bunch of snippets to use

  -- LSP
  use { "neovim/nvim-lspconfig" } -- enable LSP
  use { "williamboman/mason.nvim" }
  use { "williamboman/mason-lspconfig.nvim" }
  use { "jose-elias-alvarez/null-ls.nvim" } -- for formatters and linters
  use { "glepnir/lspsaga.nvim" } -- LSP UIs

  -- Telescope
  use { "nvim-telescope/telescope.nvim" }

  -- Treesitter
  use { "nvim-treesitter/nvim-treesitter" }
  use { "nvim-treesitter/nvim-treesitter-context" }
  use { "nvim-treesitter/nvim-treesitter-textobjects" }

  -- Git
  use { "lewis6991/gitsigns.nvim" }
  use { "rbgrouleff/bclose.vim" }
  use { "iberianpig/tig-explorer.vim",
    requires = {{"rbgrouleff/bclose.vim", opt = true}}
  }

  -- DAP
  use { "mfussenegger/nvim-dap" }
  use { "rcarriga/nvim-dap-ui" }
  use { "ravenxrz/DAPInstall.nvim" }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
