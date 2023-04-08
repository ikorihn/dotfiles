local mason_status_ok, mason = pcall(require, "mason")
if not mason_status_ok then
  return
end
local mason_lspconfig_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status_ok then
  return
end

local servers = {
  "lua_ls",
  "cssls",
  "html",
  "tsserver",
  "pyright",
  "bashls",
  "jsonls",
  "yamlls",
  "gopls",
  "rust_analyzer",
}

mason.setup {
  ui = {
    icons = {
      package_installed = "✓"
    }
  }
}
mason_lspconfig.setup {
  ensure_installed = servers,
}

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
  return
end

local opts = {}

for _, server in pairs(servers) do
  opts = {
    on_attach = require("lsp.handlers").on_attach,
    capabilities = require("lsp.handlers").capabilities,
  }

  if server == "lua_ls" then
    local lua_opts = require "lsp.settings.lua"
    opts = vim.tbl_deep_extend("force", lua_opts, opts)
  end

  if server == "pyright" then
    local pyright_opts = require "lsp.settings.pyright"
    opts = vim.tbl_deep_extend("force", pyright_opts, opts)
  end

  if server == "gopls" then
    local gopls_opts = require "lsp.settings.gopls"
    opts = vim.tbl_deep_extend("force", gopls_opts, opts)
  end

  if server == "rust_analyzer" then
    local rust_opts = require "lsp.settings.rust"
    opts = vim.tbl_deep_extend("force", rust_opts, opts)
  end

  if server == "yamlls" then
    local yaml_opts = require "lsp.settings.yamlls"
    opts = vim.tbl_deep_extend("force", yaml_opts, opts)
  end

  lspconfig[server].setup(opts)
end
