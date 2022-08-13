local modules = {
  "options",
  "keymaps",
  "plugins",
  "autocommands",
  "colorscheme",
  "lsp",
}
for k, v in pairs(modules) do
  package.loaded[v] = nil
  require(v)
end
