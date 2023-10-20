local M = {}
local wezterm = require("wezterm")
local act = wezterm.action
local utils = require("utils")

---------------------------------------------------------------
--- keybinds
---------------------------------------------------------------
M.tmux_keybinds = {
	{ key = "[", mods = "", action = act.ActivateCopyMode },
	{ key = "j", mods = "", action = act({ PasteFrom = "PrimarySelection" }) },
	{ key = "h", mods = "", action = act({ ActivatePaneDirection = "Left" }) },
	{ key = "l", mods = "", action = act({ ActivatePaneDirection = "Right" }) },
	{ key = "k", mods = "", action = act({ ActivatePaneDirection = "Up" }) },
	{ key = "j", mods = "", action = act({ ActivatePaneDirection = "Down" }) },
	{ key = "/", mods = "", action = act.Search("CurrentSelectionOrEmptyString") },
	{ key = "Escape", mods = "", action = wezterm.action({ EmitEvent = "toggle-tmux-keybinds" }) },
}

M.default_keybinds = {
	{ key = ";",                   mods = "ALT",         action = wezterm.action({ MoveTabRelative = -1 }) },
	{ key = "'",                   mods = "ALT",         action = wezterm.action({ MoveTabRelative = 1 }) },
	{ key = "s",                   mods = "ALT",         action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "v",                   mods = "ALT",         action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{ key = "e",                   mods = "ALT",         action = wezterm.action({ EmitEvent = "trigger-nvim-with-scrollback" }) },
	{ key = "q",                   mods = "CTRL",        action = wezterm.action({ EmitEvent = "trigger-window-opacity" }) },
	{ key = "UpArrow",             mods = "SHIFT",       action = wezterm.action.ScrollToPrompt(-1) },
	{ key = "DownArrow",           mods = "SHIFT",       action = wezterm.action.ScrollToPrompt(1) },
	{ key = "Enter",               mods = "ALT",         action = "QuickSelect" },
	{ key = "l",                   mods = "SUPER",       action = "ShowLauncher" },
	{ key = "h",                   mods = "CTRL|SHIFT",  action = act({ ActivatePaneDirection = "Left" }) },
	{ key = "l",                   mods = "CTRL|SHIFT",  action = act({ ActivatePaneDirection = "Right" }) },
	{ key = "k",                   mods = "CTRL|SHIFT",  action = act({ ActivatePaneDirection = "Up" }) },
	{ key = "j",                   mods = "CTRL|SHIFT",  action = act({ ActivatePaneDirection = "Down" }) },
	{ key = "h",                   mods = "CTRL|SHIFT|SUPER", action = act.AdjustPaneSize { "Left", 5 } },
	{ key = "l",                   mods = "CTRL|SHIFT|SUPER", action = act.AdjustPaneSize { "Right", 5 } },
	{ key = "k",                   mods = "CTRL|SHIFT|SUPER", action = act.AdjustPaneSize { "Up", 5 } },
	{ key = "j",                   mods = "CTRL|SHIFT|SUPER", action = act.AdjustPaneSize { "Down", 5 } },
	{ key = "w",                   mods = "SUPER",       action = act.CloseCurrentPane { confirm = true } },
	-- { key = "L",                   mods = "SUPER|SHIFT", action = wezterm.action.ShowTabNavigator },
	{ key = "L",                   mods = "SUPER|SHIFT", action = wezterm.action{ShowLauncherArgs={flags="FUZZY|TABS|LAUNCH_MENU_ITEMS"}} },
	{
		key = "r",
		mods = "ALT",
		action = act({
			ActivateKeyTable = {
				name = "resize_pane",
				one_shot = false,
				-- timeout_milliseconds = 3000,
				replace_current = false,
			},
		}),
	},
	{ key = 'r', mods = 'CMD', action = wezterm.action.ReloadConfiguration },

	{ key = "Enter", mods = "SHIFT", action = wezterm.action.SendKey { key = 'Enter' } },
	{ key = "Enter", mods = "CTRL", action = wezterm.action.SendKey { key = 'Enter' } },
	{ key = "Backspace", mods = "SHIFT", action = wezterm.action.SendKey { key = 'Backspace' } },
	{ key = "Backspace", mods = "CTRL", action = wezterm.action.SendKey { key = 'Backspace' } },
}

function M.create_keybinds()
	return utils.merge_lists(M.default_keybinds, M.tmux_keybinds)
end

M.key_tables = {
	resize_pane = {
		{ key = "h", action = act({ AdjustPaneSize = { "Left", 1 } }) },
		{ key = "l", action = act({ AdjustPaneSize = { "Right", 1 } }) },
		{ key = "k", action = act({ AdjustPaneSize = { "Up", 1 } }) },
		{ key = "j", action = act({ AdjustPaneSize = { "Down", 1 } }) },
		-- Cancel the mode by pressing escape
		{ key = "Escape", action = "PopKeyTable" },
	},
	copy_mode = {
		{
		  key = 'Tab',
		  mods = 'NONE',
		  action = act.CopyMode 'MoveForwardWord',
		},
		{
		  key = 'Tab',
		  mods = 'SHIFT',
		  action = act.CopyMode 'MoveBackwardWord',
		},
		{
		  key = 'Enter',
		  mods = 'NONE',
		  action = act.CopyMode 'MoveToStartOfNextLine',
		},
		{ key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
		{
		  key = 'Space',
		  mods = 'NONE',
		  action = act.CopyMode { SetSelectionMode = 'Cell' },
		},
		{
		  key = '$',
		  mods = 'NONE',
		  action = act.CopyMode 'MoveToEndOfLineContent',
		},
		{
		  key = '$',
		  mods = 'SHIFT',
		  action = act.CopyMode 'MoveToEndOfLineContent',
		},
		{
		  key = '0',
		  mods = 'NONE',
		  action = act.CopyMode 'MoveToStartOfLine',
		},
		{
		  key = 'G',
		  mods = 'NONE',
		  action = act.CopyMode 'MoveToScrollbackBottom',
		},
		{
		  key = 'G',
		  mods = 'SHIFT',
		  action = act.CopyMode 'MoveToScrollbackBottom',
		},
		{
		  key = 'H',
		  mods = 'NONE',
		  action = act.CopyMode 'MoveToViewportTop',
		},
		{
		  key = 'H',
		  mods = 'SHIFT',
		  action = act.CopyMode 'MoveToViewportTop',
		},
		{
		  key = 'L',
		  mods = 'NONE',
		  action = act.CopyMode 'MoveToViewportBottom',
		},
		{
		  key = 'L',
		  mods = 'SHIFT',
		  action = act.CopyMode 'MoveToViewportBottom',
		},
		{
		  key = 'M',
		  mods = 'NONE',
		  action = act.CopyMode 'MoveToViewportMiddle',
		},
		{
		  key = 'M',
		  mods = 'SHIFT',
		  action = act.CopyMode 'MoveToViewportMiddle',
		},
		{
		  key = 'O',
		  mods = 'NONE',
		  action = act.CopyMode 'MoveToSelectionOtherEndHoriz',
		},
		{
		  key = 'O',
		  mods = 'SHIFT',
		  action = act.CopyMode 'MoveToSelectionOtherEndHoriz',
		},
		{
		  key = 'V',
		  mods = 'NONE',
		  action = act.CopyMode { SetSelectionMode = 'Line' },
		},
		{
		  key = 'V',
		  mods = 'SHIFT',
		  action = act.CopyMode { SetSelectionMode = 'Line' },
		},
		{
		  key = '^',
		  mods = 'NONE',
		  action = act.CopyMode 'MoveToStartOfLineContent',
		},
		{
		  key = '^',
		  mods = 'SHIFT',
		  action = act.CopyMode 'MoveToStartOfLineContent',
		},
		{ key = 'b', mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },
		{ key = 'b', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
		{ key = 'b', mods = 'CTRL', action = act.CopyMode 'PageUp' },
		{ key = 'c', mods = 'CTRL', action = act.CopyMode 'Close' },
		{ key = 'f', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
		{ key = 'f', mods = 'CTRL', action = act.CopyMode 'PageDown' },
		{
		  key = 'g',
		  mods = 'NONE',
		  action = act.CopyMode 'MoveToScrollbackTop',
		},
		{ key = 'g', mods = 'CTRL', action = act.CopyMode 'Close' },
		{ key = 'h', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
		{ key = 'j', mods = 'NONE', action = act.CopyMode 'MoveDown' },
		{ key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp' },
		{ key = 'l', mods = 'NONE', action = act.CopyMode 'MoveRight' },
		{
		  key = 'm',
		  mods = 'ALT',
		  action = act.CopyMode 'MoveToStartOfLineContent',
		},
		{
		  key = 'o',
		  mods = 'NONE',
		  action = act.CopyMode 'MoveToSelectionOtherEnd',
		},
		{ key = 'q', mods = 'NONE', action = act.CopyMode 'Close' },
		{
		  key = 'v',
		  mods = 'NONE',
		  action = act.CopyMode { SetSelectionMode = 'Cell' },
		},
		{
		  key = 'v',
		  mods = 'CTRL',
		  action = act.CopyMode { SetSelectionMode = 'Block' },
		},
		{ key = 'w', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
		{
		  key = 'y',
		  mods = 'NONE',
		  action = act.Multiple {
			{ CopyTo = 'ClipboardAndPrimarySelection' },
			{ CopyMode = 'Close' },
		  },
		},
		{ key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PageUp' },
		{ key = 'PageDown', mods = 'NONE', action = act.CopyMode 'PageDown' },
		{ key = 'LeftArrow', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
		{
		  key = 'LeftArrow',
		  mods = 'ALT',
		  action = act.CopyMode 'MoveBackwardWord',
		},
		{
		  key = 'RightArrow',
		  mods = 'NONE',
		  action = act.CopyMode 'MoveRight',
		},
		{
		  key = 'RightArrow',
		  mods = 'ALT',
		  action = act.CopyMode 'MoveForwardWord',
		},
		{ key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'MoveUp' },
		{ key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'MoveDown' },
	},
	search_mode = {
		{ key = 'Enter', mods = 'NONE', action = act.CopyMode 'NextMatch' },
		{ key = 'Enter', mods = 'SHIFT', action = act.CopyMode 'PriorMatch' },
		{ key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
		{ key = 'n', mods = 'CTRL', action = act.CopyMode 'NextMatch' },
		{ key = 'p', mods = 'CTRL', action = act.CopyMode 'PriorMatch' },
		{ key = 'r', mods = 'CTRL', action = act.CopyMode 'CycleMatchType' },
		{ key = 'u', mods = 'CTRL', action = act.CopyMode 'ClearPattern' },
		{ key = "/", mods = "NONE", action = act.Search("CurrentSelectionOrEmptyString") },
		{
			key = 'PageUp',
			mods = 'NONE',
			action = act.CopyMode 'PriorMatchPage',
		},
		{
			key = 'PageDown',
			mods = 'NONE',
			action = act.CopyMode 'NextMatchPage',
		},
		{ key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
		{
			key = 'DownArrow',
			mods = 'NONE',
			action = act.CopyMode 'NextMatch',
		},
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
