local status_ok, telescope = pcall(require, "telescope")
if not status_ok then return end

local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

-- zoxide
local z_ok, z_utils = pcall(require, "telescope._extensions.zoxide.utils")
if not z_ok then return end

local lga_actions = require("telescope-live-grep-args.actions")
local mappings = require("config.keymaps").telescope_config(actions, z_utils, lga_actions)

telescope.setup({
  defaults = {
    initial_mode = "normal",
    path_display = { "smart" },
    file_ignore_patterns = { "%.git/", "node_modules", "package-lock.json", "%.cache", "%.data" },
    mappings = mappings.defaults,
  },
  pickers = {
    find_files = {
      path_display = { "absolute" },
      wrap_results = true,
    },
    lsp_definitions = { fname_width = 100 },
    lsp_references = { fname_width = 100 },
  },
  extensions = {
    zoxide = {
      prompt_title = "[ Walking on the shoulders of TJ ]",
      mappings = mappings.zoxide,
    },

    live_grep_args = {
      auto_quoting = true,
      mappings = mappings.live_grep_args,
      -- ... also accepts theme settings, for example:
      -- theme = "dropdown", -- use dropdown theme
      -- theme = { }, -- use own theme spec
      -- layout_config = { mirror=true }, -- mirror preview pane
    },

    ["ui-select"] = {
      require("telescope.themes").get_dropdown({
        -- even more opts
      }),

      -- pseudo code / specification for writing custom displays, like the one
      -- for "codeactions"
      -- specific_opts = {
      --   [kind] = {
      --     make_indexed = function(items) -> indexed_items, width,
      --     make_displayer = function(widths) -> displayer
      --     make_display = function(displayer) -> function(e)
      --     make_ordinal = function(e) -> string
      --   },
      --   -- for example to disable the custom builtin "codeactions" display
      --      do the following
      --   codeactions = false,
      -- }
    },
  },
})

telescope.load_extension("chezmoi")
telescope.load_extension("zoxide")
telescope.load_extension("monorepo")
telescope.load_extension("live_grep_args")
telescope.load_extension("ui-select")

require("config.keymaps").setup_telescope(telescope, builtin, actions)
