-- Git連携
return {
  -- 変更行の表示・hunk操作 (キーマップは pluginconfig/gitsigns.lua の on_attach)
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
        keymaps = {
          view = {
            { "n", "q", actions.close, { desc = "Close" } },
          },
          file_panel = {
            { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close" } },
          },
          file_history_panel = {
            { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close" } },
          },
        },
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
      mappings = {
        commit_info = "i",
        stack_push = "[",
        stack_pop = "]",
        show_commit = "<CR>",
        close = { "<esc>", "q" },
      },
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
}
