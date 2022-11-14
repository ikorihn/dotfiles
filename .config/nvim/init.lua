local function load(module)
  package.loaded[module] = nil
  require(module)
end

if vim.g.vscode == 1 then
  load("options")
  load("vscode")
  return
end

local modules = {
  "options",
  "keymaps",
  "plugins",
  "packer_compiled",
  "autocommands",
  "colorscheme",
  "utils",
  "lsp",
}
for k, v in pairs(modules) do
  load(v)
end

