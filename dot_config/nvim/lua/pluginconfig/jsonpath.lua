local status_ok, jsonpath = pcall(require, "jsonpath")
if not status_ok then
  return
end

-- show json path in the winbar
if vim.fn.exists("+winbar") == 1 then
  vim.opt_local.winbar = "%{%v:lua.require'jsonpath'.get()%}"
end

-- send json path to clipboard
vim.keymap.set(
  "n",
  "y<C-p>",
  function() vim.fn.setreg("+", jsonpath.get()) end,
  { desc = "copy json path", buffer = true }
)
