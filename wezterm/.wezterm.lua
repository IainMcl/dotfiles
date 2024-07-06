local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- config.enable_tab_bar = true
config.enable_scroll_bar = false
config.scrollback_lines = 3500

-------------------
--- Startup
-------------------
-- config.default_cwd = "~/"
-- open in full screen
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
wezterm.on("gui-startup", function(cmd)
	local _, _, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():toggle_fullscreen()
end)
config.show_update_window = true
config.unicode_version = 15 -- This may cause issues if so revert back to 9 (default)

-------------------
--- Theming
-------------------
config.color_scheme = "Catppuccin Mocha"
-- config.font = wezterm.font_with_fallback({ "Fira Code", "Caskaydia Cove Nerd Font Complete Mono Regular" })
config.font_size = 12
config.adjust_window_size_when_changing_font_size = false
config.line_height = 1.1
config.window_background_image = "C:\\Users\\iainm\\dotfiles\\wezterm\\BackgroundImages\\firewatch_night.jpg"
-- config.window_background_image_mode = "Cover"
config.window_background_image_hsb = {
	brightness = 0.1,
	hue = 1.0,
	saturation = 1.0,
}
config.macos_window_background_blur = 100
config.win32_system_backdrop = "Acrylic"
config.hide_mouse_cursor_when_typing = true
config.hide_tab_bar_if_only_one_tab = true

-- config.window_background_image_blur = 10

-- config.window_background_opacity = 20
-- config.window_background_opacity = 0.75
-- config.window_background_blur = 8

-------------------
--- Keymaps
-------------------
-- timeout_milliseconds defaults to 1000 and can be omitted
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
	{
		key = "a",
		mods = "LEADER|CTRL",
		action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }),
	},
	{
		key = "|",
		mods = "LEADER|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "-",
		mods = "LEADER|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{ key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
	{ key = "+", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
	{ key = "0", mods = "CTRL", action = wezterm.action.ResetFontSize },
}

return config
