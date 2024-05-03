local gruvbox_status_ok, gruvbox = pcall(require, "gruvbox")
if gruvbox_status_ok then
  gruvbox.setup({
    contrast = "soft", -- can be "hard", "soft" or empty string
  })
end

local kanagawa_ok, kanagawa = pcall(require, "kanagawa")
if kanagawa_ok then
  kanagawa.setup({
    compile = true,
    background = {
      dark = "dragon",
      light = "lotus",
    },
  })
  vim.cmd([[colorscheme kanagawa]])
end
