local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require("lsp.lsp-installer")
require("lsp.null_ls")
require("lsp.lspsaga")

require("aerial").setup()
