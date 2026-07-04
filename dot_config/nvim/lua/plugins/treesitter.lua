-- Treesitter (ハイライト・インデント・テキストオブジェクト)
return {
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
}
