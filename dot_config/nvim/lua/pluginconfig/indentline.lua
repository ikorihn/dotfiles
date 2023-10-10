local status_ok, indent_blankline = pcall(require, "ibl")
if not status_ok then
  return
end

vim.cmd [[highlight IndentBlanklineIndent1 guifg=#567692 guibg=#2f2f2f gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guifg=#567692 guibg=#333333 gui=nocombine]]

indent_blankline.setup()
