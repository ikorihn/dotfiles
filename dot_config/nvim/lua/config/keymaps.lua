-- キーマップ定義
local utils = require("utils")

local M = {}

-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = {}

-- leader key
keymap("", ",", "<Nop>", opts)
vim.g.mapleader = ","

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Disable --

vim.keymap.set("n", "ZQ", "<Nop>")
vim.keymap.set("n", "ZZ", "<Nop>")
vim.keymap.set("n", "gQ", "<Nop>")

-- Normal --

-- Quickfix
keymap("n", "<C-n>", ":cnext<CR>", opts)
keymap("n", "<C-p>", ":cprevious<CR>", opts)

-- Tab
keymap("n", "te", ":tabedit")
keymap("n", "tn", ":tabnew<Return>")

-- Change tab width
keymap("n", "ts2", ":setl shiftwidth=2 softtabstop=2<CR>")
keymap("n", "ts4", ":setl shiftwidth=4 softtabstop=4<CR>")
keymap("n", "tst", ":setl noexpandtab<CR>")

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)

-- Macro
keymap("n", "@", "@q", opts)

-- Yank
keymap("n", "x", '"_x', opts)
keymap("n", "Y", "y$", opts)
keymap("v", "<C-p>", '"0p', opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move the selected region up or down
keymap("v", "<C-j>", ":m '>+1<CR>gv=gv")
keymap("v", "<C-k>", ":m '<-2<CR>gv=gv")

-- Command --

-- Command line mode mapping emacs like
keymap("c", "<C-b>", "<Left>", opts)
keymap("c", "<C-f>", "<Right>", opts)
keymap("c", "<C-a>", "<Home>", opts)
keymap("c", "<C-e>", "<End>", opts)
keymap("c", "<C-d>", "<Del>", opts)

-- Function --

keymap("n", "<Leader>q", utils.ToggleQuickFix)
keymap("n", "gf", utils.OpenUrlOrFile)

keymap("", "<C-g><C-g>", ":echo expand('%:p:h')", opts)
keymap("", "<leader>vs", ":vert sb#<CR>", opts)

-- Plugins --

-- NvimTree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- Git
keymap("n", "<leader>gg", ":Neogit<CR>", opts)
keymap("n", "<leader>gb", ":BlameToggle<CR>", opts)

-- asterisk
keymap("", "*", "<Plug>(asterisk-z*)", opts)
keymap("", "#", "<Plug>(asterisk-z#)", opts)
keymap("", "g*", "<Plug>(asterisk-gz*)", opts)
keymap("", "g#", "<Plug>(asterisk-gz#)", opts)
-- hlslens
keymap("n", "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], opts)
keymap("n", "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], opts)

-- Bufferline

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

vim.keymap.set("n", "<leader>wl", "<CMD>BufferLineCloseRight<CR>")
vim.keymap.set("n", "<leader>wh", "<CMD>BufferLineCloseLeft<CR>")
vim.keymap.set("n", "<leader>wall", "<CMD>BufferLineCloseOthers<CR>")
vim.keymap.set("n", "<leader>ws", "<CMD>BufferLineSortByDirectory<CR>")

vim.keymap.set("n", "<S-l>", "<CMD>BufferLineCycleNext<CR>")
vim.keymap.set("n", "<S-h>", "<CMD>BufferLineCyclePrev<CR>")
vim.keymap.set("n", "<S-M-l>", "<CMD>BufferLineMoveNext<CR>")
vim.keymap.set("n", "<S-M-h>", "<CMD>BufferLineMovePrev<CR>")

-- Diffview
keymap("n", "<leader>dd", ":DiffviewOpen ")
keymap("n", "<leader>dm", ":DiffviewOpen main..HEAD")
keymap("n", "<leader>df", "<CMD>DiffviewFileHistory %<CR>", opts)

function M.setup_illuminate()
  keymap("n", "<a-n>", function()
    require("illuminate").next_reference({ wrap = true })
  end)
  keymap("n", "<a-p>", function()
    require("illuminate").next_reference({ reverse = true, wrap = true })
  end)
end

function M.setup_noice()
  keymap("n", "<leader>nd", "<cmd>Noice dismiss<CR>")
end

function M.setup_jsonpath()
  keymap("n", "y<C-p>", function()
    vim.fn.setreg("+", require("jsonpath").get())
  end, { desc = "copy json path", buffer = true })
end

function M.setup_luasnip(ls)
  keymap({ "i", "s" }, "<C-J>", function()
    ls.jump(1)
  end, { silent = true })
  keymap({ "i", "s" }, "<C-K>", function()
    ls.jump(-1)
  end, { silent = true })
end

function M.cmp(cmp, luasnip)
  local function has_words_before()
    if vim.api.nvim_get_option_value("buftype", {}) == "prompt" then
      return false
    end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
  end

  return cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() and has_words_before() then
        cmp.confirm({ select = true })
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  })
end

function M.setup_lsp(bufnr)
  local builtin = require("telescope.builtin")
  local lsp_opts = { noremap = true, silent = true, buffer = bufnr }

  keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", lsp_opts)
  keymap("n", "gd", function()
    builtin.lsp_definitions()
  end, opts)
  keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", lsp_opts)
  keymap("n", "gI", function()
    builtin.lsp_implementations({
      file_ignore_patterns = {
        "_test%.go",
        "/mock/",
        "mock_.*%.go",
      },
    })()
  end, opts)
  keymap("n", "gr", function()
    builtin.lsp_references({
      file_ignore_patterns = {
        "_test.go",
        "/mock/",
        "mock_.*%.go",
      },
    })
  end, opts)
  keymap("n", "gi", function()
    builtin.lsp_incoming_calls()
  end, opts)
  keymap("n", "go", function()
    builtin.lsp_outgoing_calls()
  end, opts)
  keymap("n", "gl", function()
    builtin.diagnostics()
  end, opts)
  keymap("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", lsp_opts)
  keymap("n", "<Space><Space>", ":lua vim.lsp.buf.", { noremap = true, buffer = bufnr })
  keymap("n", "<Space>l", ":lua require('telescope.builtin').", { noremap = true, buffer = bufnr })
  keymap("n", "<Space>f", "<cmd>lua vim.lsp.buf.format()<cr>", lsp_opts)
  keymap("n", "<Space>a", "<cmd>lua vim.lsp.buf.code_action()<cr>", lsp_opts)
  keymap("n", "<Space>j", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", lsp_opts)
  keymap("n", "<Space>k", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", lsp_opts)
  keymap("n", "<Space>r", "<cmd>lua vim.lsp.buf.rename()<cr>", lsp_opts)
  keymap("n", "<Space>s", "<cmd>lua vim.lsp.buf.signature_help()<CR>", lsp_opts)
  keymap("n", "<Space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", lsp_opts)

  keymap("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", lsp_opts)
  keymap("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", lsp_opts)
  keymap("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", lsp_opts)
  keymap("n", "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", lsp_opts)
  keymap("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", lsp_opts)
  keymap("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", lsp_opts)

  keymap("n", "<leader>{", "<cmd>AerialPrev<CR>", lsp_opts)
  keymap("n", "<leader>}", "<cmd>AerialNext<CR>", lsp_opts)
  keymap("n", "<leader>a", "<cmd>AerialToggle!<CR>", opts)
end

function M.setup_gitsigns(bufnr, gitsigns)
  vim.api.nvim_create_autocmd("OptionSet", {
    pattern = "diff",
    desc = "Map q to exit gitsigns diff mode",
    callback = function(event)
      keymap("n", "q", function()
        if not vim.wo.diff then
          return "q"
        end

        local target_win
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          local buf = vim.api.nvim_win_get_buf(win)
          local bufname = vim.api.nvim_buf_get_name(buf)
          if bufname:find("^gitsigns://") then
            target_win = win
            break
          end
        end
        if target_win then
          vim.schedule(function()
            vim.api.nvim_win_close(target_win, true)
          end)
          return ""
        end

        return "q"
      end, { expr = true, buffer = event.buf })
    end,
  })

  local function buffer_keymap(mode, lhs, rhs, map_opts)
    map_opts = map_opts or {}
    map_opts.buffer = bufnr
    keymap(mode, lhs, rhs, map_opts)
  end

  buffer_keymap("n", "]c", function()
    if vim.wo.diff then
      vim.cmd.normal({ "]c", bang = true })
    else
      gitsigns.nav_hunk("next")
    end
  end)
  buffer_keymap("n", "[c", function()
    if vim.wo.diff then
      vim.cmd.normal({ "[c", bang = true })
    else
      gitsigns.nav_hunk("prev")
    end
  end)

  buffer_keymap("n", "<leader>gs", gitsigns.stage_hunk)
  buffer_keymap("n", "<leader>gr", gitsigns.reset_hunk)
  buffer_keymap("v", "<leader>gs", function()
    gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
  end)
  buffer_keymap("v", "<leader>gr", function()
    gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
  end)
  buffer_keymap("n", "<leader>gS", gitsigns.stage_buffer)
  buffer_keymap("n", "<leader>gu", gitsigns.undo_stage_hunk)
  buffer_keymap("n", "<leader>gR", gitsigns.reset_buffer)
  buffer_keymap("n", "<leader>gp", gitsigns.preview_hunk)
  buffer_keymap("n", "<leader>gB", function()
    gitsigns.blame_line({ full = true })
  end)
  buffer_keymap("n", "<leader>gd", gitsigns.diffthis)
  buffer_keymap("n", "<leader>gD", function()
    gitsigns.diffthis("~")
  end)
  buffer_keymap("n", "<leader>tb", gitsigns.toggle_current_line_blame)
  buffer_keymap("n", "<leader>td", gitsigns.toggle_deleted)
  buffer_keymap({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
end

function M.setup_nvim_tree(bufnr, api, treeutils)
  local function tree_opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  local function mark_move(direction)
    api.marks.toggle()
    vim.cmd("norm " .. direction)
  end

  local function marked_nodes()
    local marks = api.marks.list()
    if #marks == 0 then
      table.insert(marks, api.tree.get_node_under_cursor())
    end
    return marks
  end

  local function mark_trash()
    local marks = marked_nodes()
    vim.ui.input({ prompt = string.format("Trash %s files? [y/n] ", #marks) }, function(input)
      if input ~= "y" then
        return
      end
      for _, node in ipairs(marks) do
        api.fs.trash(node)
      end
      api.marks.clear()
      api.tree.reload()
    end)
  end

  local function mark_remove()
    local marks = marked_nodes()
    vim.ui.input({ prompt = string.format("Remove/Delete %s files? [y/n] ", #marks) }, function(input)
      if input ~= "y" then
        return
      end
      for _, node in ipairs(marks) do
        api.fs.remove(node)
      end
      api.marks.clear()
      api.tree.reload()
    end)
  end

  local function mark_copy()
    for _, node in pairs(marked_nodes()) do
      api.fs.copy.node(node)
    end
    api.marks.clear()
    api.tree.reload()
  end

  local function mark_cut()
    for _, node in pairs(marked_nodes()) do
      api.fs.cut(node)
    end
    api.marks.clear()
    api.tree.reload()
  end

  api.config.mappings.default_on_attach(bufnr)
  keymap("n", "p", api.fs.paste, tree_opts("Paste"))
  keymap("n", "<TAB>", function()
    mark_move("j")
  end, tree_opts("Toggle Bookmark Down"))
  keymap("n", "<S-TAB>", function()
    mark_move("k")
  end, tree_opts("Toggle Bookmark Up"))
  keymap("n", "x", mark_cut, tree_opts("Cut File(s)"))
  keymap("n", "d", mark_remove, tree_opts("Remove File(s)"))
  keymap("n", "D", mark_trash, tree_opts("Trash File(s)"))
  keymap("n", "C", mark_copy, tree_opts("Copy File(s)"))
  keymap("n", "h", api.node.navigate.parent_close, tree_opts("Close Directory"))
  keymap("n", "H", api.tree.collapse_all, tree_opts("Collapse All"))
  keymap("n", "l", api.node.open.edit, tree_opts("Open"))
  keymap("n", "v", api.node.open.vertical, tree_opts("Open: Vertical Split"))
  keymap("n", "<c-f>", treeutils.launch_find_files, tree_opts("Launch Find Files"))
  keymap("n", "<c-g>", treeutils.launch_live_grep, tree_opts("Launch Live Grep"))
  keymap("n", "<CR>", api.node.open.tab_drop, tree_opts("Tab drop"))
end

function M.setup_telescope(telescope, builtin, actions)
  local function multi_select()
    return {
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local state = require("telescope.actions.state")
          local picker = state.get_current_picker(prompt_bufnr)
          local multi = picker:get_multi_selection()
          local single = picker:get_selection()
          local command = ""
          if #multi > 0 then
            for _, selection in pairs(multi) do
              command = command .. "edit " .. selection[1] .. " | "
            end
          end
          command = command .. "edit " .. single[1]
          actions.close(prompt_bufnr)
          vim.api.nvim_command(command)
        end)
        return true
      end,
      hidden = true,
      follow = true,
    }
  end

  keymap("n", "<leader>f,", ":Telescope ")
  keymap("n", "<leader>ff", function()
    builtin.find_files(multi_select())
  end, opts)
  keymap("n", "<leader>ft", function()
    builtin.grep_string({ path_display = { "smart" }, word_match = "-w", only_sort_text = true, search = "" })
  end, opts)
  keymap("n", "<leader>fG", builtin.git_files, opts)
  keymap("n", "<leader>fh", builtin.command_history, opts)
  keymap("n", "<leader>fb", builtin.buffers, opts)
  keymap("n", "ga.", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Telescope" })
  keymap("v", "ga.", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Telescope" })
  keymap("n", "<leader>f.", telescope.extensions.chezmoi.find_files, {})
  keymap("n", "<leader>cd", telescope.extensions.zoxide.list)
  keymap("n", "<leader>mm", function()
    telescope.extensions.monorepo.monorepo()
  end)
  keymap("n", "<leader>mn", function()
    require("monorepo").toggle_project()
  end)
  keymap("n", "<leader>fg", function()
    telescope.extensions.live_grep_args.live_grep_args()
  end)
end

function M.telescope_config(actions, z_utils, lga_actions)
  return {
    defaults = {
      i = {
        ["<Down>"] = actions.cycle_history_next,
        ["<Up>"] = actions.cycle_history_prev,
        ["<ESC>"] = false,
        ["<C-u>"] = false,
        ["<C-j>"] = actions.smart_send_to_qflist + actions.open_qflist,
        ["<C-i>"] = "which_key",
        ["<C-d>"] = actions.delete_buffer,
      },
      n = {
        ["<C-d>"] = actions.delete_buffer,
        ["<C-j>"] = actions.smart_send_to_qflist + actions.open_qflist,
      },
    },
    zoxide = {
      default = {
        after_action = function(selection)
          print("Update to (" .. selection.z_score .. ") " .. selection.path)
        end,
      },
      ["<C-s>"] = {
        before_action = function()
          print("before C-s")
        end,
        action = function(selection)
          vim.cmd.edit(selection.path)
        end,
      },
      ["<C-q>"] = { action = z_utils.create_basic_command("split") },
    },
    live_grep_args = {
      i = {
        ["<C-k>"] = lga_actions.quote_prompt(),
        ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
        ["<C-space>"] = lga_actions.to_fuzzy_refine,
      },
    },
  }
end

function M.diffview(actions)
  return {
    view = {
      { "n", "q", actions.close, { desc = "Close" } },
    },
    file_panel = {
      { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close" } },
    },
    file_history_panel = {
      { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close" } },
    },
  }
end

function M.blame()
  return {
    commit_info = "i",
    stack_push = "[",
    stack_pop = "]",
    show_commit = "<CR>",
    close = { "<esc>", "q" },
  }
end

function M.setup_treesitter()
  local select = require("nvim-treesitter-textobjects.select")
  keymap({ "x", "o" }, "am", function()
    select.select_textobject("@function.outer", "textobjects")
  end)
  keymap({ "x", "o" }, "im", function()
    select.select_textobject("@function.inner", "textobjects")
  end)
  keymap({ "x", "o" }, "ac", function()
    select.select_textobject("@class.outer", "textobjects")
  end)
  keymap({ "x", "o" }, "ic", function()
    select.select_textobject("@class.inner", "textobjects")
  end)
  keymap({ "x", "o" }, "as", function()
    select.select_textobject("@local.scope", "locals")
  end)
end

function M.setup_hop()
  keymap("n", "f", "<cmd>lua require'my.local.hop'.hint_char1()<cr>", { noremap = true })
end

return M
