local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local mason_null_ls = require("mason-null-ls")
local lspconfig = require("lspconfig")

local servers = {
  "lua_ls",
  "cssls",
  "html",
  "volar",
  "pyright",
  "jsonls",
  "yamlls",
  "gopls",
  "rust_analyzer",
  "tsserver",
  "denols",
  "biome",
  "jsonnet_ls",
  "jdtls",
  "groovyls",
  "typos_lsp",
}

mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
    },
  },
  registries = {
    "github:nvim-java/mason-registry",
    "github:mason-org/mason-registry",
  },
})
mason_lspconfig.setup({
  ensure_installed = servers,
})
mason_null_ls.setup({})

local setupFuncTbl = {
  ["lua_ls"] = function(opts)
    opts.settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.stdpath("config") .. "/lua"] = true,
          },
        },
        telemetry = {
          enable = false,
        },
      },
    }
    return opts
  end,

  ["pyright"] = function(opts)
    opts.settings = {
      python = {
        analysis = {
          typeCheckingMode = "off",
        },
      },
    }
    return opts
  end,

  ["gopls"] = function(opts)
    opts.settings = {
      gopls = {
        staticcheck = true,
      },
    }
    return opts
  end,

  ["rust_analyzer"] = function(opts)
    local rt_opts = {
      tools = {
        runnables = {
          use_telescope = true,
        },
        inlay_hints = {
          auto = true,
          show_parameter_hints = false,
          parameter_hints_prefix = "",
          other_hints_prefix = "",
        },
      },
      settings = {
        rust = {
          checkOnSave = {
            command = "clippy",
          },
        },
      },
    }
    require("rust-tools").setup(rt_opts)

    return opts
  end,

  ["yamlls"] = function(opts)
    opts.settings = {
      yaml = {
        schemas = {
          ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.yaml"] = "/openapi.yaml",
        },
      },
    }
    return opts
  end,

  ["tsserver"] = function(opts)
    opts.root_dir = lspconfig.util.root_pattern("package.json")
    return opts
  end,

  ["denols"] = function(opts)
    opts.root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deps.ts", "import_map.json")
    opts.init_options = {
      lint = true,
      unstable = true,
      suggest = {
        imports = {
          hosts = {
            ["https://deno.land"] = true,
            ["https://cdn.nest.land"] = true,
            ["https://crux.land"] = true,
          },
        },
      },
    }
    return opts
  end,

  ["typos_lsp"] = function(opts)
    opts.init_options = {
      config = "~/.config/nvim/spell/.typos.toml",
    }

    return opts
  end,
}

mason_lspconfig.setup_handlers({
  function(server_name)
    local opts = {
      on_attach = function(client, bufnr)
        LspKeymaps(bufnr)
        require("illuminate").on_attach(client)
        require("lsp_signature").on_attach({}, bufnr)

        if server_name == "tsserver" then
          -- this is important, otherwise tsserver will format ts/js files which we *really* don't want.
          client.server_capabilities.documentFormattingProvider = false
        end
      end,
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
    }

    -- switch between denols and tsserver
    local node_root_dir = lspconfig.util.root_pattern("package.json")
    local is_node_repo = node_root_dir(vim.api.nvim_buf_get_name(0)) ~= nil
    if server_name == "tsserver" and not is_node_repo then
      return
    end
    if server_name == "denols" and is_node_repo then
      return
    end

    local f = setupFuncTbl[server_name]
    if f ~= nil then
      f(opts)
    end

    lspconfig[server_name].setup(opts)
  end,
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

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })
end

setup()

-- none-ls
local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

local sources = {
  formatting.prettierd.with({
    extra_filetypes = { "toml" },
  }),
  formatting.black.with({ extra_args = { "--fast" } }),
  formatting.isort,
  formatting.stylua.with({
    extra_args = {
      "--indent-type",
      "Spaces",
      "--indent-width",
      "2",
      "--column-width",
      "120",
      "--collapse-simple-statement",
      "Always",
    },
  }),
  formatting.google_java_format,
  formatting.goimports,
  -- formatting.rustfmt,
  -- diagnostics.flake8,
  null_ls.builtins.code_actions.gitsigns,
  formatting.shfmt.with({ extra_args = { "-i", "2", "-sr", "-ci", "-bn" } }),
  -- null_ls.builtins.code_actions.shellcheck,
  formatting.sql_formatter,
}

local node_root_dir = lspconfig.util.root_pattern("biome.json")
local is_node_repo = node_root_dir(vim.api.nvim_buf_get_name(0)) ~= nil
if is_node_repo then
  table.insert(sources, formatting.biome)
end

null_ls.setup({
  debug = false,
  sources = sources,
})
