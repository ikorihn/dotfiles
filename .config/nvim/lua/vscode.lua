-- pack/*/start を読み込ませない
vim.opt.packpath = {}

-- Plug
vim.cmd [[ call plug#begin(stdpath('data') . '/site/pack/packer/start') ]]

vim.cmd [[ Plug 'phaazon/hop.nvim' ]]
vim.cmd [[ Plug 'junegunn/vim-easy-align' ]]
vim.cmd [[ Plug 'jeetsukumaran/vim-indentwise' ]]
vim.cmd [[ Plug 'haya14busa/vim-asterisk' ]]
vim.cmd [[ Plug 'kevinhwang91/nvim-hlslens' ]]
vim.cmd [[ Plug 'kylechui/nvim-surround' ]]

vim.cmd [[ call plug#end() ]]

require("pluginconfig/hop")
require("pluginconfig/nvim-surround")
require("pluginconfig/nvim-hlslens")
