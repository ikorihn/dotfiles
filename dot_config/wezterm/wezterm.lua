local wezterm = require("wezterm") ---@type Wezterm
local act = wezterm.action
local utils = require("utils")
local keybinds = require("keybinds")
require("on")

-- ============================================================================
-- General configuration

local config = wezterm.config_builder()
config.bold_brightens_ansi_colors = true
config.initial_cols = 200
config.initial_rows = 60
config.scrollback_lines = 10000

-- Ensure supported font
config.font = wezterm.font_with_fallback({
  "Moralerspace Argon HWJPDOC",
})
config.font_size = 13.0
config.warn_about_missing_glyphs = false

-- Colors: https://wezfurlong.org/wezterm/config/appearance.html
-- Note that "color_scheme" overrides "colors"
config.color_scheme = "tokyonight"
config.colors = {
  tab_bar = {
    inactive_tab_edge = "none",
  },
}
config.window_background_opacity = 0.8
config.macos_window_background_blur = 10

config.set_environment_variables = {
  PATH = "/opt/homebrew/bin:/usr/local/bin:" .. os.getenv("PATH"),
}

----------------------------------------------------
-- Stylize the Window
----------------------------------------------------
config.hide_tab_bar_if_only_one_tab = false
config.show_tabs_in_tab_bar = true
config.show_tab_index_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false

config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}
config.window_background_gradient = {
  colors = { "#000000" },
}
config.window_padding = {
  left = 8,
  right = 8,
  top = 0,
  bottom = 0,
}

config.tab_max_width = 40
config.tab_bar_at_bottom = true
config.enable_scroll_bar = true

-- Keybinds
config.enable_csi_u_key_encoding = true
config.leader = keybinds.leader
config.keys = keybinds.default_keybinds
config.key_tables = keybinds.key_tables
config.mouse_bindings = keybinds.mouse_bindings
config.quick_select_patterns = {
  "[0-9A-Za-z-]+",
}

config.selection_word_boundary = " \t\n{}[]()\"'`+;:,<>|=-"

-- IMEがONのときのShiftやCtrlキーの挙動を制御(Ctrl+mで変換確定など)
config.use_ime = true
config.macos_forward_to_ime_modifier_mask = "SHIFT|CTRL"

return config
