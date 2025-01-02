local status_ok, telescope = pcall(require, "telescope")
if not status_ok then return end

local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

-- zoxide
local z_ok, z_utils = pcall(require, "telescope._extensions.zoxide.utils")
if not z_ok then return end

local project_actions_ok, project_actions = pcall(require, "telescope._extensions.project.actions")
if not project_actions_ok then return end

local action_state = require("telescope.actions.state")

telescope.setup({
  defaults = {
    initial_mode = "normal",
    path_display = { "smart" },
    file_ignore_patterns = { "%.git/", "node_modules", "package-lock.json", ".cache", ".data" },
    mappings = {
      i = {
        ["<Down>"] = actions.cycle_history_next,
        ["<Up>"] = actions.cycle_history_prev,
        ["<ESC>"] = false,
        ["<C-u>"] = false,
        ["<C-j>"] = actions.smart_send_to_qflist + actions.open_qflist,
        ["<C-i>"] = "which_key",
        ["<C-d>"] = require("telescope.actions").delete_buffer,
      },
      n = {
        ["<C-d>"] = require("telescope.actions").delete_buffer,
        ["<C-j>"] = actions.smart_send_to_qflist + actions.open_qflist,
      },
    },
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
      mappings = {
        default = {
          after_action = function(selection) print("Update to (" .. selection.z_score .. ") " .. selection.path) end,
        },
        ["<C-s>"] = {
          before_action = function(selection) print("before C-s") end,
          action = function(selection) vim.cmd.edit(selection.path) end,
        },
        -- Opens the selected entry in a new split
        ["<C-q>"] = { action = z_utils.create_basic_command("split") },
      },
    },

    project = {
      base_dirs = {
        { path = "~/repos/github.com/ikorihn/" },
      },
      hidden_files = true, -- default: false
      theme = "dropdown",
      order_by = "asc",
      search_by = "title",
      sync_with_nvim_tree = true, -- default false
      -- default for on_project_selected = find project files
      on_project_selected = function(prompt_bufnr)
        -- Do anything you want in here. For example:
        project_actions.change_working_directory(prompt_bufnr, false)
        local selected_entry = action_state.get_selected_entry(prompt_bufnr)
        require("monorepo").change_monorepo(selected_entry.value)
      end,
      mappings = {
        n = {
          ["d"] = project_actions.delete_project,
          ["r"] = project_actions.rename_project,
          ["c"] = project_actions.add_project,
          ["C"] = project_actions.add_project_cwd,
          ["f"] = project_actions.find_project_files,
          ["b"] = project_actions.browse_project_files,
          ["s"] = project_actions.search_in_project_files,
          ["R"] = project_actions.recent_project_files,
          ["w"] = project_actions.change_working_directory,
          ["o"] = project_actions.next_cd_scope,
        },
        i = {
          ["<c-d>"] = project_actions.delete_project,
          ["<c-v>"] = project_actions.rename_project,
          ["<c-a>"] = project_actions.add_project,
          ["<c-A>"] = project_actions.add_project_cwd,
          ["<c-f>"] = project_actions.find_project_files,
          ["<c-b>"] = project_actions.browse_project_files,
          ["<c-s>"] = project_actions.search_in_project_files,
          ["<c-r>"] = project_actions.recent_project_files,
          ["<c-l>"] = project_actions.change_working_directory,
          ["<c-o>"] = project_actions.next_cd_scope,
          ["<c-w>"] = project_actions.change_workspace,
        },
      },
    },
  },
})

-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = {}

-- Telescope
function multi_select()
  local opts_ff = {
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function(prompt_bufnr)
        local actions = require("telescope.actions")
        local state = require("telescope.actions.state")
        local picker = state.get_current_picker(prompt_bufnr)
        local multi = picker:get_multi_selection()
        local single = picker:get_selection()
        local str = ""
        if #multi > 0 then
          for i, j in pairs(multi) do
            str = str .. "edit " .. j[1] .. " | "
          end
        end
        str = str .. "edit " .. single[1]
        -- To avoid populating qf or doing ":edit! file", close the prompt first
        actions.close(prompt_bufnr)
        vim.api.nvim_command(str)
      end)
      return true
    end,
    hidden = true,
    follow = true,
  }
  return opts_ff
end

keymap("n", "<leader>f,", ":Telescope ")
keymap("n", "<leader>ff", function() builtin.find_files(multi_select()) end, opts)
keymap(
  "n",
  "<leader>ft",
  function() builtin.grep_string({ path_display = { "smart" }, word_match = "-w", only_sort_text = true, search = "" }) end,
  opts
)
keymap("n", "<leader>fG", builtin.git_files, opts)
keymap("n", "<leader>fh", builtin.command_history, opts)
keymap("n", "<leader>fp", ":Telescope project<CR>", opts)
keymap("n", "<leader>fb", builtin.buffers, opts)
keymap("n", "ga.", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Telescope" })
keymap("v", "ga.", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Telescope" })

telescope.load_extension("chezmoi")
vim.keymap.set("n", "<leader>f.", telescope.extensions.chezmoi.find_files, {})

telescope.load_extension("zoxide")
vim.keymap.set("n", "<leader>cd", require("telescope").extensions.zoxide.list)

telescope.load_extension("frecency")
keymap("n", "<leader>fr", ":Telescope frecency<CR>", opts)
keymap("n", "<leader>fR", ":Telescope frecency workspace=CWD path_display={'shorten'}<CR>", opts)

telescope.load_extension("monorepo")
vim.keymap.set("n", "<leader>mm", function() require("telescope").extensions.monorepo.monorepo() end)
vim.keymap.set("n", "<leader>mn", function() require("monorepo").toggle_project() end)

telescope.load_extension("live_grep_args")
keymap("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")

telescope.load_extension("project")

telescope.load_extension("file_browser")
vim.keymap.set("n", "<leader>fB", ":Telescope file_browser path=%:p:h select_buffer=true")
