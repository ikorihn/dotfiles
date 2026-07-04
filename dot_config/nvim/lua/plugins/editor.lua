-- 編集操作・移動系プラグイン
return {
  { "nvim-lua/plenary.nvim", lazy = true },

  -- 括弧やクォートで囲む操作
  { "kylechui/nvim-surround", opts = {} },

  -- * 検索の強化 + 検索マッチ数の表示 (キーマップは config/keymaps.lua)
  { "haya14busa/vim-asterisk" },
  {
    "kevinhwang91/nvim-hlslens",
    config = function() require("hlslens").setup() end,
  },

  -- テキストの整列 (gaで起動)
  {
    "echasnovski/mini.align",
    version = "*",
    config = function() require("mini.align").setup() end,
  },

  -- camelCase/snake_caseなどの変換
  {
    "johmsalas/text-case.nvim",
    config = function()
      require("textcase").setup({})
      local tele_status_ok, telescope = pcall(require, "telescope")
      if tele_status_ok then telescope.load_extension("textcase") end
    end,
  },

  -- json/yamlのカーソル位置のパスをwinbarに表示
  {
    "phelipetls/jsonpath.nvim",
    ft = { "json", "yaml" },
    config = function()
      if vim.fn.exists("+winbar") == 1 then
        vim.opt_local.winbar = "%{%v:lua.require'jsonpath'.get()%}"
      end
      vim.keymap.set(
        "n",
        "y<C-p>",
        function() vim.fn.setreg("+", require("jsonpath").get()) end,
        { desc = "copy json path", buffer = true }
      )
    end,
  },
}
