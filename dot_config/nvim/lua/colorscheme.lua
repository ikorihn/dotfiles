local colorscheme = "gruvbox"

local scheme_status_ok, gruvbox = pcall(require, "gruvbox")
if not scheme_status_ok then
  return
end

gruvbox.setup({
  undercurl = true,
  underline = true,
  bold = true,
  italic = {},
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "", -- can be "hard", "soft" or empty string
  overrides = {},
})

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  return
end
