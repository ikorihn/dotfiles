-- マシン固有の除外語がある場合は .typos-local.toml を優先する (gitignore対象)
local config_path = "~/.config/nvim/spell/.typos.toml"
local local_path = "~/.config/nvim/spell/.typos-local.toml"
if vim.fn.filereadable(vim.fn.expand(local_path)) == 1 then
  config_path = local_path
end

---@type vim.lsp.Config
return {
  init_options = {
    config = config_path,
  },
}
