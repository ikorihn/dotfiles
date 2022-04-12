local wezterm = require("wezterm")
local utils = require("utils")

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)

---------------------------------------------------------------
--- keybinds
---------------------------------------------------------------
local tmux_keybinds = {

}

local my_keybinds = {
  { key = "LeftArrow"  , mods = "ALT|SHIFT" , action = wezterm.action({ MoveTabRelative = -1 }) },
  { key = "RightArrow" , mods = "ALT|SHIFT" , action = wezterm.action({ MoveTabRelative = 1 }) },
  { key = "LeftArrow"  , mods = "ALT"       , action = wezterm.action({ ActivatePaneDirection = "Left" }) },
  { key = "RightArrow" , mods = "ALT"       , action = wezterm.action({ ActivatePaneDirection = "Right" }) },
  { key = "UpArrow"    , mods = "ALT"       , action = wezterm.action({ ActivatePaneDirection = "Up" }) },
  { key = "DownArrow"  , mods = "ALT"       , action = wezterm.action({ ActivatePaneDirection = "Down" }) },
  { key = "LeftArrow"  , mods = "ALT|CTRL"  , action = wezterm.action({ AdjustPaneSize = { "Left", 1 } }) },
  { key = "RightArrow" , mods = "ALT|CTRL"  , action = wezterm.action({ AdjustPaneSize = { "Right", 1 } }) },
  { key = "UpArrow"    , mods = "ALT|CTRL"  , action = wezterm.action({ AdjustPaneSize = { "Up", 1 } }) },
  { key = "DownArrow"  , mods = "ALT|CTRL"  , action = wezterm.action({ AdjustPaneSize = { "Down", 1 } }) },
  { key = "v"          , mods = "ALT"       , action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
  { key = "s"          , mods = "ALT"       , action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
  { key = "q", mods = "CTRL", action = wezterm.action({ EmitEvent = "toggle-tmux-keybinds" }) },
  { key = "e", mods = "ALT",  action = wezterm.action({ EmitEvent = "trigger-nvim-with-scrollback" }) },
  { key = "l", mods = "SUPER",action = "ShowLauncher" },
  { key = "L", mods = "SUPER|SHIFT",action = wezterm.action{ShowLauncherArgs={flags="FUZZY|TABS|LAUNCH_MENU_ITEMS"}} },
}

-- https://wezfurlong.org/wezterm/config/default-keys.html
local default_keybinds = {
  { key ="c",          mods ="SUPER",          action = wezterm.action({ CopyTo="Clipboard" }) },
  { key ="v",          mods ="SUPER",          action = wezterm.action({ PasteFrom="Clipboard" }) },
  { key ="c",          mods ="CTRL|SHIFT",     action = wezterm.action({ CopyTo="Clipboard" }) },
  { key ="v",          mods ="CTRL|SHIFT",     action = wezterm.action({ PasteFrom="Clipboard" }) },
  { key ="Insert",     mods ="CTRL",           action = wezterm.action({ CopyTo="PrimarySelection" }) },
  { key ="Insert",     mods ="SHIFT",          action = wezterm.action({ PasteFrom="PrimarySelection" }) },
  { key ="m",          mods ="SUPER",          action = "Hide" },
  { key ="n",          mods ="SUPER",          action = "SpawnWindow" },
  { key ="n",          mods ="CTRL|SHIFT",     action = "SpawnWindow" },
  { key ="Enter",      mods ="ALT",            action = "ToggleFullScreen" },
  { key ="-",          mods ="SUPER",          action = "DecreaseFontSize" },
  { key ="-",          mods ="CTRL",           action = "DecreaseFontSize" },
  { key ="=",          mods ="SUPER",          action = "IncreaseFontSize" },
  { key ="=",          mods ="CTRL",           action = "IncreaseFontSize" },
  { key ="0",          mods ="SUPER",          action = "ResetFontSize" },
  { key ="0",          mods ="CTRL",           action = "ResetFontSize" },
  { key ="t",          mods ="SUPER",          action = wezterm.action({ SpawnTab="CurrentPaneDomain" }) },
  { key ="t",          mods ="CTRL|SHIFT",     action = wezterm.action({ SpawnTab="CurrentPaneDomain" }) },
  { key ="T",          mods ="SUPER|SHIFT",    action = wezterm.action({ SpawnTab="DefaultDomain" }) },
  { key ="w",          mods ="SUPER",          action = wezterm.action({ CloseCurrentTab={confirm=true} }) },
  { key ="1",          mods ="SUPER",          action = wezterm.action({ ActivateTab=0 }) },
  { key ="2",          mods ="SUPER",          action = wezterm.action({ ActivateTab=1 }) },
  { key ="3",          mods ="SUPER",          action = wezterm.action({ ActivateTab=2 }) },
  { key ="4",          mods ="SUPER",          action = wezterm.action({ ActivateTab=3 }) },
  { key ="5",          mods ="SUPER",          action = wezterm.action({ ActivateTab=4 }) },
  { key ="6",          mods ="SUPER",          action = wezterm.action({ ActivateTab=5 }) },
  { key ="7",          mods ="SUPER",          action = wezterm.action({ ActivateTab=6 }) },
  { key ="8",          mods ="SUPER",          action = wezterm.action({ ActivateTab=7 }) },
  { key ="9",          mods ="SUPER",          action = wezterm.action({ ActivateTab=-1 }) },
  { key ="w",          mods ="CTRL|SHIFT",     action = wezterm.action({ CloseCurrentTab={confirm=true} }) },
  { key ="1",          mods ="CTRL|SHIFT",     action = wezterm.action({ ActivateTab=0 }) },
  { key ="2",          mods ="CTRL|SHIFT",     action = wezterm.action({ ActivateTab=1 }) },
  { key ="3",          mods ="CTRL|SHIFT",     action = wezterm.action({ ActivateTab=2 }) },
  { key ="4",          mods ="CTRL|SHIFT",     action = wezterm.action({ ActivateTab=3 }) },
  { key ="5",          mods ="CTRL|SHIFT",     action = wezterm.action({ ActivateTab=4 }) },
  { key ="6",          mods ="CTRL|SHIFT",     action = wezterm.action({ ActivateTab=5 }) },
  { key ="7",          mods ="CTRL|SHIFT",     action = wezterm.action({ ActivateTab=6 }) },
  { key ="8",          mods ="CTRL|SHIFT",     action = wezterm.action({ ActivateTab=7 }) },
  { key ="9",          mods ="CTRL|SHIFT",     action = wezterm.action({ ActivateTab=-1 }) },
  { key ="[",          mods ="SUPER|SHIFT",    action = wezterm.action({ ActivateTabRelative=-1 }) },
  { key ="Tab",        mods ="CTRL|SHIFT",     action = wezterm.action({ ActivateTabRelative=-1 }) },
  { key ="PageUp",     mods ="CTRL",           action = wezterm.action({ ActivateTabRelative=-1 }) },
  { key ="]",          mods ="SUPER|SHIFT",    action = wezterm.action({ ActivateTabRelative=1 }) },
  { key ="Tab",        mods ="CTRL",           action = wezterm.action({ ActivateTabRelative=1 }) },
  { key ="PageDown",   mods ="CTRL",           action = wezterm.action({ ActivateTabRelative=1 }) },
  { key ="PageUp",     mods ="CTRL|SHIFT",     action = wezterm.action({ MoveTabRelative=-1 }) },
  { key ="PageDown",   mods ="CTRL|SHIFT",     action = wezterm.action({ MoveTabRelative=1 }) },
  { key ="PageUp",     mods ="SHIFT",          action = wezterm.action({ ScrollByPage=-1 }) },
  { key ="PageDown",   mods ="SHIFT",          action = wezterm.action({ ScrollByPage=1 }) },
  { key ="r",          mods ="SUPER",          action = "ReloadConfiguration" },
  { key ="R",          mods ="CTRL|SHIFT",     action = "ReloadConfiguration" },
  { key ="h",          mods ="SUPER",          action = "HideApplication" },
  { key ="k",          mods ="SUPER",          action = wezterm.action({ ClearScrollback="ScrollbackOnly" }) },
  { key ="K",          mods ="CTRL|SHIFT",     action = wezterm.action({ ClearScrollback="ScrollbackOnly" }) },
  { key ="L",          mods ="CTRL|SHIFT",     action = "ShowDebugOverlay" },
  { key ="f",          mods ="SUPER",          action = wezterm.action({ Search={CaseSensitiveString=""} }) },
  { key ="F",          mods ="CTRL|SHIFT",     action = wezterm.action({ Search={CaseSensitiveString=""} }) },
  { key ="X",          mods ="CTRL|SHIFT",     action = "ActivateCopyMode" },
  { key =" ",          mods ="CTRL|SHIFT",     action = "QuickSelect" },
  { key ='"',          mods ="CTRL|SHIFT|ALT", action = wezterm.action({ SplitVertical={domain="CurrentPaneDomain" } }) },
  { key ="%",          mods ="CTRL|SHIFT|ALT", action = wezterm.action({ SplitHorizontal={domain="CurrentPaneDomain" } }) },
  { key ="LeftArrow",  mods ="CTRL|SHIFT|ALT", action = wezterm.action({ AdjustPaneSize={"Left", 1 } }) },
  { key ="RightArrow", mods ="CTRL|SHIFT|ALT", action = wezterm.action({ AdjustPaneSize={"Right", 1 } }) },
  { key ="UpArrow",    mods ="CTRL|SHIFT|ALT", action = wezterm.action({ AdjustPaneSize={"Up", 1 } }) },
  { key ="DownArrow",  mods ="CTRL|SHIFT|ALT", action = wezterm.action({ AdjustPaneSize={"Down", 1 } }) },
  { key ="LeftArrow",  mods ="CTRL|SHIFT",     action = wezterm.action({ ActivatePaneDirection="Left" }) },
  { key ="RightArrow", mods ="CTRL|SHIFT",     action = wezterm.action({ ActivatePaneDirection="Right" }) },
  { key ="UpArrow",    mods ="CTRL|SHIFT",     action = wezterm.action({ ActivatePaneDirection="Up" }) },
  { key ="DownArrow",  mods ="CTRL|SHIFT",     action = wezterm.action({ ActivatePaneDirection="Down" }) },
  { key ="Z",          mods ="CTRL|SHIFT",     action = "TogglePaneZoomState" },
}

local function create_keybinds()
  return utils.merge_lists(default_keybinds, my_keybinds)
end

---------------------------------------------------------------
--- Launcher menu
---------------------------------------------------------------

local launch_menu = {
  {
    cwd = "$HOME",
  }
}

table.insert(launch_menu, {
  label = "zsh",
  args = {"zsh"},
  cwd = "~",
})


---------------------------------------------------------------
--- wezterm on
---------------------------------------------------------------
function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  -- local handle = io.popen("if git rev-parse --is-inside-work-tree > /dev/null 2>&1 ; then echo git ; else echo notgit ; fi")
  -- local result = handle:read("*a")
  -- handle:close()

  local pane = tab.active_pane
  local title = tab.tab_index + 1 .. ">" .. basename(pane.current_working_dir) .. ":" .. basename(pane.foreground_process_name)
  local color = "navy"

  if tab.is_active then
    return {
      {Background={Color="gray"}},
      {Text=" " .. title .. " "},
    }
  end
  local has_unseen_output = false
  for _, pane in ipairs(tab.panes) do
    if pane.has_unseen_output then
      has_unseen_output = true
      break;
    end
  end
  if has_unseen_output then
    return {
      {Background={Color="Orange"}},
      {Text=" " .. title .. " "},
    }
  end
  return title
end)


-- https://github.com/wez/wezterm/issues/1680
local function update_window_background(window, pane)
  local overrides = window:get_config_overrides() or {}
  -- If there's no foreground process, assume that we are "wezterm connect" or "wezterm ssh"
  -- and use a different background color
  -- if pane:get_foreground_process_name() == nil then
  --   -- overrides.colors = { background = "blue" }
  --   overrides.color_scheme = "Red Alert"
  -- end

  if pane:get_user_vars().production == "1" then
    overrides.color_scheme = "OneHalfDark"
  end
  window:set_config_overrides(overrides)
end

local function update_tmux_style_tab(window, pane)
  local cwd = basename(pane:get_current_working_dir())

  local date = wezterm.strftime("%Y-%m-%d %H:%M:%S ");

  local bat = ""
  for _, b in ipairs(wezterm.battery_info()) do
    bat = "🔋 " .. string.format("%.0f%%", b.state_of_charge * 100)
  end

  window:set_right_status(wezterm.format({
    {Text=bat .. "   "..date},
  }));

  window:set_right_status(wezterm.format({
    { Text = bat .. " " .. date .. " " ..cwd },
  }))
end

local function display_ime_on_right_status(window, pane)
  local compose = window:composition_status()
  if compose then
    compose = "COMPOSING: " .. compose
  end
  window:set_right_status(compose)
end

wezterm.on("update-right-status", function(window, pane)
  update_tmux_style_tab(window, pane)
  update_window_background(window, pane)
  --display_ime_on_right_status(window, pane)
end)

wezterm.on("toggle-tmux-keybinds", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if not overrides.window_background_opacity then
    overrides.window_background_opacity = 0.95
    overrides.keys = create_keybinds()
  else
    overrides.window_background_opacity = nil
    overrides.keys = utils.merge_lists(create_keybinds(), tmux_keybinds)
  end
  window:set_config_overrides(overrides)
end)

local io = require("io")
local os = require("os")

wezterm.on("trigger-nvim-with-scrollback", function(window, pane)
  local scrollback = pane:get_lines_as_text()
  local name = os.tmpname()
  local f = io.open(name, "w+")
  f:write(scrollback)
  f:flush()
  f:close()
  window:perform_action(
    wezterm.action({ SpawnCommandInNewTab = {
      args = { "/opt/homebrew/bin/nvim", name },
    } }),
    pane
  )
  wezterm.sleep_ms(10000)
  os.remove(name)
end)

---------------------------------------------------------------
--- load local_config
---------------------------------------------------------------
-- Write settings you don't want to make public, such as ssh_domains
local function load_local_config()
  local ok, _ = pcall(require, "local")
  if not ok then
    return {}
  end
  return require("local").setup()
end
local local_config = load_local_config()

-- local M = {}
-- local local_config = {
--   ssh_domains = {
--     {
--       -- This name identifies the domain
--       name = "my.server",
--       -- The address to connect to
--       remote_address = "192.168.8.31",
--       -- The username to use on the remote host
--       username = "katayama",
--     },
--   },
-- }
-- function M.setup()
--   return local_config
-- end
-- return M

---------------------------------------------------------------
--- Config
---------------------------------------------------------------
local config = {
  font = wezterm.font("HackGen35Nerd Console"),
  font_size = 14.0,
  -- font_rules = {
  --   {
  --     italic = true,
  --     font = wezterm.font("Cica", { italic = true }),
  --   },
  --   {
  --     italic = true,
  --     intensity = "Bold",
  --     font = wezterm.font("Cica", { weight = "Bold", italic = true }),
  --   },
  -- },
  use_ime = true,
  color_scheme = "Gruvbox Dark",
  color_scheme_dirs = { "$HOME/.config/wezterm/colors/" },
  hide_tab_bar_if_only_one_tab = false,
  adjust_window_size_when_changing_font_size = false,
  selection_word_boundary = " \t\n{}[]()\"'`,;:",
  initial_cols = 180,
  initial_rows = 50,
  window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 0,
  },
  tab_bar_at_bottom = false,
  exit_behavior = "Close",
  scrollback_lines = 10000,
  enable_scroll_bar = true,
  -- window_background_opacity = 0.8,
  disable_default_key_bindings = rue,
  visual_bell = {
    fade_in_function = "EaseIn",
    fade_in_duration_ms = 150,
    fade_out_function = "EaseOut",
    fade_out_duration_ms = 150,
  },
  keys = create_keybinds(),

  launch_menu = launch_menu,
}

return utils.merge_tables(config, local_config)
