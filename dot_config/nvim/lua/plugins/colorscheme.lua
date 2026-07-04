return {
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

  -- 予備のカラースキーム
  { "folke/tokyonight.nvim" },
}
