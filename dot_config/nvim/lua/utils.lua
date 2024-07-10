local M = {}

M.ToggleQuickFix = function()
  if vim.fn.empty(vim.fn.filter(vim.fn.getwininfo(), "v:val.quickfix")) == 1 then
    vim.cmd([[copen]])
  else
    vim.cmd([[cclose]])
  end
end
vim.cmd([[command! -nargs=0 -bar ToggleQuickFix lua require('utils').ToggleQuickFix()]])

-- https://neovim.discourse.group/t/reload-init-lua-and-all-require-d-scripts/971/11
M.ReloadConfig = function()
  dofile(vim.env.MYVIMRC)
  vim.notify("Nvim configuration reloaded!", vim.log.levels.INFO)
end
vim.cmd([[command! -nargs=0 -bar ReloadConfig lua require('utils').ReloadConfig()]])

M.Jq = function(...)
  local arg = ""
  for _, v in pairs({ ... }) do
    arg = arg .. v .. " "
  end

  if arg == "" then
    arg = "."
  end
  vim.notify("jq " .. arg, vim.log.levels.INFO)

  vim.cmd("%! jq " .. arg)
end
vim.cmd([[command! -nargs=? -bar Jq lua require('utils').Jq(<f-args>)]])

M.OpenUrlOrFile = function()
  local cfile = vim.fn.expand("<cfile>")
  if cfile:match("^https?://") then
    vim.fn.system({ "open", cfile })
  else
    vim.cmd("normal! gF")
  end
end
vim.cmd([[command! -nargs=0 -bar OpenUrlOrFile lua require('utils').OpenUrlOrFile()]])

return M
