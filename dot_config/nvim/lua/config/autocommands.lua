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
    if vim.fn.search("{{.\\+}}", "nw") ~= 0 then vim.bo.filetype = "gotmpl" end
  end,
  once = false,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*Tiltfile",
  callback = function() vim.bo.filetype = "tiltfile" end,
  once = false,
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*Dockerfile*",
  callback = function() vim.bo.filetype = "dockerfile" end,
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

-- Fixes Autocomment
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  callback = function() vim.cmd("set formatoptions-=cro") end,
})

-- Highlight Yanked Text
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function() vim.hl.on_yank({ higroup = "Visual", timeout = 200 }) end,
})

-- 巨大ファイルを開く前に確認し、開く場合は重い機能を無効化する
local function do_not_open_large_file()
  local max_size = 10 * 1024 * 1024 -- 10 MB
  local file_size = vim.fn.getfsize(vim.fn.expand("<afile>"))
  if file_size > max_size then
    local answer = vim.fn.input("The file is large. Open anyway? (y/N): ")
    if answer:lower() ~= "y" then
      vim.api.nvim_err_writeln("File is too large to open!")
      vim.cmd("bdelete!") -- Close the buffer
    else
      vim.cmd("setlocal noswapfile noundofile nowrap")
      vim.cmd("syntax off")
      vim.api.nvim_err_writeln("Large file detected: Disabling certain features for performance.")
    end
  end
end

vim.api.nvim_create_autocmd("BufReadPre", {
  pattern = "*",
  callback = do_not_open_large_file,
})
