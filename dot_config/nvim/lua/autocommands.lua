-- Jenkinsfile as groovy
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*Jenkinsfile*",
  callback = function() vim.bo.filetype = "groovy" end,
  once = false,
})

-- Go template
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.tmpl" },
  callback = function()
    if vim.fn.search("{{.\\+}}", "nw") ~= 0 then
      vim.bo.filetype = "gotmpl"
    end
  end,
  once = false,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "go", "Makefile" },
  callback = function()
    vim.opt.expandtab = false
    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.softtabstop = 4
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "crontab" },
  callback = function()
    vim.opt.backup = false
    vim.opt.writebackup = false
  end,
})

-- Disable automatic indentation
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "yaml" },
  callback = function() vim.opt.indentkeys:remove("<:>") end,
})

-- Use 'q' to quit from common plugins
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "qf", "help", "man", "lspinfo", "spectre_panel", "lir" },
  callback = function()
    vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]])
  end,
})

-- Set wrap and spell in markdown and gitcommit
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- https://github.com/nvim-tree/nvim-tree.lua/issues/1005
-- vim <directory> で開いたときにもすぐ終了してしまうため無効化する
-- vim.cmd "autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif"

-- Fixes Autocomment
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  callback = function() vim.cmd("set formatoptions-=cro") end,
})

-- Highlight Yanked Text
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function() vim.highlight.on_yank({ higroup = "Visual", timeout = 200 }) end,
})

-- -- switch relativenumber
-- vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
-- 	callback = function()
-- 		if vim.o.number and vim.fn.mode() ~= "i" then
-- 			vim.o.relativenumber = true
-- 		end
-- 	end,
-- 	once = false,
-- })
-- vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
-- 	callback = function()
-- 		if vim.o.number then
-- 			vim.o.relativenumber = false
-- 		end
-- 	end,
-- 	once = false,
-- })
