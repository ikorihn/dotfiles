local function load(module)
  package.loaded[module] = nil
  require(module)
end

load "options"
load "keymaps"

if vim.g.vscode == 1 then
  load "vscode"
  return
end

load "plugins"
load "autocommands"
load "colorscheme"
load "utils"
load "lsp"
