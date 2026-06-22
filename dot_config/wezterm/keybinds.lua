local M = {}
local wezterm = require("wezterm") ---@type Wezterm
local act = wezterm.action
local session_manager = require("session-manager")

---------------------------------------------------------------
--- keybinds
---------------------------------------------------------------
M.leader = { key = "q", mods = "CTRL" }

M.default_keybinds = {
  {
    key = "e",
    mods = "ALT",
    action = act({ EmitEvent = "trigger-nvim-with-scrollback" }),
  },
  { key = "o", mods = "ALT", action = act({ EmitEvent = "save-output" }) },

  { key = "UpArrow", mods = "SHIFT", action = act.ScrollToPrompt(-1) },
  { key = "DownArrow", mods = "SHIFT", action = act.ScrollToPrompt(1) },
  { key = "Enter", mods = "ALT", action = "QuickSelect" },
  { key = "Enter", mods = "CTRL", action = act.SendKey({ key = "Enter" }) },
  { key = "o", mods = "CTRL", action = act.DisableDefaultAssignment },

  { key = "l", mods = "SUPER", action = "ShowLauncher" },

  { key = "w", mods = "SUPER", action = act.CloseCurrentPane({ confirm = true }) },

  -- Workspace
  {
    key = "L",
    mods = "SUPER|SHIFT",
    action = act({ ShowLauncherArgs = { flags = "FUZZY|TABS|WORKSPACES|LAUNCH_MENU_ITEMS" } }),
  },
  {
    key = "W",
    mods = "SUPER|SHIFT",
    action = act.PromptInputLine({
      description = "(wezterm) Create new workspace:",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(
            act.SwitchToWorkspace({
              name = line,
            }),
            pane
          )
        end
      end),
    }),
  },
  {
    key = "r",
    mods = "ALT",
    action = act.PromptInputLine({
      description = "(wezterm) Set workspace title:",
      action = wezterm.action_callback(function(win, pane, line)
        if line then wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line) end
      end),
    }),
  },
  {
    key = "w",
    mods = "ALT",
    action = wezterm.action_callback(function(win, pane)
      -- workspace のリストを作成
      local workspaces = {}
      for i, name in ipairs(wezterm.mux.get_workspace_names()) do
        table.insert(workspaces, {
          id = name,
          label = string.format("%d. %s", i, name),
        })
      end
      local current = wezterm.mux.get_active_workspace()
      -- 選択メニューを起動
      win:perform_action(
        act.InputSelector({
          action = wezterm.action_callback(function(_, _, id, label)
            if not id and not label then
              wezterm.log_info("Workspace selection canceled") -- 入力が空ならキャンセル
            else
              win:perform_action(act.SwitchToWorkspace({ name = id }), pane) -- workspace を移動
            end
          end),
          title = "Select workspace",
          choices = workspaces,
          fuzzy = true,
          -- fuzzy_description = string.format("Select workspace: %s -> ", current), -- requires nightly build
        }),
        pane
      )
    end),
  },
  {
    key = "s",
    mods = "LEADER",
    action = wezterm.action_callback(function(window, pane) session_manager.save_state(window) end),
  },
  {
    key = "r",
    mods = "LEADER",
    action = wezterm.action_callback(function(win, pane) session_manager.restore_state(win) end),
  },

  { key = "r", mods = "CMD", action = act.ReloadConfiguration },

  -- Window, Tab, Pane
  { key = ";", mods = "ALT", action = act({ MoveTabRelative = -1 }) },
  { key = "'", mods = "ALT", action = act({ MoveTabRelative = 1 }) },
  {
    key = "s",
    mods = "ALT",
    action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }),
  },
  {
    key = "v",
    mods = "ALT",
    action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
  },
  {
    key = "h",
    mods = "LEADER|SHIFT",
    action = act.Multiple({
      act.AdjustPaneSize({ "Left", 5 }),
      act.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
    }),
  },
  {
    key = "j",
    mods = "LEADER|SHIFT",
    action = act.Multiple({
      act.AdjustPaneSize({ "Down", 5 }),
      act.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
    }),
  },
  {
    key = "k",
    mods = "LEADER|SHIFT",
    action = act.Multiple({
      act.AdjustPaneSize({ "Up", 5 }),
      act.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
    }),
  },
  {
    key = "l",
    mods = "LEADER|SHIFT",
    action = act.Multiple({
      act.AdjustPaneSize({ "Right", 5 }),
      act.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
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
  {
    key = "/",
    mods = "LEADER",
    action = act.Search("CurrentSelectionOrEmptyString"),
  },

  { key = "g", mods = "LEADER", action = act({ EmitEvent = "open-git-tui" }) },
  {
    key = "t",
    mods = "LEADER",
    action = wezterm.action_callback(function(window, pane)
      window:perform_action(
        act.SpawnCommandInNewWindow({
          args = { "bash", "-c", "fd --hidden -t f | fzf -m --bind 'tab:toggle-up' | sed \"s/.*/'&'/\" | tr '\n' ' ' | pbcopy" },
        }),
        pane
      )
      wezterm.sleep_ms(1000)
    end),
  },
}

local default_copy_mode = wezterm.gui.default_key_tables().copy_mode
table.insert(default_copy_mode, { key = "{", action = act.CopyMode("MoveBackwardSemanticZone") })
table.insert(default_copy_mode, { key = "}", action = act.CopyMode("MoveForwardSemanticZone") })

M.key_tables = {
  resize_pane = {
    { key = "h", mods = "SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
    { key = "j", mods = "SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
    { key = "k", mods = "SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
    { key = "l", mods = "SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },
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
    action = act.SendString(key),
  })
end

return M
