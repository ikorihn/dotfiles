local status_ok, hop = pcall(require, "hop")
if not status_ok then
  return
end

hop.setup({
  keys = "etovxqpdygfblzhckisuran",
})

-- https://github.com/phaazon/hop.nvim/issues/58
local M = {}

local builtin_targets = require("hop.jump_target")

local last_chars = nil

---@param chars string
local function repeatable_hop(chars)
  assert(chars ~= nil)
  last_chars = chars
  hop.hint_with(
    builtin_targets.jump_targets_by_scanning_lines(builtin_targets.regex_by_case_searching(chars, true, {})),
    hop.opts
  )
  -- fixme: change to a real module
  vim.fn["repeat#set"](":lua require'my.local.hop'.repeats()\r")
end

M.repeats = function()
  if last_chars == nil then
    return
  end
  repeatable_hop(last_chars)
end

M.hint_char1 = function()
  -- a rewrite of hop.hint_char1

  local char
  while true do
    vim.api.nvim_echo({ { "", "" } }, false, {})
    local code = vim.fn.getchar()
    -- fixme: custom char range by needs
    if code >= 61 and code <= 0x7a then
      -- [a-z]
      char = string.char(code)
      break
    elseif code == 0x20 or code == 0x1b then
      -- press space, esc to cancel
      char = nil
      break
    end
  end
  if not char then
    return
  end

  repeatable_hop(char)
end

M.setup = function()
  hop.setup({})

  -- fixme: change to a real module
  vim.api.nvim_set_keymap("n", [[f]], [[<cmd>lua require'my.local.hop'.hint_char1()<cr>]], { noremap = true })
end

return M
