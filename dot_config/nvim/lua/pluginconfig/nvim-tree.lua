local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

local api_status_ok, api = pcall(require, "nvim-tree.api")
if not api_status_ok then
  return
end

local treeutils = require("pluginconfig.nvim-tree-utils")

local function on_attach(bufnr)
  require("config.keymaps").setup_nvim_tree(bufnr, api, treeutils)
end

local HEIGHT_RATIO = 0.8
local WIDTH_RATIO = 0.5

nvim_tree.setup({
  sort_by = "case_sensitive",
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  on_attach = on_attach,
  update_focused_file = {
    enable = true,
    update_root = true,
    update_cwd = true,
  },
  renderer = {
    root_folder_modifier = ":t",
    group_empty = true,
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
  },
  view = {
    float = {
      enable = false,
      open_win_config = function()
        local screen_w = vim.opt.columns:get()
        local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
        local window_w = screen_w * WIDTH_RATIO
        local window_h = screen_h * HEIGHT_RATIO
        local window_w_int = math.floor(window_w)
        local window_h_int = math.floor(window_h)
        local center_x = (screen_w - window_w) / 2
        local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
        return {
          border = "rounded",
          relative = "editor",
          row = center_y,
          col = center_x,
          width = window_w_int,
          height = window_h_int,
        }
      end,
    },
    -- width = function() return math.floor(vim.opt.columns:get() * WIDTH_RATIO) end,
    width = 30,
  },
  ui = {
    confirm = {
      remove = false,
      trash = false,
      default_yes = true,
    },
  },
})
