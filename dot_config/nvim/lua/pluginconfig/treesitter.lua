local status_ok, treesitter = pcall(require, "nvim-treesitter")
if not status_ok then return end

treesitter.setup({
  -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
  install_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site"),
})

local languages = {
  "bash",
  "css",
  "dockerfile",
  "go",
  "gotmpl",
  "html",
  "java",
  "javascript",
  "json",
  "jsonnet",
  "lua",
  "markdown_inline",
  "python",
  "regex",
  "rust",
  "starlark",
  "sql",
  "toml",
  "typescript",
  "vimdoc",
  "yaml",
}

treesitter.install(languages)

-- 言語のエイリアス登録
vim.treesitter.language.register("bash", { "sh", "zsh" })

local ts_group = vim.api.nvim_create_augroup("MyTreeSitterSetup", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = ts_group,
  pattern = languages,
  callback = function()
    -- syntax highlighting, provided by Neovim
    vim.treesitter.start()
    -- folds, provided by Neovim
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    -- indentation, provided by nvim-treesitter
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- configuration
require("nvim-treesitter-textobjects").setup({
  select = {
    -- Automatically jump forward to textobj, similar to targets.vim
    lookahead = true,
    -- You can choose the select mode (default is charwise 'v')
    --
    -- Can also be a function which gets passed a table with the keys
    -- * query_string: eg '@function.inner'
    -- * method: eg 'v' or 'o'
    -- and should return the mode ('v', 'V', or '<c-v>') or a table
    -- mapping query_strings to modes.
    selection_modes = {
      ["@parameter.outer"] = "v", -- charwise
      ["@function.outer"] = "V", -- linewise
      -- ['@class.outer'] = '<c-v>', -- blockwise
    },
    -- If you set this to `true` (default is `false`) then any textobject is
    -- extended to include preceding or succeeding whitespace. Succeeding
    -- whitespace has priority in order to act similarly to eg the built-in
    -- `ap`.
    --
    -- Can also be a function which gets passed a table with the keys
    -- * query_string: eg '@function.inner'
    -- * selection_mode: eg 'v'
    -- and should return true of false
    include_surrounding_whitespace = false,
  },
})

-- keymaps
-- You can use the capture groups defined in `textobjects.scm`
vim.keymap.set(
  { "x", "o" },
  "am",
  function() require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects") end
)
vim.keymap.set(
  { "x", "o" },
  "im",
  function() require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects") end
)
vim.keymap.set(
  { "x", "o" },
  "ac",
  function() require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects") end
)
vim.keymap.set(
  { "x", "o" },
  "ic",
  function() require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects") end
)
-- You can also use captures from other query groups like `locals.scm`
vim.keymap.set(
  { "x", "o" },
  "as",
  function() require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals") end
)
