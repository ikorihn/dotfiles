-- Telescope (ファジーファインダー) と拡張
return {
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
}
