-- 外部ツール連携
return {
  -- Obsidianノートの編集支援
  {
    "epwalsh/obsidian.nvim",
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = function()
      -- workspaceのパスはマシン固有なので config/local.lua から読む
      local local_ok, local_config = pcall(require, "config.local")
      local workspaces = local_ok and local_config.obsidian_workspaces or nil
      return {
        workspaces = workspaces or {
          { name = "personal", path = "~/obsidian" },
        },
        ui = {
          enable = false,
        },
        disable_frontmatter = true,
        daily_notes = {
          folder = "daily",
          date_format = "%Y-%m-%d",
          template = nil,
        },
        completion = {
          nvim_cmp = true,
        },
      }
    end,
  },

  -- chezmoi管理ファイルの編集時に自動でapply
  {
    "xvzc/chezmoi.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      edit = {
        watch = true, -- Set true to automatically apply on save.
        force = false,
      },
      notification = {
        on_open = true,
        on_apply = true,
      },
    },
  },
}
