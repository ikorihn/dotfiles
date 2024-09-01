local M = {}
local wezterm = require("wezterm")
local act = wezterm.action

---------------------------------------------------------------
--- keybinds
---------------------------------------------------------------
M.leader = { key = "q", mods = "CTRL" }

M.default_keybinds = {
  { key = ";", mods = "ALT", action = wezterm.action({ MoveTabRelative = -1 }) },
  { key = "'", mods = "ALT", action = wezterm.action({ MoveTabRelative = 1 }) },
  {
    key = "s",
    mods = "ALT",
    action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }),
  },
  {
    key = "v",
    mods = "ALT",
    action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
  },
  {
    key = "e",
    mods = "ALT",
    action = wezterm.action({ EmitEvent = "trigger-nvim-with-scrollback" }),
  },

  { key = "UpArrow", mods = "SHIFT", action = wezterm.action.ScrollToPrompt(-1) },
  { key = "DownArrow", mods = "SHIFT", action = wezterm.action.ScrollToPrompt(1) },
  { key = "Enter", mods = "ALT", action = "QuickSelect" },
  { key = "l", mods = "SUPER", action = "ShowLauncher" },

  { key = "w", mods = "SUPER", action = act.CloseCurrentPane({ confirm = true }) },
  -- { key = "L",                   mods = "SUPER|SHIFT", action = wezterm.action.ShowTabNavigator },
  {
    key = "L",
    mods = "SUPER|SHIFT",
    action = wezterm.action({ ShowLauncherArgs = { flags = "FUZZY|TABS|LAUNCH_MENU_ITEMS" } }),
  },
  { key = "r", mods = "CMD", action = wezterm.action.ReloadConfiguration },

  {
    key = "r",
    mods = "LEADER",
    action = act.ActivateKeyTable({
      name = "resize_pane",
      one_shot = false,
    }),
  },
  {
    key = "a",
    mods = "LEADER",
    action = act.ActivateKeyTable({
      name = "activate_pane",
      one_shot = false,
    }),
  },
  {
    key = "[",
    mods = "LEADER",
    action = act.ActivateCopyMode,
  },
  {
    key = "/",
    mods = "LEADER",
    action = act.Search("CurrentSelectionOrEmptyString"),
  },
}

M.key_tables = {
  resize_pane = {
    { key = "h", action = act({ AdjustPaneSize = { "Left", 1 } }) },
    { key = "l", action = act({ AdjustPaneSize = { "Right", 1 } }) },
    { key = "k", action = act({ AdjustPaneSize = { "Up", 1 } }) },
    { key = "j", action = act({ AdjustPaneSize = { "Down", 1 } }) },
    -- Cancel the mode by pressing escape
    { key = "Escape", action = "PopKeyTable" },
    { key = "q", action = "PopKeyTable" },
  },
  activate_pane = {
    { key = "h", action = act.ActivatePaneDirection("Left") },
    { key = "l", action = act.ActivatePaneDirection("Right") },
    { key = "k", action = act.ActivatePaneDirection("Up") },
    { key = "j", action = act.ActivatePaneDirection("Down") },
    -- Cancel the mode by pressing escape
    { key = "Escape", action = "PopKeyTable" },
    { key = "q", action = "PopKeyTable" },
  },
}

M.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = act({ CompleteSelection = "ClipboardAndPrimarySelection" }),
  },
  {
    event = { Up = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = act({ PasteFrom = "Clipboard" }),
  },
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "SUPER",
    action = "OpenLinkAtMouseCursor",
  },
}

return M
