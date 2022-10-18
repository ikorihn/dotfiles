-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
function go_org_imports(wait_ms)
  local curpos = vim.api.nvim_win_get_cursor(0)
  vim.cmd [[ %!goimports ]]
  vim.api.nvim_win_set_cursor(0, curpos)
end

vim.cmd [[
  augroup goimports
    autocmd!
    autocmd BufWritePre *.go lua go_org_imports()
  augroup end
]]

return {
  settings = {
    gopls = {
      staticcheck = true,
    },
  },
}
