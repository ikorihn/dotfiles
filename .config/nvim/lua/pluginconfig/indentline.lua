local status_ok, indent_blankline = pcall(require, "indent_blankline")
if not status_ok then
  return
end

vim.cmd [[highlight IndentBlanklineIndent1 guifg=#567692 guibg=#2f2f2f gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guifg=#567692 guibg=#333333 gui=nocombine]]

indent_blankline.setup {
  space_end_of_line = true,
  space_char_blankline = "",
  show_trailing_blankline_indent = false,
  show_first_indent_level = true,
  use_treesitter = true,
  show_current_context = true,
  buftype_exclude = { "terminal", "nofile" },
  filetype_exclude = {
    "help",
    "packer",
    "NvimTree",
  },
  char = "",
  char_highlight_list = {
    "IndentBlanklineIndent1",
    "IndentBlanklineIndent2",
  },
  space_char_highlight_list = {
    "IndentBlanklineIndent1",
    "IndentBlanklineIndent2",
  },
}

