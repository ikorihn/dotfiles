-- 汎用のキーマップ定義
-- プラグイン固有のキーマップは lua/plugins.lua の各spec、または lua/pluginconfig/ に置く
local utils = require("utils")

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
