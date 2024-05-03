local status_ok, telescope = pcall(require, "telescope")
if not status_ok then return end

local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

-- zoxide
local z_ok, z_utils = pcall(require, "telescope._extensions.zoxide.utils")
if not z_ok then return end

telescope.setup({
  defaults = {
    initial_mode = "normal",
    path_display = { "smart" },
    file_ignore_patterns = { "%.git/", "node_modules", "package-lock.json" },
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
keymap("n", "<leader>fg", builtin.live_grep, opts)
keymap("n", "<leader>fG", builtin.git_files, opts)
keymap("n", "<leader>fh", builtin.command_history, opts)
keymap("n", "<leader>fp", ":Telescope projects<CR>", opts)
keymap("n", "<leader>fb", builtin.buffers, opts)
keymap("n", "ga.", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Telescope" })
keymap("v", "ga.", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Telescope" })

telescope.load_extension("chezmoi")
vim.keymap.set("n", "<leader>f.", telescope.extensions.chezmoi.find_files, {})

telescope.load_extension("zoxide")
