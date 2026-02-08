local status_ok, diffview = pcall(require, "diffview")
if not status_ok then return end

local actions = require("diffview.actions")

diffview.setup({
  view = {
    -- Configure the layout and behavior of different types of views.
    -- Available layouts:
    --  'diff1_plain'
    --    |'diff2_horizontal'
    --    |'diff2_vertical'
    --    |'diff3_horizontal'
    --    |'diff3_vertical'
    --    |'diff3_mixed'
    --    |'diff4_mixed'
    -- For more info, see |diffview-config-view.x.layout|.
    default = {
      -- Config for changed files, and staged files in diff views.
      layout = "diff2_horizontal",
      disable_diagnostics = false, -- Temporarily disable diagnostics for diff buffers while in the view.
      winbar_info = false, -- See |diffview-config-view.x.winbar_info|
    },
    merge_tool = {
      -- Config for conflicted files in diff views during a merge or rebase.
      layout = "diff3_horizontal",
      disable_diagnostics = true, -- Temporarily disable diagnostics for diff buffers while in the view.
      winbar_info = true, -- See |diffview-config-view.x.winbar_info|
    },
    file_history = {
      -- Config for changed files in file history views.
      layout = "diff2_horizontal",
      disable_diagnostics = false, -- Temporarily disable diagnostics for diff buffers while in the view.
      winbar_info = false, -- See |diffview-config-view.x.winbar_info|
    },
  },
  keymaps = {
    disable_defaults = false, -- Disable the default keymaps
    view = {
      { "n", "q", actions.close, { desc = "Close help menu" } },
    },
    file_panel = {
      { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close help menu" } },
    },
    file_history_panel = {
      { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close help menu" } },
    },
  },
})
