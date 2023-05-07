-- ~/.local/share/nvim/site/pack/*/start/* を読み込ませない
vim.opt.packpath:remove(vim.fn.stdpath('data').."/site")

-- Plug
-- Automatically install plug
local plugpath = vim.fn.stdpath("data") .. "/plugged/vim-plug"
if not vim.loop.fs_stat(plugpath) then
  vim.fn.system({
    "curl",
    "-fLo",
    plugpath .. "/autoload/plug.vim",
    "--create-dirs",
    "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim",
  })
end
vim.opt.rtp:prepend(plugpath)

vim.cmd [[ call plug#begin(stdpath('data') .. '/site/pack/packer/start') ]]

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
