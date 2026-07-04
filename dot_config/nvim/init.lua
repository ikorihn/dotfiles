vim.loader.enable()

-- :ReloadConfig で再読み込みできるよう、requireキャッシュを消してから読み込む
local function load(module)
  package.loaded[module] = nil
  require(module)
end

load("config.options")
load("config.keymaps")

if vim.g.vscode == 1 then
  load("config.vscode")
  return
end

if vim.g.disable_plugin ~= 1 then
  load("config.lazy")
end
load("config.autocommands")
load("utils")
