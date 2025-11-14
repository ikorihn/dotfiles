---@type vim.lsp.Config
return {
  root_markers = {
    "biome.json",
  },
  -- root_dirにこれらのファイルがあるときだけ起動する
  workspace_required = true,
}
