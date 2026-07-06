-- 補完・スニペット
return {
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
}
