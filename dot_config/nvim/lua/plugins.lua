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
  { "nvim-lua/plenary.nvim"  }, -- Useful lua functions used by lots of plugins
  -- { "windwp/nvim-autopairs", config = function() require("pluginconfig/autopairs") end },
  { "numToStr/Comment.nvim", config = function() require("pluginconfig/comment") end },
  { "JoosepAlviste/nvim-ts-context-commentstring" },
  { "lewis6991/impatient.nvim", config = function() require("pluginconfig/impatient") end },
  { "phaazon/hop.nvim", config = function() require("pluginconfig/hop") end },
  { "kevinhwang91/nvim-hlslens", config = function() require("pluginconfig/nvim-hlslens") end },

  { "oneubauer/jsonpath.nvim", branch ="oneubauer/add-yaml-support", ft = { "json", "yaml" }, config = function() require("pluginconfig/jsonpath") end },
  { "iamcco/markdown-preview.nvim", cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" }, build = "cd app && yarn install", init = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" } },

  { "kylechui/nvim-surround", config = function() require("pluginconfig/nvim-surround") end },
  { "jeetsukumaran/vim-indentwise" },
  { "haya14busa/vim-asterisk" },
  { "junegunn/vim-easy-align" },
  -- { "xiyaowong/nvim-transparent", config = function() require("pluginconfig/transparent") end },
  { "johmsalas/text-case.nvim", config = function() require("pluginconfig/text-case") end },

  -- Colorschemes
  { "EdenEast/nightfox.nvim" },
  { "folke/tokyonight.nvim" },
  { "ellisonleao/gruvbox.nvim" },
  { "lunarvim/darkplus.nvim" },

  -- filer, status
  { "nvim-tree/nvim-web-devicons" },
  { "nvim-tree/nvim-tree.lua", config = function() require("pluginconfig/nvim-tree") end },
  -- { "akinsho/bufferline.nvim", version = "v3.*", dependencies = 'nvim-tree/nvim-web-devicons', config = function() require("pluginconfig/bufferline") end },
  { "moll/vim-bbye" },
  { "nvim-lualine/lualine.nvim", config = function() require("pluginconfig/lualine") end },
  { "akinsho/toggleterm.nvim", config = function() require("pluginconfig/toggleterm") end },
  { "ahmedkhalf/project.nvim", config = function() require("pluginconfig/project") end },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", config = function() require("pluginconfig/indentline") end },
  { "RRethy/vim-illuminate", config = function() require("pluginconfig/illuminate") end },
  { "ntpeters/vim-better-whitespace" },
  { "folke/which-key.nvim", config = function() require("pluginconfig/which-key") end },

  -- cmp plugins
  { "hrsh7th/nvim-cmp", config = function() require("pluginconfig/cmp") end }, -- The completion plugin
  { "hrsh7th/cmp-buffer" }, -- buffer completions
  { "hrsh7th/cmp-path" }, -- path completions
  { "saadparwaiz1/cmp_luasnip" }, -- snippet completions
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-nvim-lua" },

  -- snippets
  {
    "L3MON4D3/LuaSnip",
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
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
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "jose-elias-alvarez/null-ls.nvim" }, -- for formatters and linters
  { "glepnir/lspsaga.nvim" }, -- LSP UIs
  { "simrat39/rust-tools.nvim" }, -- LSP UIs

  -- Testing
  { "klen/nvim-test", config = function() require("pluginconfig/nvim-test") end },
  { "yanskun/gotests.nvim", ft = "go", config = function() require('gotests').setup() end },

  -- Telescope
  { "nvim-telescope/telescope.nvim", config = function() require("pluginconfig/telescope") end },

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", config = function() require("pluginconfig/treesitter") end },
  { "nvim-treesitter/nvim-treesitter-context" },
  { "nvim-treesitter/nvim-treesitter-textobjects" },

  -- Git
  { "lewis6991/gitsigns.nvim", config = function() require("pluginconfig/gitsigns") end },
  { "rbgrouleff/bclose.vim" },
  { "iberianpig/tig-explorer.vim", dependencies= {"rbgrouleff/bclose.vim"} },
  { "ruanyl/vim-gh-line" },

  -- DAP
  { "mfussenegger/nvim-dap", config = function() require("pluginconfig/dap") end },
  { "rcarriga/nvim-dap-ui" },
  { "ravenxrz/DAPInstall.nvim" },
}

require('lazy').setup(plugins, {
  defaults = {
    lazy = false,
  },
})
