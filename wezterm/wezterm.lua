-- local Config = require("config")
--
-- require("BackgroundImages"):set_files():random()
--
-- require("events.right-status").setup()
-- require("events.left-status").setup()
-- require("events.tab-title").setup()
-- require("events.new-tab-button").setup()
--
-- return Config:init():append(require("config.appearance")):append(require("config.keys"))
-- :append(require('config.domains'))
-- :append(require('config.fonts'))
-- :append(require('config.general'))
-- :append(require('config.launch')).options-- local wezterm = require("wezterm")
--
local wezterm = require("wezterm")
local config = wezterm.config_builder()
-- local appearance = require("config.appearance")

-- config.enable_tab_bar = true
config.enable_scroll_bar = false
config.scrollback_lines = 3500

-------------------
--- Startup
-------------------
-- config.default_cwd = "~/"
-- open in full screen
-- config.window_decorations = "RESIZE"
config.window_decorations = "TITLE | RESIZE"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
-- wezterm.on("gui-startup", function(cmd)
-- 	local _, _, window = wezterm.mux.spawn_window(cmd or {})
-- 	window:gui_window():toggle_fullscreen()
-- end)
config.show_update_window = true
config.unicode_version = 15 -- This may cause issues if so revert back to 9 (default)

-------------------
--- Theming
-------------------
config.color_scheme = "Catppuccin Frappe"
-- config.font = wezterm.font_with_fallback({ "Fira Code", "Caskaydia Cove Nerd Font Complete Mono Regular" })
config.font_size = 12
config.adjust_window_size_when_changing_font_size = false
config.line_height = 1.1

local function get_background_image()
	-- Select a random background image from the BackgroundImages folder
	local home_dir = os.getenv("HOME") or os.getenv("USERPROFILE")
	local background_dir = home_dir .. "/dotfiles/wezterm/BackgroundImages/"
	local background_images = {
		background_dir .. "firewatch_night.jpg",
		-- background_dir .. "windows-error.jpg",
		background_dir .. "salty_mountains.png",
		background_dir .. "forrest.png",
		background_dir .. "comfy-home.png",
		background_dir .. "shaded_landscape.png",
	}
	-- for _, file in ipairs(wezterm.glob("*", { dir = background_dir })) do
	-- 	if file:match("%.png$") or file:match("%.jpg$") then
	-- 		table.insert(background_images, file)
	-- 	end
	-- end
	if #background_images == 0 then
		return nil
	end
	return background_images[math.random(#background_images)]
end

local dimmer = { brightness = 0.1 }

-- config.background = {
--     {
--         source = {
--             File = get_background_image(),
--         },
--         hsb = dimmer,
--         vertical_align = "Bottom",
--         horizontal_align = "Center",
--     },
-- }
-- config.window_background_image_mode = "Cover"
config.window_background_image_hsb = {
	brightness = 0.1,
	hue = 1.0,
	saturation = 1.0,
}
-- config.macos_window_background_blur = 10
-- config.window_background_opacity = 0.75
-- config.win32_system_backdrop = "Acrylic"
config.hide_mouse_cursor_when_typing = true
config.hide_tab_bar_if_only_one_tab = true

-- config.window_background_image_blur = 10

-- config.window_background_opacity = 20
-- config.window_background_opacity = 0.75
-- config.window_background_blur = 8

-------------------
--- Tab bar
-------------------

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end

	local pane_cwd = tab_info.active_pane.cwd
	if pane_cwd and #pane_cwd > 0 then
		-- The CWD is a URL; we want to extract the path component
		local uri = wezterm.url.parse(pane_cwd)
		-- and then we want the basename of the path
		-- uri.path will be `/path/to/basename`
		local basename = uri.path:match("([^/]+)$")
		if basename and #basename > 0 then
			return basename
		end
	end

	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local edge_background = "#0b0022"
	local background = "#1b1032"
	local foreground = "#808080"

	if tab.is_active then
		background = "#2b2042"
		foreground = "#c0c0c0"
	elseif hover then
		background = "#3b3052"
		foreground = "#909090"
	end

	local edge_foreground = background

	local title = tab_title(tab)

	-- ensure that the titles fit in the available space,
	-- and that we have room for the edges.
	title = wezterm.truncate_right(title, max_width - 2)

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)
-------------------
--- Mouse bindings
-------------------

config.mouse_bindings = {
	-- Ctrl-click will open the link under the mouse cursor
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

-------------------
--- Keymaps
-------------------

local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(key)
	return {
		key = key,
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection(direction_keys[key]),
		-- action = wezterm.action_callback(function(win, pane)
		-- 	if pane:get_users_vars().IS_NVIM == "true" then
		-- 		-- pass the keys through to vim/nvim
		-- 		win:perform_action({
		-- 			SendKey = { key = key, mods = "CTRL" },
		-- 		}, pane)
		-- 	else
		-- 		win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
		-- 	end
		-- end),
	}
end

-- timeout_milliseconds defaults to 1000 and can be omitted
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
	{
		key = "a",
		mods = "LEADER|CTRL",
		action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }),
	},
	{ key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
	{ key = "+", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
	{ key = "t", mods = "LEADER", action = wezterm.action.ToggleFullScreen },
	{ key = "f", mods = "LEADER", action = wezterm.action.TogglePaneZoomState },
	{ key = "t", mods = "CTRL", action = wezterm.action.SpawnTab("DefaultDomain") },
	{ key = "w", mods = "CTRL", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
	{
		key = '"',
		mods = "LEADER",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},

	{
		key = "%",
		mods = "LEADER",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "x",
		mods = "LEADER",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
	-- { key = "[", mods = "LEADER", action = wezterm.action.ActivateCopyMode },
	{
		key = "c",
		mods = "LEADER",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},

	{
		key = "p",
		mods = "LEADER",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		key = "n",
		mods = "LEADER",
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		key = "w",
		mods = "LEADER",
		action = wezterm.action.ShowTabNavigator,
	},
	split_nav("h"),
	split_nav("j"),
	split_nav("k"),
	split_nav("l"),
	{
		key = "r",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = "Enter new name for tab:",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
}

-- Send xterm-style escape codes for CMD+Arrow keys on macOS.
-- table.insert(config.keys, {
-- 	key = "Left",
-- 	mods = "SUPER",
-- 	action = wezterm.action.SendString("\x1b[1;5D"),
-- })
-- table.insert(config.keys, {
-- 	key = "Right",
-- 	mods = "SUPER",
-- 	action = wezterm.action.SendString("\x1b[1;5C"),
-- })

for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = wezterm.action.ActivateTab(i - 1),
	})
end

return config

-- return config:append(appearance):build()
