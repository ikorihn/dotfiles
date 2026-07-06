-- 見た目・UI系プラグイン
return {
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "MunifTanjim/nui.nvim", lazy = true },

  -- ファイラー
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("pluginconfig.nvim-tree") end,
  },

  -- バッファをタブ風に表示
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          numbers = "both",
          max_name_length = 30,
          max_prefix_length = 20, -- prefix used when a buffer is de-duplicated
          truncate_names = true,
          diagnostics = "nvim_lsp",
          custom_filter = function(buf_number)
            if vim.bo[buf_number].filetype == "qf" then return false end
            if vim.bo[buf_number].buftype == "terminal" then return false end
            return true
          end,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "left",
              separator = true,
            },
          },
          sort_by = "insert_after_current",
        },
      })
    end,
  },
  -- ステータスライン
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("pluginconfig.lualine") end,
  },

  -- インデントガイド
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      exclude = {
        buftypes = { "terminal", "nofile" },
        filetypes = { "help", "NvimTree" },
      },
    },
  },

  -- カーソル下の単語と同じ単語をハイライト
  {
    "RRethy/vim-illuminate",
    config = function()
      vim.g.Illuminate_ftblacklist = { "alpha", "NvimTree" }
      vim.keymap.set("n", "<a-n>", function() require("illuminate").next_reference({ wrap = true }) end)
      vim.keymap.set("n", "<a-p>", function() require("illuminate").next_reference({ reverse = true, wrap = true }) end)
    end,
  },

  -- 行末の不要な空白をハイライト
  { "ntpeters/vim-better-whitespace" },

  -- キーマップのヘルプ表示
  { "folke/which-key.nvim", opts = {} },

  -- コマンドライン・メッセージのUI置き換え
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          signature = {
            enabled = false,
          },
        },
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false,
          lsp_doc_border = false,
          filter = {
            event = "msg_show",
            min_height = 10,
            max_width = 10,
          },
        },
      })
      vim.keymap.set("n", "<leader>nd", "<cmd>Noice dismiss<CR>")
    end,
  },
}
