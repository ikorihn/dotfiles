local status_ok, obsidian = pcall(require, "obsidian")
if not status_ok then
  return
end

obsidian.setup({
  workspaces = {
    {
      name = "personal",
      path = "~/obsidian",
    },
  },
  ui = {
    enable = false,
  },
  disable_frontmatter = true,
  daily_notes = {
    folder = "daily",
    -- Optional, if you want to change the date format for the ID of daily notes.
    date_format = "%Y-%m-%d",
    -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
    template = nil,
  },
  completion = {
    nvim_cmp = true,
  },
})
