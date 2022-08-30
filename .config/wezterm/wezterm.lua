local wezterm = require("wezterm")
local act = wezterm.action
local utils = require("utils")
local keybinds = require("keybinds")
local scheme = wezterm.get_builtin_color_schemes()["nord"]
require("on")

-- /etc/ssh/sshd_config
-- AcceptEnv TERM_PROGRAM_VERSION COLORTERM TERM TERM_PROGRAM WEZTERM_REMOTE_PANE
-- sudo systemctl reload sshd

---------------------------------------------------------------
--- functions
---------------------------------------------------------------
local function enable_wayland()
	local wayland = os.getenv("XDG_SESSION_TYPE")
	if wayland == "wayland" then
		return true
	end
	return false
end

---------------------------------------------------------------
--- Merge the Config
---------------------------------------------------------------
local function insert_ssh_domain_from_ssh_config(c)
	for host, config in pairs(wezterm.enumerate_ssh_hosts()) do
		table.insert(c.ssh_domains, {
			name = host,
			remote_address = config.hostname .. ":" .. config.port,
			username = config.user,
			multiplexing = "None",
			assume_shell = "Posix",
		})
	end
	return c
end

--- load local_config
-- Write settings you don't want to make public, such as ssh_domains
package.path = os.getenv("HOME") .. "/.local/share/wezterm/?.lua;" .. package.path
local function load_local_config(module)
	local m = package.searchpath(module, package.path)
	if m == nil then
		return {}
	end
	return dofile(m)
	-- local ok, _ = pcall(require, "local")
	-- if not ok then
	-- 	return {}
	-- end
	-- return require("local")
end
local local_config = load_local_config("local")

-- local local_config = {
-- 	ssh_domains = {
-- 		{
-- 			-- This name identifies the domain
-- 			name = "my.server",
-- 			-- The address to connect to
-- 			remote_address = "192.168.8.31",
-- 			-- The username to use on the remote host
-- 			username = "katayama",
-- 		},
-- 	},
-- }
-- return local_config

---------------------------------------------------------------
--- Config
---------------------------------------------------------------
local config = {
	font_size = 16.0,
	-- font_rules = {
	-- 	{
	-- 		italic = true,
	-- 		font = wezterm.font("Cica", { italic = true }),
	-- 	},
	-- 	{
	-- 		italic = true,
	-- 		intensity = "Bold",
	-- 		font = wezterm.font("Cica", { weight = "Bold", italic = true }),
	-- 	},
	-- },
	check_for_updates = false,
	use_ime = true,
	-- ime_preedit_rendering = "System",
	-- use_dead_keys = true,
	warn_about_missing_glyphs = false,
	-- enable_kitty_graphics = false,
	animation_fps = 1,
	cursor_blink_ease_in = "Constant",
	cursor_blink_ease_out = "Constant",
	cursor_blink_rate = 0,
	-- enable_wayland = enable_wayland(),
	-- https://github.com/wez/wezterm/issues/1772
	enable_wayland = false,
	color_scheme = "nightfox",
	-- color_scheme_dirs = { os.getenv("HOME") .. "/.config/wezterm/colors/" },
	hide_tab_bar_if_only_one_tab = false,
	adjust_window_size_when_changing_font_size = false,
	selection_word_boundary = " \t\n{}[]()\"'`,;:│=&!%",
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	use_fancy_tab_bar = false,
	colors = {
		tab_bar = {
			background = scheme.background,
			new_tab = { bg_color = scheme.cursor_fg, fg_color = scheme.ansi[8], intensity = "Bold" },
			new_tab_hover = { bg_color = scheme.ansi[1], fg_color = scheme.brights[8], intensity = "Bold" },
			-- format-tab-title
			-- active_tab = { bg_color = "#121212", fg_color = "#FCE8C3" },
			-- inactive_tab = { bg_color = scheme.background, fg_color = "#FCE8C3" },
			-- inactive_tab_hover = { bg_color = scheme.ansi[1], fg_color = "#FCE8C3" },
		},
	},
	tab_max_width = 40,
	tab_bar_at_bottom = true,
	initial_rows = 48,
	initial_cols = 180,
	scrollback_lines = 10000,
	enable_scroll_bar = true,
	-- window_background_opacity = 0.95,
	disable_default_key_bindings = false,
	-- visual_bell = {
	-- 	fade_in_function = "EaseIn",
	-- 	fade_in_duration_ms = 150,
	-- 	fade_out_function = "EaseOut",
	-- 	fade_out_duration_ms = 150,
	-- },
	-- separate <Tab> <C-i>
	enable_csi_u_key_encoding = true,
	leader = { key = "Space", mods = "CTRL|SHIFT" },
	keys = keybinds.default_keybinds,
	key_tables = keybinds.key_tables,
	mouse_bindings = keybinds.mouse_bindings,
	quick_select_patterns = {
		'[0-9A-Za-z-]+',
	},
}

-- daily font
local font_list = {
  { name = "PlemolJP", setting= wezterm.font("PlemolJP Console", { weight = "Medium" }) },
  { name = "HackGen", setting= wezterm.font("HackGen Console NFJ"), { weight = "Medium" } },
  { name = "Cica", setting= wezterm.font("Cica") },
}

local date = os.date("*t")["yday"]
local today_font = font_list[(date % #font_list) + 1]
config.font = today_font.setting
config.launch_menu = {
    {
      label = "Font: " .. today_font["name"],
      args = { "nvim", "~/.config/wezterm/wezterm.lua" },
    },
  }

local merged_config = utils.merge_tables(config, local_config)
-- return insert_ssh_domain_from_ssh_config(merged_config)
return merged_config
