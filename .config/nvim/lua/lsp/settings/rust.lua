function rustfmt(wait_ms)
  local curpos = vim.api.nvim_win_get_cursor(0)
  vim.cmd [[ %!rustfmt --edition "2021" ]]
  vim.api.nvim_win_set_cursor(0, curpos)
end

vim.cmd [[
  augroup rustfmt
    autocmd!
    autocmd BufWritePre *.rs lua rustfmt()
  augroup end
]]

return {
  settings = {
    rust = {
    },
  },
}
