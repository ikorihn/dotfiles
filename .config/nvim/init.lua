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
  package.loaded[v] = nil
  require(v)
end

for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. "/lua/pluginconfig", [[v:val =~ '\.lua$']])) do
  require("pluginconfig/" .. file:gsub("%.lua$", ""))
end
