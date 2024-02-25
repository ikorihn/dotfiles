local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then return end

local api_status_ok, api = pcall(require, "nvim-tree.api")
if not api_status_ok then return end

local treeutils = require("pluginconfig/nvim-tree-utils")

local function opts(bufnr, desc)
  return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
end

local function bulk_operation(bufnr)
  -- mark operation
  local mark_move_j = function()
    api.marks.toggle()
    vim.cmd("norm j")
  end
  local mark_move_k = function()
    api.marks.toggle()
    vim.cmd("norm k")
  end

  -- marked files operation
  local mark_trash = function()
    local marks = api.marks.list()
    if #marks == 0 then table.insert(marks, api.tree.get_node_under_cursor()) end
    vim.ui.input({ prompt = string.format("Trash %s files? [y/n] ", #marks) }, function(input)
      if input == "y" then
        for _, node in ipairs(marks) do
          api.fs.trash(node)
        end
        api.marks.clear()
        api.tree.reload()
      end
    end)
  end
  local mark_remove = function()
    local marks = api.marks.list()
    if #marks == 0 then table.insert(marks, api.tree.get_node_under_cursor()) end
    vim.ui.input({ prompt = string.format("Remove/Delete %s files? [y/n] ", #marks) }, function(input)
      if input == "y" then
        for _, node in ipairs(marks) do
          api.fs.remove(node)
        end
        api.marks.clear()
        api.tree.reload()
      end
    end)
  end

  local mark_copy = function()
    local marks = api.marks.list()
    if #marks == 0 then table.insert(marks, api.tree.get_node_under_cursor()) end
    for _, node in pairs(marks) do
      api.fs.copy.node(node)
    end
    api.marks.clear()
    api.tree.reload()
  end
  local mark_cut = function()
    local marks = api.marks.list()
    if #marks == 0 then table.insert(marks, api.tree.get_node_under_cursor()) end
    for _, node in pairs(marks) do
      api.fs.cut(node)
    end
    api.marks.clear()
    api.tree.reload()
  end

  vim.keymap.set("n", "p", api.fs.paste, opts(bufnr, "Paste"))
  vim.keymap.set("n", "<TAB>", mark_move_j, opts(bufnr, "Toggle Bookmark Down"))
  vim.keymap.set("n", "<S-TAB>", mark_move_k, opts(bufnr, "Toggle Bookmark Up"))

  vim.keymap.set("n", "x", mark_cut, opts(bufnr, "Cut File(s)"))
  vim.keymap.set("n", "d", mark_remove, opts(bufnr, "Remove File(s)"))
  vim.keymap.set("n", "D", mark_trash, opts(bufnr, "Trash File(s)"))
  vim.keymap.set("n", "C", mark_copy, opts(bufnr, "Copy File(s)"))
end

local function on_attach(bufnr)
  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set("n", "h", api.node.navigate.parent_close, opts(bufnr, "Close Directory"))
  vim.keymap.set("n", "H", api.tree.collapse_all, opts(bufnr, "Collapse All"))
  vim.keymap.set("n", "l", api.node.open.edit, opts(bufnr, "Open"))
  vim.keymap.set("n", "v", api.node.open.vertical, opts(bufnr, "Open: Vertical Split"))
  vim.keymap.set("n", "<c-f>", treeutils.launch_find_files, opts(bufnr, "Launch Find Files"))
  vim.keymap.set("n", "<c-g>", treeutils.launch_live_grep, opts(bufnr, "Launch Live Grep"))
  vim.keymap.set("n", "<CR>", api.node.open.tab_drop, opts(bufnr, "Tab drop"))
  bulk_operation(bufnr)
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
      remove = true,
      trash = false,
      default_yes = true,
    },
  },
})
