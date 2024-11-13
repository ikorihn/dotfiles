vim.loader.enable()

local function load(module)
  package.loaded[module] = nil
  require(module)
end

load("options")
load("keymaps")

if vim.g.vscode == 1 then
  load("vscode-config")
  return
end

if vim.g.disable_plugin ~= 1 then
  load("plugins")
end
load("autocommands")
load("colorscheme")
load("utils")
load("lsp")
