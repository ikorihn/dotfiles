-- Plug
vim.cmd [[ call plug#begin(stdpath('data') . '/plugged') ]]
vim.cmd [[ Plug 'phaazon/hop.nvim' ]]
vim.cmd [[ Plug 'asvetliakov/vim-easymotion' ]]
vim.cmd [[ call plug#end() ]]

-- Keymap
vim.keymap.set("", ",", "<Nop>", {})
vim.g.mapleader = ","

-- EasyAlign
vim.keymap.set("n", "ga", "<Plug>(EasyAlign)")
vim.keymap.set("x", "ga", "<Plug>(EasyAlign)")

-- hop
local hop = require('hop')
hop.setup {
  keys = 'etovxqpdygfblzhckisuran',
}
local directions = require('hop.hint').HintDirection
local opt_hop = { remap=true }
vim.keymap.set('', 'f', function() hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true }) end, opt_hop)
vim.keymap.set('', 'F', function() hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true }) end, opt_hop)
vim.keymap.set('', 't', function() hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 }) end, opt_hop)
vim.keymap.set('', 'T', function() hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 }) end, opt_hop)
vim.keymap.set('', 's', function() hop.hint_char2() end, opt_hop)

