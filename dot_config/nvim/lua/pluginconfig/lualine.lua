-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
local lualine = require("lualine")

-- Color table for highlights
-- stylua: ignore
local colors = {
  bg       = '#202328',
  fg       = '#bbc2cf',
  yellow   = '#ECBE7B',
  cyan     = '#008080',
  darkblue = '#081633',
  green    = '#98be65',
  orange   = '#FF8800',
  violet   = '#a9a1e1',
  magenta  = '#c678dd',
  blue     = '#51afef',
  red      = '#ec5f67',
}

local conditions = {
  buffer_not_empty = function() return vim.fn.empty(vim.fn.expand("%:t")) ~= 1 end,
  hide_in_width = function() return vim.fn.winwidth(0) > 80 end,
  check_git_workspace = function()
    local filepath = vim.fn.expand("%:p:h")
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

-- Config
local config = {
  options = {
    -- Disable sections and component separators
    component_separators = "",
    section_separators = "",
    theme = {
      -- We are going to use lualine_c an lualine_x as left and
      -- right section. Both are highlighted by c theme .  So we
      -- are just setting default looks o statusline
      normal = { c = { fg = colors.fg, bg = colors.bg } },
      inactive = { c = { fg = colors.fg, bg = colors.bg } },
    },
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- These will be filled later
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component) table.insert(config.sections.lualine_c, component) end

-- Inserts a component in lualine_x at right section
local function ins_right(component) table.insert(config.sections.lualine_x, component) end

ins_left({
  function() return "▊" end,
  color = { fg = colors.blue }, -- Sets highlighting of component
  padding = { left = 0, right = 1 }, -- We don't need space before this
})

ins_left({
  -- mode component
  function() return "" end,
  color = function()
    -- auto change color according to neovims mode
    local mode_color = {
      n = colors.red,
      i = colors.green,
      v = colors.blue,
      [""] = colors.blue,
      V = colors.blue,
      c = colors.magenta,
      no = colors.red,
      s = colors.orange,
      S = colors.orange,
      [""] = colors.orange,
      ic = colors.yellow,
      R = colors.violet,
      Rv = colors.violet,
      cv = colors.red,
      ce = colors.red,
      r = colors.cyan,
      rm = colors.cyan,
      ["r?"] = colors.cyan,
      ["!"] = colors.red,
      t = colors.red,
    }
    return { fg = mode_color[vim.fn.mode()] }
  end,
  padding = { right = 1 },
})

ins_left({
  -- filesize component
  "filesize",
  cond = conditions.buffer_not_empty,
})

ins_left({
  "filename",
  file_status = true, -- Displays file status (readonly status, modified status)
  newfile_status = false, -- Display new file status (new file means no write after created)
  path = 1, -- 0: Just the filename 1: Relative path 2: Absolute path 3: Absolute path, with tilde as the home directory
  shorting_target = 40, -- Shortens path to leave 40 spaces in the window for other components. (terrible name, any suggestions?)
  symbols = {
    modified = "[+]", -- Text to show when the file is modified.
    readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
    unnamed = "[No Name]", -- Text to show for unnamed buffers.
    newfile = "[New]", -- Text to show for new created file before first writting
  },
  cond = conditions.buffer_not_empty,
  color = { fg = colors.magenta, gui = "bold" },
})

ins_left({ "location" })

-- wordcount
ins_left({
  function()
    local starts = vim.fn.line("v")
    local ends = vim.fn.line(".")
    local count = starts <= ends and ends - starts + 1 or starts - ends + 1
    local wc = vim.fn.wordcount()
    return count .. "L:" .. wc["visual_chars"] .. "C"
  end,
  cond = function() return vim.fn.mode():find("[Vv]") ~= nil end,
  color = { fg = colors.green },
})

ins_left({ "progress", color = { fg = colors.fg, gui = "bold" } })

ins_left({
  -- Show codepoint at cursor
  function() return "%b(0x%B)" end,
})

ins_left({
  "diagnostics",
  sources = { "nvim_diagnostic" },
  symbols = { error = " ", warn = " ", info = " " },
  diagnostics_color = {
    color_error = { fg = colors.red },
    color_warn = { fg = colors.yellow },
    color_info = { fg = colors.cyan },
  },
})

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
ins_left({
  function() return "%=" end,
})

-- Add components to right sections
local noice_ok, noice = pcall(require, "noice")
if noice_ok then
  ins_right({
    noice.api.statusline.mode.get,
    cond = noice.api.statusline.mode.has,
    color = { fg = colors.green },
  })
end

ins_right({
  "searchcount",
  color = { fg = colors.violet, gui = "bold" },
})

local lsp_names = function()
  local clients = {}
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    if client.name == "null-ls" then
      local sources = {}
      for _, source in ipairs(require("null-ls.sources").get_available(vim.bo.filetype)) do
        table.insert(sources, source.name)
      end
      table.insert(clients, "null-ls(" .. table.concat(sources, ", ") .. ")")
    else
      table.insert(clients, client.name)
    end
  end
  return " " .. table.concat(clients, ", ")
end

-- local lsp_names = function()
--   local clients = vim
--     .iter(vim.lsp.get_active_clients { bufnr = 0 })
--     :map(function(client)
--       if client.name == 'null-ls' then
--         return ('null-ls(%s)'):format(table.concat(
--           vim
--             .iter(require('null-ls.sources').get_available(vim.bo.filetype))
--             :map(function(source)
--               return source.name
--             end)
--             :totable(),
--           ', '
--         ))
--       else
--         return client.name
--       end
--     end)
--     :totable()
--   return ' ' .. table.concat(clients, ', ')
-- end

ins_right({
  -- Lsp server name .
  function()
    local clients = vim.lsp.get_clients()
    if next(clients) == nil then
      return "No Active Lsp"
    end
    return lsp_names()
  end,
  icon = " LSP:",
  color = { fg = "#ffffff", gui = "bold" },
})

ins_right({
  "filetype",
  icons_enabled = true,
})

ins_right({
  "o:encoding", -- option component same as &encoding in viml
  fmt = string.upper, -- I'm not sure why it's upper case either ;)
  cond = conditions.hide_in_width,
  color = { fg = colors.green, gui = "bold" },
})

ins_right({
  "fileformat",
  fmt = string.upper,
  icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
  color = { fg = colors.green, gui = "bold" },
})

ins_right({
  "branch",
  icon = "",
  color = { fg = colors.violet, gui = "bold" },
})

ins_right({
  "diff",
  -- Is it me or the symbol for modified us really weird
  symbols = { added = " ", modified = "󰝤 ", removed = " " },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.orange },
    removed = { fg = colors.red },
  },
  cond = conditions.hide_in_width,
})

ins_right({
  function() return "▊" end,
  color = { fg = colors.blue },
  padding = { left = 1 },
})

-- Now don't forget to initialize lualine
lualine.setup(config)
