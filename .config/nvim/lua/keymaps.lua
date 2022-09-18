local utils = require('utils')

-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

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

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
-- Quickfix
keymap("n", "<C-n>", ":cnext<CR>", opts)
keymap("n", "<C-p>", ":cprevious<CR>", opts)

-- Tab
keymap("n", "te", ":tabedit %:h")
keymap("n", "tn", ":tabnew<Return>")

-- Change tab width
keymap("n", "ts2", ":setl shiftwidth=2 softtabstop=2<CR>")
keymap("n", "ts4", ":setl shiftwidth=4 softtabstop=4<CR>")
keymap("n", "tst", ":setl noexpandtab<CR>")

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)

-- Macro
keymap("n", "q", function ()
    local macro_reg = vim.fn.reg_recording() .. vim.fn.reg_executing()
    return macro_reg == "" and "qq" or "q"
  end, { expr = true })
keymap("n", "@", "@q", opts)

-- Indent keybind for shutcut
-- keymap("n", ">", ">>", opts)
-- keymap("n", "<", "<<", opts)

-- Yank
keymap("n", "x", '"_x', opts)
keymap("n", "Y", 'y$', opts)
keymap("v", "<C-p>", '"0p', opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Better paste
-- keymap("v", "p", '"_dP', opts)

-- Command --

-- Command line mode mapping emacs like
keymap("c", "<C-b>", '<Left>', opts)
keymap("c", "<C-f>", '<Right>', opts)
keymap("c", "<C-a>", '<Home>', opts)
keymap("c", "<C-e>", '<End>', opts)
keymap("c", "<C-d>", '<Del>', opts)

-- Function --

keymap("n", "<Leader>q", utils.ToggleQuickFix)

-- Plugins --

-- NvimTree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- Telescope
function multi_select()
  local opts_ff = { attach_mappings = function(prompt_bufnr, map)
    local actions = require "telescope.actions"
    actions.select_default:replace(
      function(prompt_bufnr)
        local actions = require "telescope.actions"
        local state = require "telescope.actions.state"
        local picker = state.get_current_picker(prompt_bufnr)
        local multi = picker:get_multi_selection()
        local single = picker:get_selection()
        local str = ""
        if #multi > 0 then
          for i,j in pairs(multi) do
            str = str.."edit "..j[1].." | "
          end
        end
        str = str.."edit "..single[1]
        -- To avoid populating qf or doing ":edit! file", close the prompt first
        actions.close(prompt_bufnr)
        vim.api.nvim_command(str)
      end)
    return true
  end,
  hidden = true,
  follow = true,
  }
  return require("telescope.builtin").find_files(opts_ff)
end
keymap('n', '<leader>f,', ":Telescope ")
keymap('n', '<leader>ff', multi_select, opts)
keymap("n", "<leader>f.", "<cmd>lua require('telescope.builtin').find_files({ search_dirs = { '~/.config/nvim', '~/.config/zsh', '~/.config/karabiner', '~/.config/wezterm' }, hidden = true, follow = true })<cr>", opts)
keymap("n", "<leader>fg", ":Telescope git_files<CR>", opts)
keymap("n", "<leader>ft", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>fp", ":Telescope projects<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)

-- Git
keymap("n", "<leader>gg", "<cmd>lua _TIG()<CR>", opts)
keymap("n", "<leader>gb", ":TigBlame<CR>", opts)
-- Gitsigns
keymap('n', ']c', function()
  if vim.wo.diff then return ']c' end
  vim.schedule(function() require('gitsigns').next_hunk() end)
  return '<Ignore>'
end, {expr=true})
keymap('n', '[c', function()
  if vim.wo.diff then return '[c' end
  vim.schedule(function() require('gitsigns').prev_hunk() end)
  return '<Ignore>'
end, {expr=true})
keymap({'n', 'v'}, '<leader>gs', require('gitsigns').stage_hunk)
keymap({'n', 'v'}, '<leader>gr', require('gitsigns').reset_hunk)
keymap('n', '<leader>gu', require('gitsigns').undo_stage_hunk)
keymap('n', '<leader>gp', require('gitsigns').preview_hunk)
keymap('n', '<leader>gB', function() require('gitsigns').blame_line{full=true} end)
keymap('n', '<leader>gd', require('gitsigns').diffthis)
keymap('n', '<leader>gD', function() require('gitsigns').diffthis('~') end)
keymap('n', '<leader>td', require('gitsigns').toggle_deleted)

-- Comment
keymap("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", opts)
keymap("x", "<leader>/", '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>')

-- DAP
keymap("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", opts)
keymap("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", opts)
keymap("n", "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", opts)
keymap("n", "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", opts)
keymap("n", "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", opts)
keymap("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", opts)
keymap("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", opts)
keymap("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>", opts)
keymap("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>", opts)

-- asterisk
keymap("", "*",  "<Plug>(asterisk-z*)", opts)
keymap("", "#",  "<Plug>(asterisk-z#)", opts)
keymap("", "g*", "<Plug>(asterisk-gz*)", opts)
keymap("", "g#", "<Plug>(asterisk-gz#)", opts)

-- IndentWise
keymap("", "<C-k>",  "<Plug>(IndentWisePreviousEqualIndent)", opts)
keymap("", "<C-j>",  "<Plug>(IndentWiseNextEqualIndent)", opts)

-- pounce
keymap("n", "s",  "<cmd>Pounce<CR>", opts)
keymap("n", "S",  "<cmd>PounceRepeat<CR>", opts)
keymap("v", "s",  "<cmd>Pounce<CR>", opts)

-- hlslens
keymap('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], opts)
keymap('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], opts)

-- EasyAlign
keymap("x", "ga",  "<Plug>(EasyAlign)", opts)
keymap("n", "ga",  "<Plug>(EasyAlign)", opts)

function LspKeymaps(bufnr)
  local lsp_opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", lsp_opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", lsp_opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", lsp_opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", lsp_opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", lsp_opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", lsp_opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<Space><Space>", ":lua vim.lsp.buf.", { noremap = true })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<Space>f", "<cmd>lua vim.lsp.buf.formatting()<cr>", lsp_opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<Space>i", "<cmd>LspInfo<cr>", lsp_opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<Space>I", ":LspInstall", lsp_opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<Space>a", "<cmd>lua vim.lsp.buf.code_action()<cr>", lsp_opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<Space>j", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", lsp_opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<Space>k", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", lsp_opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<Space>r", "<cmd>lua vim.lsp.buf.rename()<cr>", lsp_opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<Space>s", "<cmd>lua vim.lsp.buf.signature_help()<CR>", lsp_opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<Space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", lsp_opts)
end


