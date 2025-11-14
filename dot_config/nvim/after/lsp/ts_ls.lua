---@type vim.lsp.Config
return {
  root_markers = {
    "package.json",
  },
  -- root_dirにこれらのファイルがあるときだけ起動する
  workspace_required = true,
  on_attach = function(client, bufnr)
    LspKeymaps(bufnr)
    require("illuminate").on_attach(client)
    require("lsp_signature").on_attach({}, bufnr)

    -- this is important, otherwise tsserver will format ts/js files which we *really* don't want.
    client.server_capabilities.documentFormattingProvider = false
  end,
}
