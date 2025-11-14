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

vim.lsp.config("*", {
  on_attach = function(client, bufnr)
    LspKeymaps(bufnr)
    require("illuminate").on_attach(client)
    require("lsp_signature").on_attach({}, bufnr)
  end,
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

local function setup()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    virtual_text = false, -- disable virtual text
    signs = {
      active = signs, -- show signs
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
