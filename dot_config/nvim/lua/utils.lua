local M = {}

M.ToggleQuickFix = function()
  if vim.fn.empty(vim.fn.filter(vim.fn.getwininfo(), "v:val.quickfix")) == 1 then
    vim.cmd([[copen]])
  else
    vim.cmd([[cclose]])
  end
end
vim.cmd([[command! -nargs=0 -bar ToggleQuickFix lua require('utils').ToggleQuickFix()]])

-- https://neovim.discourse.group/t/reload-init-lua-and-all-require-d-scripts/971/11
M.ReloadConfig = function()
  dofile(vim.env.MYVIMRC)
  vim.notify("Nvim configuration reloaded!", vim.log.levels.INFO)
end
vim.cmd([[command! -nargs=0 -bar ReloadConfig lua require('utils').ReloadConfig()]])

M.Jq = function(...)
  local arg = ""
  for _, v in pairs({ ... }) do
    arg = arg .. v .. " "
  end

  if arg == "" then arg = "." end
  vim.notify("jq " .. arg, vim.log.levels.INFO)

  vim.cmd("%! jq " .. arg)
end
vim.cmd([[command! -nargs=? -bar Jq lua require('utils').Jq(<f-args>)]])

M.OpenUrlOrFile = function()
  local cfile = vim.fn.expand("<cfile>")
  if cfile:match("^https?://") then
    vim.ui.open(cfile)
    return
  end

  -- "key=value" 形式の場合、"=" 以前(と"=")を削除する
  -- 例: "file=main.c:10" -> "main.c:10"
  -- 例: "main.c:10" -> "main.c:10" (変化なし)
  local clean_text = cfile:gsub("^[^=]*=", "")
  -- 末尾が ":数字" で終わっているかチェック
  local file_path, line_nr = clean_text:match("^(.*):(%d+)$")
  print(file_path)

  -- 行番号がない場合は、全体をファイルパスとする
  if not file_path then file_path = clean_text end

  -- 存在確認
  if vim.fn.filereadable(file_path) == 1 then
    -- ファイルが存在する場合
    if line_nr then
      vim.cmd(string.format("edit +%s %s", line_nr, file_path))
    else
      vim.cmd("edit " .. file_path)
    end
  else
    -- ファイルが存在しない場合: メッセージを出して何もしない
    vim.notify("File not found: " .. file_path, vim.log.levels.WARN)
  end
end
vim.cmd([[command! -nargs=0 -bar OpenUrlOrFile lua require('utils').OpenUrlOrFile()]])

local function human_to_bytes(str)
  -- 空白を削除し、大文字に統一
  str = str:gsub("%s+", ""):upper()

  -- 数値部分と単位部分を分離
  local val, unit = str:match("([%d%.]+)(%a*)")
  if not val then return nil end

  val = tonumber(val)

  -- 単位ごとの倍率（1024基準）
  local units = {
    B = 1,
    K = 1024,
    KB = 1024,
    M = 1024 ^ 2,
    MB = 1024 ^ 2,
    G = 1024 ^ 3,
    GB = 1024 ^ 3,
    T = 1024 ^ 4,
    TB = 1024 ^ 4,
  }

  -- 単位がない場合はバイトとみなす
  if unit == "" then return math.floor(val) end

  local multiplier = units[unit] or 1
  return math.floor(val * multiplier)
end

M.ReplaceSmartToBytes = function()
  -- 選択範囲の開始位置と終了位置を取得
  local pos_s = vim.fn.getpos("'<")
  local pos_e = vim.fn.getpos("'>")
  local srow, scol = pos_s[2], pos_s[3]
  local erow, ecol = pos_e[2], pos_e[3]

  -- 矩形選択の場合、列番号が前後することがあるので整列
  local start_col = math.min(scol, ecol)
  local end_col = math.max(scol, ecol)
  local start_row = math.min(srow, erow)
  local end_row = math.max(srow, erow)

  -- 下の行から順に処理すると、文字数が変わっても座標がズレない
  for r = end_row, start_row, -1 do
    -- 指定範囲のテキストを取得 (0-indexedのため -1)
    -- nvim_buf_get_text は (buf, start_row, start_col, end_row, end_col, opts)
    local lines = vim.api.nvim_buf_get_text(0, r - 1, start_col - 1, r - 1, end_col, {})
    local current_text = lines[1] or ""

    local bytes = human_to_bytes(current_text)
    if bytes then
      -- 1行ずつ置換を実行
      vim.api.nvim_buf_set_text(0, r - 1, start_col - 1, r - 1, end_col, { tostring(bytes) })
    end
  end
end
vim.cmd([[command! -nargs=0 -range -bar ReplaceSmartToBytes lua require('utils').ReplaceSmartToBytes()]])

-- Get file path
local function get_range_str(opts)
  if opts.range ~= 2 then return "" end
  if opts.line1 == opts.line2 then return "#L" .. opts.line1 end
  return "#L" .. opts.line1 .. "-L" .. opts.line2
end
local function copy_path(opts, target)
  local expr = "%"
  if target == "absolute" then
    expr = "%:p"
  elseif target == "dirname" then
    expr = "%:h"
  elseif target == "filename" then
    expr = "%:t"
  end

  local path = vim.fn.expand(expr) .. get_range_str(opts)
  vim.fn.setreg("*", path)
  vim.notify("Copied " .. target .. ": " .. path)
end

vim.api.nvim_create_user_command(
  "CopyFilePathAbsolute",
  function(opts) copy_path(opts, "absolute") end,
  { range = true, desc = "Copy the full path of the current file to the clipboard" }
)
vim.api.nvim_create_user_command(
  "CopyFilePathRelative",
  function(opts) copy_path(opts, "relative path") end,
  { range = true, desc = "Copy the relative path of the current file to the clipboard" }
)
vim.api.nvim_create_user_command(
  "CopyFilePathName",
  function(opts) copy_path(opts, "filename") end,
  { range = true, desc = "Copy the file name of the current file to the clipboard" }
)
vim.api.nvim_create_user_command(
  "CopyFilePathDir",
  function(opts) copy_path(opts, "dirname") end,
  { range = true, desc = "Copy the file name of the current file to the clipboard" }
)

return M
