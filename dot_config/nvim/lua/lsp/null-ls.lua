local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

-- https://github.com/prettier-solidity/prettier-plugin-solidity
null_ls.setup {
  debug = false,
  sources = {
    formatting.prettier.with {
      extra_filetypes = { "toml" },
    },
    formatting.black.with { extra_args = { "--fast" } },
    formatting.stylua.with { extra_args = { "--indent-type", "Spaces", "--indent-width", "2", "--column-width", "120", "--collapse-simple-statement", "Always" } },
    formatting.google_java_format,
    formatting.goimports,
    formatting.rustfmt,
    diagnostics.flake8,
    null_ls.builtins.code_actions.gitsigns,
    formatting.shfmt.with { extra_args = { "-i", "2", "-sr", "-ci", "-bn" } },
    null_ls.builtins.code_actions.shellcheck,
    formatting.biome,
  },
}
