local utils = require('utils')

-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { }

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

-- Move the selected region up or down
keymap("v", "<C-j>", ":m '>+1<CR>gv=gv")
keymap("v", "<C-k>", ":m '<-2<CR>gv=gv")

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

-- Git
keymap("n", "<leader>gg", "<cmd>lua _TIG()<CR>", opts)
keymap("n", "<leader>gb", ":TigBlame<CR>", opts)

-- transparent
keymap('n', '<leader>tt', ":TransparentToggle<CR>", opts)

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
-- hlslens
keymap('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], opts)
keymap('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], opts)

-- IndentWise
keymap("", "<C-k>",  "<Plug>(IndentWisePreviousEqualIndent)", opts)
keymap("", "<C-j>",  "<Plug>(IndentWiseNextEqualIndent)", opts)

-- hop
--keymap("", 'f', "<cmd>lua require'hop'.hint_char1({ direction = require('hop.hint').HintDirection.AFTER_CURSOR, current_line_only = true })<CR>", opts)
--keymap("", 'F', "<cmd>lua require'hop'.hint_char1({ direction = require('hop.hint').HintDirection.BEFORE_CURSOR, current_line_only = true })<CR>", opts)
--keymap("", 't', "<cmd>lua require'hop'.hint_char1({ direction = require('hop.hint').HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<CR>", opts)
--keymap("", 'T', "<cmd>lua require'hop'.hint_char1({ direction = require('hop.hint').HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<CR>", opts)
keymap("", 's', "<cmd>lua require'hop'.hint_char2()<CR>", opts)

-- EasyAlign
keymap("x", "ga",  "<Plug>(EasyAlign)", opts)
keymap("n", "ga",  "<Plug>(EasyAlign)", opts)

function LspKeymaps(bufnr)
  local builtin = require("telescope.builtin")
  local lsp_opts = { noremap = true, silent = true }

  vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", lsp_opts)
  keymap("n", "gd", function() builtin.lsp_definitions() end, opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", lsp_opts)
  keymap("n", "gI", function() builtin.lsp_implementations() end, opts)
  keymap("n", "gr", function() builtin.lsp_references() end, opts)
  keymap("n", "gi", function() builtin.lsp_incoming_calls() end, opts)
  keymap("n", "go", function() builtin.lsp_outgoing_calls() end, opts)
  keymap("n", "gl", function() builtin.diagnostics() end, opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", lsp_opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<Space><Space>", ":lua vim.lsp.buf.", { noremap = true })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<Space>l", ":lua require('telescope.builtin').", { noremap = true })
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<Space>f", "<cmd>lua vim.lsp.buf.format()<cr>", lsp_opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<Space>a", "<cmd>lua vim.lsp.buf.code_action()<cr>", lsp_opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<Space>j", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", lsp_opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<Space>k", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", lsp_opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<Space>r", "<cmd>lua vim.lsp.buf.rename()<cr>", lsp_opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<Space>s", "<cmd>lua vim.lsp.buf.signature_help()<CR>", lsp_opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<Space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", lsp_opts)
end
