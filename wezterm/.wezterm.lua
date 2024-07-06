local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "Catpuccin Mocha"
-- config.font =
config.font_size = 24

config.enable_tab_bar = false

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.75
config.window_background_blur = 8

return config
