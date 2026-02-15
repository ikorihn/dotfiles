local M = {}
local wezterm = require("wezterm")
local act = wezterm.action

local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
resurrect.state_manager.periodic_save({
  interval_seconds = 15 * 60,
  save_workspaces = true,
  save_windows = true,
  save_tabs = true,
})
wezterm.on("resurrect.error", function(err)
  wezterm.log_error("ERROR!")
  wezterm.gui.gui_windows()[1]:toast_notification("resurrect", err, nil, 3000)
end)

---------------------------------------------------------------
--- keybinds
---------------------------------------------------------------
M.leader = { key = "q", mods = "CTRL" }

M.default_keybinds = {
  {
    key = "e",
    mods = "ALT",
    action = wezterm.action({ EmitEvent = "trigger-nvim-with-scrollback" }),
  },
  { key = "o", mods = "ALT", action = wezterm.action({ EmitEvent = "save-output" }) },

  { key = "UpArrow", mods = "SHIFT", action = wezterm.action.ScrollToPrompt(-1) },
  { key = "DownArrow", mods = "SHIFT", action = wezterm.action.ScrollToPrompt(1) },
  { key = "Enter", mods = "ALT", action = "QuickSelect" },
  { key = "Enter", mods = "CTRL", action = wezterm.action.SendKey({ key = "Enter" }) },
  { key = "o", mods = "CTRL", action = wezterm.action.DisableDefaultAssignment },

  { key = "l", mods = "SUPER", action = "ShowLauncher" },

  { key = "w", mods = "SUPER", action = act.CloseCurrentPane({ confirm = true }) },
  -- { key = "L",                   mods = "SUPER|SHIFT", action = wezterm.action.ShowTabNavigator },
  {
    key = "L",
    mods = "SUPER|SHIFT",
    action = wezterm.action({ ShowLauncherArgs = { flags = "FUZZY|TABS|LAUNCH_MENU_ITEMS" } }),
  },
  { key = "r", mods = "CMD", action = wezterm.action.ReloadConfiguration },

  -- Window, Tab, Pane
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
    key = "h",
    mods = "LEADER|SHIFT",
    action = wezterm.action.Multiple({
      wezterm.action.AdjustPaneSize({ "Left", 5 }),
      wezterm.action.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
    }),
  },
  {
    key = "j",
    mods = "LEADER|SHIFT",
    action = wezterm.action.Multiple({
      wezterm.action.AdjustPaneSize({ "Down", 5 }),
      wezterm.action.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
    }),
  },
  {
    key = "k",
    mods = "LEADER|SHIFT",
    action = wezterm.action.Multiple({
      wezterm.action.AdjustPaneSize({ "Up", 5 }),
      wezterm.action.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
    }),
  },
  {
    key = "l",
    mods = "LEADER|SHIFT",
    action = wezterm.action.Multiple({
      wezterm.action.AdjustPaneSize({ "Right", 5 }),
      wezterm.action.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
    }),
  },
  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "h", mods = "ALT", action = act.ActivateTabRelative(-1) },
  { key = "l", mods = "ALT", action = act.ActivateTabRelative(1) },

  -- CopyMode
  { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
  { key = "Enter", mods = "SHIFT", action = act.ActivateCopyMode },
  {
    key = "/",
    mods = "LEADER",
    action = act.Search("CurrentSelectionOrEmptyString"),
  },

  -- resurrect
  {
    key = "s",
    mods = "LEADER",
    action = resurrect.tab_state.save_tab_action(),
  },
  {
    key = "r",
    mods = "LEADER",
    action = wezterm.action_callback(function(win, pane)
      resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id, label)
        local type = string.match(id, "^([^/]+)") -- match before '/'
        id = string.match(id, "([^/]+)$") -- match after '/'
        id = string.match(id, "(.+)%..+$") -- remove file extention
        local opts = {
          relative = true,
          restore_text = true,
          on_pane_restore = resurrect.tab_state.default_on_pane_restore,
        }
        if type == "workspace" then
          local state = resurrect.state_manager.load_state(id, "workspace")
          resurrect.workspace_state.restore_workspace(state, opts)
        elseif type == "window" then
          local state = resurrect.state_manager.load_state(id, "window")
          resurrect.window_state.restore_window(pane:window(), state, opts)
        elseif type == "tab" then
          local state = resurrect.state_manager.load_state(id, "tab")
          resurrect.tab_state.restore_tab(pane:tab(), state, opts)
        end
      end)
    end),
  },
}

local default_copy_mode = wezterm.gui.default_key_tables().copy_mode
table.insert(default_copy_mode, { key = "{", action = act.CopyMode("MoveBackwardSemanticZone") })
table.insert(default_copy_mode, { key = "}", action = act.CopyMode("MoveForwardSemanticZone") })

M.key_tables = {
  resize_pane = {
    { key = "h", mods = "SHIFT", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
    { key = "j", mods = "SHIFT", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },
    { key = "k", mods = "SHIFT", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
    { key = "l", mods = "SHIFT", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
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

  copy_mode = default_copy_mode,
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

local keys_to_fix = {
  ";",
  ",",
  ".",
  "/",
  "'",
}
for _, key in ipairs(keys_to_fix) do
  -- CTRL + key を押したときに、その key の文字列をそのまま送信する
  table.insert(M.default_keybinds, {
    key = key,
    mods = "CTRL",
    action = wezterm.action.SendString(key),
  })
end

return M
