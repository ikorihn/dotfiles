local wezterm = require("wezterm") ---@type Wezterm
local utils = require("utils")
local keybinds = require("keybinds")
local act = wezterm.action

local function create_tab_title(tab, tabs, panes, config, hover, max_width)
  local user_title = tab.active_pane.user_vars.panetitle
  if user_title ~= nil and #user_title > 0 then
    return tab.tab_index + 1 .. ":" .. user_title .. ":" .. utils.basename(tab.active_pane.foreground_process_name)
  end
  -- pane:get_foreground_process_info().status

  local title = wezterm.truncate_right(
    utils.basename(tab.active_pane.current_working_dir)
      .. ":"
      .. utils.basename(tab.active_pane.foreground_process_name),
    max_width
  )
  if title == "" then
    local dir = string.gsub(tab.active_pane.title, "(.*[: ])(.*)]", "%2")
    dir = utils.convert_useful_path(dir)
    title = wezterm.truncate_right(dir, max_width)
  end

  local copy_mode, n = string.gsub(tab.active_pane.title, "(.+) mode: .*", "%1", 1)
  if copy_mode == nil or n == 0 then
    copy_mode = ""
  else
    copy_mode = copy_mode .. ": "
  end
  return copy_mode .. tab.tab_index + 1 .. ":" .. title
end

local function get_tab_index(window, pane)
  local mux_window = window:mux_window()
  for i, tab_info in ipairs(mux_window:tabs_with_info()) do
    for _, p in ipairs(tab_info.tab:panes()) do
      if p:pane_id() == pane:pane_id() then return i end
    end
  end
end

-- Return the Tab's current working directory
local function get_cwd(tab)
  -- Note, returns URL Object: https://wezfurlong.org/wezterm/config/lua/pane/get_current_working_dir.html
  if tab.active_pane.current_working_dir ~= nil then
    return tab.active_pane.current_working_dir.file_path
  else
    return ""
  end
end

-- Remove all path components and return only the last value
local function remove_abs_path(path) return path:gsub("(.*[/\\])(.*)", "%2") end

-- Return the pretty path of the tab's current working directory
local function get_display_cwd(tab)
  local current_dir = get_cwd(tab)
  local HOME_DIR = string.format("file://%s", os.getenv("HOME"))
  return current_dir == HOME_DIR and "~/" or remove_abs_path(current_dir)
end

-- Return the concise name or icon of the running process for display
local function get_process(tab)
  if not tab.active_pane or tab.active_pane.foreground_process_name == "" then return "[?]" end

  local process_name = remove_abs_path(tab.active_pane.foreground_process_name)

  return string.format("[%s]", process_name)
end

-- Pretty format the tab title
local function format_title(tab)
  local cwd = get_display_cwd(tab)
  local process = get_process(tab)

  local active_title = tab.active_pane.title
  if active_title:find("- NVIM") then active_title = active_title:gsub("^([^ ]+) .*", "%1") end

  local description = (not active_title or active_title == cwd) and "~" or active_title
  return string.format(" %s %s/ %s ", process, cwd, description)
end

-- Determine if a tab has unseen output since last visited
local function has_unseen_output(tab)
  if not tab.is_active then
    for _, pane in ipairs(tab.panes) do
      if pane.has_unseen_output then return true end
    end
  end
  return false
end

-- Returns manually set title (from `tab:set_title()` or `wezterm cli set-tab-title`) or creates a new one
local function get_tab_title(tab)
  local title = tab.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then return title end
  return format_title(tab)
end

-- Convert arbitrary strings to a unique hex color value
-- Based on: https://stackoverflow.com/a/3426956/3219667
local function string_to_color(str)
  -- Convert the string to a unique integer
  local hash = 0
  for i = 1, #str do
    hash = string.byte(str, i) + ((hash << 5) - hash)
  end

  -- Convert the integer to a unique color
  local c = string.format("%06X", hash & 0x00FFFFFF)
  return "#" .. (string.rep("0", 6 - #c) .. c):upper()
end

local function select_contrasting_fg_color(hex_color)
  -- Based on: https://stackoverflow.com/a/56678483/3219667
  local function calculate_luminance(color)
    -- Extract RGB components from hex color
    local red, green, blue
    red = tonumber(color:sub(1, 2), 16)
    green = tonumber(color:sub(3, 4), 16)
    blue = tonumber(color:sub(5, 6), 16)
    -- Calculate the luminance of the given color and compare against perceived brightness
    return 0.2126 * red / 255 + 0.7152 * green / 255 + 0.0722 * blue / 255
  end

  local color = hex_color:gsub("#", "") -- Remove leading '#'
  local luminance = calculate_luminance(color)
  if luminance > 0.5 then
    return "#000000" -- Black has higher contrast with colors perceived to be "bright"
  end
  return "#FFFFFF" -- White has higher contrast
end

-- Inline tests
local testColor = string_to_color("/Users/kyleking/Developer/ProjectA")
assert(testColor == "#EBD168", "Unexpected color value for test hash (" .. testColor .. ")")
assert(select_contrasting_fg_color("#494CED") == "#FFFFFF", "Expected higher contrast with white")
assert(select_contrasting_fg_color("#128b26") == "#FFFFFF", "Expected higher contrast with white")
assert(select_contrasting_fg_color("#58f5a6") == "#000000", "Expected higher contrast with black")
assert(select_contrasting_fg_color("#EBD168") == "#000000", "Expected higher contrast with black")

local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle
-- On format tab title events, override the default handling to return a custom title
-- Docs: https://wezfurlong.org/wezterm/config/lua/window-events/format-tab-title.html
---@diagnostic disable-next-line: unused-local
wezterm.on("format-tab-title", function(tab, _tabs, _panes, _config, _hover, max_width)
  local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "
  if title == "" then title = "-" end
  local background = string_to_color(get_cwd(tab))
  local foreground = select_contrasting_fg_color(background)
  local edge_background = "none"
  if not tab.is_active then
    background = "none"
    foreground = "#FFFFFF"
  end
  if has_unseen_output(tab) then foreground = "#EBD168" end
  local edge_foreground = background

  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)

---------------------------------------------------------------
--- wezterm on
---------------------------------------------------------------
-- https://github.com/wez/wezterm/issues/1680
local function update_window_background(window, pane)
  local overrides = window:get_config_overrides() or {}
  -- If there's no foreground process, assume that we are "wezterm connect" or "wezterm ssh"
  -- and use a different background color
  -- if pane:get_foreground_process_name() == nil then
  -- 	-- overrides.colors = { background = "blue" }
  -- 	overrides.color_scheme = "Red Alert"
  -- end

  if overrides.color_scheme == nil then return end
  if pane:get_user_vars().production == "1" then overrides.color_scheme = "OneHalfDark" end
  window:set_config_overrides(overrides)
end

local function update_tmux_style_tab(window, pane)
  local cwd_uri = pane:get_current_working_dir()
  local hostname, cwd = utils.split_from_url(cwd_uri)
  return {
    { Attribute = { Underline = "Single" } },
    { Attribute = { Italic = true } },
    { Text = hostname },
  }
end

local function update_ssh_status(window, pane)
  local text = pane:get_domain_name()
  if text == "local" then text = "" end
  return {
    { Text = text .. " " },
  }
end

local function display_ime_on_right_status(window, pane)
  local compose = window:composition_status()
  if compose then compose = "COMPOSING: " .. compose end
  window:set_right_status(compose)
end

local function display_copy_mode(window, pane)
  local name = window:active_key_table()
  if name then name = "Mode: " .. name end
  return { { Attribute = { Italic = false } }, { Text = (name or "") .. " " } }
end

wezterm.on("update-right-status", function(window, pane)
  -- local tmux = update_tmux_style_tab(window, pane)
  local ssh = update_ssh_status(window, pane)
  local copy_mode = display_copy_mode(window, pane)
  update_window_background(window, pane)

  local date = { { Text = wezterm.strftime("%Y-%m-%d(%a)%H:%M:%S") .. " " } }

  local status = utils.merge_lists(ssh, copy_mode)
  status = utils.merge_lists(status, date)

  window:set_right_status(wezterm.format(status))
end)

-- 直前の出力結果を取得する
wezterm.on("save-output", function(window, pane)
  local zones = pane:get_semantic_zones()
  local last_input_index = nil
  local last_output_index = nil

  -- 後ろから探索して最後の "Output" ゾーンを探す
  for i = #zones, 1, -1 do
    if zones[i].semantic_type == "Output" then
      last_output_index = i
      last_input_index = last_output_index - 1
      break
    end
  end

  if not last_output_index then return nil end
  local latest_input_zone = zones[last_input_index]
  local latest_output_zone = zones[last_output_index]
  local text = "$ "
    .. pane:get_text_from_semantic_zone(latest_input_zone)
    .. "\n"
    .. pane:get_text_from_semantic_zone(latest_output_zone)

  if text == nil then return nil end

  local name = os.tmpname()
  local f = io.open(name, "w+")
  if f == nil then return end
  f:write(text)
  f:flush()
  f:close()
  window:perform_action(
    act.SpawnCommandInNewWindow({
      args = { "nvim", name },
    }),
    pane
  )
  wezterm.sleep_ms(1000)
  os.remove(name)
end)

wezterm.on("toggle-tmux-keybinds", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if not overrides.window_background_opacity then
    overrides.window_background_opacity = 0.95
    overrides.keys = keybinds.default_keybinds
  else
    overrides.window_background_opacity = nil
    overrides.keys = utils.merge_lists(keybinds.default_keybinds, keybinds.tmux_keybinds)
  end
  window:set_config_overrides(overrides)
end)

local io = require("io")
local os = require("os")

wezterm.on("open-git-tui", function(window, pane)
  window:perform_action(
    act.SpawnCommandInNewWindow({
      args = { "tig" },
    }),
    pane
  )
  wezterm.sleep_ms(1000)
end)

wezterm.on("trigger-nvim-with-scrollback", function(window, pane)
  local scrollback =
    pane:get_text_from_region(0, 0, pane:get_dimensions().scrollback_rows, pane:get_dimensions().scrollback_rows)
  local name = os.tmpname()
  local f = io.open(name, "w+")
  if f == nil then return end
  f:write(scrollback)
  f:flush()
  f:close()
  window:perform_action(
    act.SpawnCommandInNewWindow({
      args = { "nvim", name },
    }),
    pane
  )
  wezterm.sleep_ms(1000)
  os.remove(name)
end)

wezterm.on("trigger-window-opacity", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local opacity_default = 0.90
  if overrides.window_background_opacity == opacity_default then
    overrides.window_background_opacity = 1.0
  else
    overrides.window_background_opacity = opacity_default
  end
  window:set_config_overrides(overrides)
end)

local function is_claude(pane)
  local process = pane:get_foreground_process_info()
  if not process or not process.argv then return false end
  -- 引数に"claude"が含まれているかチェック
  for _, arg in ipairs(process.argv) do
    if arg:find("claude") then return true end
  end
  return false
end
wezterm.on("bell", function(window, pane)
  if is_claude(pane) then
    local tab_title = pane:get_title()
    local tab_index = get_tab_index(window, pane) or "?"

    window:toast_notification("Claude Code", "Tab " .. tab_index .. ": " .. tab_title, nil, 10000)
    wezterm.background_child_process({ "afplay", "/System/Library/Sounds/Submarine.aiff" })
  end
end)
