-- 言語別・テスト実行
return {
  -- Go開発の統合ツール (保存時にgoimportsを実行)
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
    },
    config = function(lp, opts)
      require("go").setup(opts)
      local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function() require("go.format").goimports() end,
        group = format_sync_grp,
      })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
  },

  -- Goのテーブル駆動テストの雛形生成
  {
    "yanskun/gotests.nvim",
    ft = "go",
    config = function() require("gotests").setup() end,
  },

  -- テスト実行 (:TestFile, :TestNearestなど)
  {
    "klen/nvim-test",
    config = function()
      require("nvim-test").setup({
        run = true,
        commands_create = true, -- create commands (TestFile, TestLast, ...)
        filename_modifier = ":.",
        silent = false,
        term = "terminal",
        termOpts = {
          direction = "vertical",
          width = 96,
          height = 24,
          go_back = false,
          stopinsert = "auto",
          keep_one = true,
        },
        runners = {
          cs = "nvim-test.runners.dotnet",
          go = "nvim-test.runners.go-test",
          haskell = "nvim-test.runners.hspec",
          javacriptreact = "nvim-test.runners.jest",
          javascript = "nvim-test.runners.jest",
          lua = "nvim-test.runners.busted",
          python = "nvim-test.runners.pytest",
          ruby = "nvim-test.runners.rspec",
          rust = "nvim-test.runners.cargo-test",
          typescript = "nvim-test.runners.jest",
          typescriptreact = "nvim-test.runners.jest",
        },
      })
    end,
  },
}
