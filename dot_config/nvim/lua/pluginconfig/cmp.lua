local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
  return
end

require("luasnip/loaders/from_vscode").lazy_load()
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local lspok, lspkind = pcall(require, "lspkind")
if not lspok then
  return
end

local gitok, git = pcall(require, "cmp_git")
if not gitok then
  return
end

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },

  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
        -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
        -- that way you will only jump inside the snippet region
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),

  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    -- { name = 'vsnip' }, -- For vsnip users.
    { name = "luasnip" }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = "path" },
  }, {
    { name = "obsidian" },
  }, {
    {
      name = "buffer",
      option = {
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end,
      },
    },
    {
      name = "tmux",
      option = {
        all_panes = true,
        label = "[tmux]",
        trigger_characters = { "." },
        -- Capture full pane history
        -- `false`: show completion suggestion from text in the visible pane (default)
        -- `true`: show completion suggestion from text starting from the beginning of the pane history.
        --         This works by passing `-S -` flag to `tmux capture-pane` command. See `man tmux` for details.
        capture_history = false,
      },
    },
    {
      name = "rg",
      -- Try it when you feel cmp performance is poor
      -- keyword_length = 3
    },
  }, {
    { name = "nvim_lua" },
  }, {
    { name = "emoji" },
  }),

  formatting = {
    expandable_indicator = true,
    fields = { "abbr", "kind", "menu" },
    format = lspkind.cmp_format({
      mode = "symbol_text",
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
      menu = {
        buffer = "[Buffer]",
        path = "[Path]",
        git = "[Git]",
        tmux = "[Tmux]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        rg = "[Ripgrep]",
        ["vim-dadbod-completion"] = "[DB]",
        obsidian = "[Obsidian]",
      },
    }),
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  experimental = {
    ghost_text = true,
  },
})

-- cmp-git
git.setup({
  trigger_actions = {
    {
      debug_name = "git_commits",
      trigger_character = ":",
      action = function(sources, trigger_char, callback, params, git_info)
        return sources.git:get_commits(callback, params, trigger_char)
      end,
    },
  },
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
  }, {
    { name = "path" },
  }, {
    {
      name = "buffer",
      option = {
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end,
      },
    },
    {
      name = "tmux",
      option = {
        all_panes = true,
        label = "[tmux]",
        trigger_characters = { "." },
        -- Capture full pane history
        -- `false`: show completion suggestion from text in the visible pane (default)
        -- `true`: show completion suggestion from text starting from the beginning of the pane history.
        --         This works by passing `-S -` flag to `tmux capture-pane` command. See `man tmux` for details.
        capture_history = false,
      },
    },
    {
      name = "rg",
      -- Try it when you feel cmp performance is poor
      -- keyword_length = 3
    },
  }, {
    { name = "emoji" },
  }),
})

cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
  sources = cmp.config.sources({
    { name = "vim-dadbod-completion" },
    {
      name = "buffer",
      option = {
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end,
      },
    },
    {
      name = "tmux",
      option = {
        all_panes = true,
        label = "[tmux]",
        trigger_characters = { "." },
        -- Capture full pane history
        -- `false`: show completion suggestion from text in the visible pane (default)
        -- `true`: show completion suggestion from text starting from the beginning of the pane history.
        --         This works by passing `-S -` flag to `tmux capture-pane` command. See `man tmux` for details.
        capture_history = false,
      },
    },
    {
      name = "rg",
      -- Try it when you feel cmp performance is poor
      -- keyword_length = 3
    },
  }),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})
