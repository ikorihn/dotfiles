-- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
return {
  settings = {
    gopls = {
      staticcheck = true,
    },
  },
}
