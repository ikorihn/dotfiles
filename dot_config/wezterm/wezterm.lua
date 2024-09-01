local wezterm = require("wezterm")
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
  "HackGen Console NF",
})
config.font_size = 16.0

-- Colors: https://wezfurlong.org/wezterm/config/appearance.html
-- Note that "color_scheme" overrides "colors"
config.color_scheme = "tokyonight"
config.window_background_opacity = 0.9

-- Stylize the Window
config.hide_tab_bar_if_only_one_tab = false
config.show_tab_index_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = false
config.window_padding = {
  left = 8,
  right = 8,
  top = 0,
  bottom = 0,
}

config.tab_max_width = 40
config.tab_bar_at_bottom = true
config.enable_scroll_bar = true

config.enable_csi_u_key_encoding = true
config.leader = keybinds.leader
config.keys = keybinds.default_keybinds
config.key_tables = keybinds.key_tables
config.mouse_bindings = keybinds.mouse_bindings
config.quick_select_patterns = {
  "[0-9A-Za-z-]+",
}

return config
