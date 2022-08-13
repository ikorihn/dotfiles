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
keymap("n", "te", ":tabedit ")
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
keymap("n", ">", ">>", opts)
keymap("n", "<", "<<", opts)

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
keymap("v", "p", '"_dP', opts)

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
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>fg", ":Telescope git_files<CR>", opts)
keymap("n", "<leader>ft", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>fp", ":Telescope projects<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)

-- Git
keymap("n", "<leader>gg", "<cmd>lua _TIG()<CR>", opts)
keymap("n", "<leader>gb", ":TigBlame<CR>", opts)

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

-- Hop
keymap("n", '<leader>hh', "<cmd>lua require'hop'.hint_char1()<cr>", opts)
keymap("n", '<leader>hw', "<cmd>lua require'hop'.hint_words()<cr>", opts)

-- edgemotion
keymap("n", '<C-j>', "<Plug>(edgemotion-j)", opts)
keymap("n", '<C-k>', "<Plug>(edgemotion-k)", opts)

-- asterisk
keymap("", "*",  "<Plug>(asterisk-z*)", opts)
keymap("", "#",  "<Plug>(asterisk-z#)", opts)
keymap("", "g*", "<Plug>(asterisk-gz*)", opts)
keymap("", "g#", "<Plug>(asterisk-gz#)", opts)

-- EasyAlign
keymap("x", "ga",  "<Plug>(EasyAlign)", opts)
keymap("n", "ga",  "<Plug>(EasyAlign)", opts)
