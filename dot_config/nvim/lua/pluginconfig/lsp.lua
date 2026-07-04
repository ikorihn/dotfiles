-- LSPサーバーのセットアップと、LSPアタッチ時のキーマップ定義
-- サーバー個別の設定は after/lsp/*.lua に置く
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

local servers = {
  "lua_ls",
  "cssls",
  "html",
  "ruff",
  "jsonls",
  "yamlls",
  "gopls",
  "rust_analyzer",
  "ts_ls",
  "denols",
  "biome",
  "jsonnet_ls",
  "typos_lsp",
  "terraformls",
  "bashls",
  "buf_ls",
}

-- Shorten function name
local keymap = vim.keymap.set
local opts = {}

local function lsp_keymaps(bufnr)
  local builtin = require("telescope.builtin")
  local lsp_opts = { noremap = true, silent = true }
  local buf_set_keymap = vim.api.nvim_buf_set_keymap

  buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", lsp_opts)
  keymap("n", "gd", function() builtin.lsp_definitions() end, opts)
  buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", lsp_opts)
  keymap("n", "gI", function()
    builtin.lsp_implementations({
      file_ignore_patterns = {
        "_test%.go", -- _test.go を無視
        "/mock/", -- パスに mock が含まれるものを無視
        "mock_.*%.go", -- mock_で始まるファイルを無視
      },
    })()
  end, opts)
  keymap("n", "gr", function()
    builtin.lsp_references({
      file_ignore_patterns = {
        "_test.go", -- _test.go を無視
        "/mock/", -- パスに mock が含まれるものを無視
        "mock_.*%.go", -- mock_で始まるファイルを無視
      },
    })
  end, opts)
  keymap("n", "gi", function() builtin.lsp_incoming_calls() end, opts)
  keymap("n", "go", function() builtin.lsp_outgoing_calls() end, opts)
  keymap("n", "gl", function() builtin.diagnostics() end, opts)
  buf_set_keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", lsp_opts)
  buf_set_keymap(bufnr, "n", "<Space><Space>", ":lua vim.lsp.buf.", { noremap = true })
  buf_set_keymap(bufnr, "n", "<Space>l", ":lua require('telescope.builtin').", { noremap = true })
  buf_set_keymap(bufnr, "n", "<Space>f", "<cmd>lua vim.lsp.buf.format()<cr>", lsp_opts)
  buf_set_keymap(bufnr, "n", "<Space>a", "<cmd>lua vim.lsp.buf.code_action()<cr>", lsp_opts)
  buf_set_keymap(bufnr, "n", "<Space>j", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", lsp_opts)
  buf_set_keymap(bufnr, "n", "<Space>k", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", lsp_opts)
  buf_set_keymap(bufnr, "n", "<Space>r", "<cmd>lua vim.lsp.buf.rename()<cr>", lsp_opts)
  buf_set_keymap(bufnr, "n", "<Space>s", "<cmd>lua vim.lsp.buf.signature_help()<CR>", lsp_opts)
  buf_set_keymap(bufnr, "n", "<Space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", lsp_opts)

  buf_set_keymap(bufnr, "n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", lsp_opts)
  buf_set_keymap(bufnr, "n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", lsp_opts)
  buf_set_keymap(bufnr, "n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", lsp_opts)
  buf_set_keymap(bufnr, "n", "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", lsp_opts)
  buf_set_keymap(bufnr, "n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", lsp_opts)
  buf_set_keymap(bufnr, "n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", lsp_opts)

  buf_set_keymap(bufnr, "n", "<leader>{", "<cmd>AerialPrev<CR>", lsp_opts)
  buf_set_keymap(bufnr, "n", "<leader>}", "<cmd>AerialNext<CR>", lsp_opts)
  keymap("n", "<leader>a", "<cmd>AerialToggle!<CR>", opts)
end

mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
    },
  },
})
mason_lspconfig.setup({
  ensure_installed = servers,
})

vim.lsp.enable(servers)
vim.lsp.enable("stylua", false)

for _, server in ipairs(servers) do
  vim.lsp.config(server, {
    on_attach = function(client, bufnr)
      if server == "terraformls" then
        client.server_capabilities.semanticTokensProvider = nil
      end

      lsp_keymaps(bufnr)
      require("illuminate").on_attach(client)
      require("lsp_signature").on_attach({}, bufnr)
    end,
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
  })
end

local function setup()
  local config = {
    virtual_text = false, -- disable virtual text
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.INFO] = "",
        [vim.diagnostic.severity.HINT] = "",
      },
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.buf.hover({ border = "rounded", max_height = 25 })
end

setup()
