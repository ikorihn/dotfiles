local status_ok, lspsaga = pcall(require, "lspsaga")
if not status_ok then return end

lspsaga.setup({
  lightbulb = {
    enable = false,
  },
  finder = {
    max_height = 0.6,
    default = "tyd+ref+imp+def",
    keys = {
      toggle_or_open = "<CR>",
      vsplit = "v",
      split = "s",
      tabnew = "t",
      tab = "T",
      quit = "q",
      close = "<Esc>",
    },
    methods = {
      tyd = "textDocument/typeDefinition",
    },
  },
})
