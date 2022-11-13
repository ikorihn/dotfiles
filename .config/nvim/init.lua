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
  "autocommands",
  "colorscheme",
  "utils",
  "lsp",
}
for k, v in pairs(modules) do
  load(v)
end

for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. "/lua/pluginconfig", [[v:val =~ '\.lua$']])) do
  require("pluginconfig/" .. file:gsub("%.lua$", ""))
end
