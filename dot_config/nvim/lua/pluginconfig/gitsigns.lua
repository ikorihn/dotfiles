local status_ok, gitsigns = pcall(require, "gitsigns")
if not status_ok then
  return
end

gitsigns.setup({
  signs = {
    add = { text = "┃" },
    change = { text = "┃" },
    delete = { text = "" },
    topdelete = { text = "" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  signs_staged = {
    add = { text = "┃" },
    change = { text = "┃" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  signs_staged_enable = true,
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`

  current_line_blame = true,
  current_line_blame_opts = {
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 200,
  },
  current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
  show_deleted = false,
  attach_to_untracked = false,

  on_attach = function(bufnr)
    -- keymaps
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end)

    map("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end)

    -- Actions
    map("n", "<leader>gs", gitsigns.stage_hunk)
    map("n", "<leader>gr", gitsigns.reset_hunk)
    map("v", "<leader>gs", function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
    map("v", "<leader>gr", function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
    map("n", "<leader>gS", gitsigns.stage_buffer)
    map("n", "<leader>gu", gitsigns.undo_stage_hunk)
    map("n", "<leader>gR", gitsigns.reset_buffer)
    map("n", "<leader>gp", gitsigns.preview_hunk)
    map("n", "<leader>gB", function() gitsigns.blame_line({ full = true }) end)
    map("n", "<leader>gd", gitsigns.diffthis)
    map("n", "<leader>gD", function() gitsigns.diffthis("~") end)
    map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
    map("n", "<leader>td", gitsigns.toggle_deleted)

    -- Text object
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
  end,
})
