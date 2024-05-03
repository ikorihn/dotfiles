local status_ok, gitsigns = pcall(require, "gitsigns")
if not status_ok then
  return
end

gitsigns.setup {
  signs = {
    add =          { hl = 'GitSignsAdd',    text = ' ▎', numhl = 'GitSignsAddNr',    linehl = 'GitSignsAddLn' },
    change =       { hl = 'GitSignsChange', text = ' ▎', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
    delete =       { hl = 'GitSignsDelete', text = ' ', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
    topdelete =    { hl = 'GitSignsDelete', text = ' ', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
    changedelete = { hl = 'GitSignsChange', text = '▎ ', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
  },
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 200,
  },
  show_deleted = false,
  attach_to_untracked = false,
}

-- Gitsigns
vim.keymap.set('n', ']c', function()
  if vim.wo.diff then return ']c' end
  vim.schedule(function() require('gitsigns').next_hunk() end)
  return '<Ignore>'
end, {expr=true})
vim.keymap.set('n', '[c', function()
  if vim.wo.diff then return '[c' end
  vim.schedule(function() require('gitsigns').prev_hunk() end)
  return '<Ignore>'
end, {expr=true})
vim.keymap.set({'n', 'v'}, '<leader>gs', "<cmd>lua require('gitsigns').stage_hunk()<cr>", opts)
vim.keymap.set({'n', 'v'}, '<leader>gr', "<cmd>lua require('gitsigns').reset_hunk()<cr>", opts)
vim.keymap.set('n', '<leader>gu', "<cmd>lua require('gitsigns').undo_stage_hunk()<cr>", opts)
vim.keymap.set('n', '<leader>gp', "<cmd>lua require('gitsigns').preview_hunk()<cr>", opts)
vim.keymap.set('n', '<leader>gB', "<cmd>lua require('gitsigns').blame_line{full=true}<cr>", opts)
vim.keymap.set('n', '<leader>gd', "<cmd>lua require('gitsigns').diffthis()<cr>", opts)
vim.keymap.set('n', '<leader>gD', "<cmd>lua require('gitsigns').diffthis('~')<cr>", opts)
vim.keymap.set('n', '<leader>td', "<cmd>lua require('gitsigns').toggle_deleted()<cr>", opts)
