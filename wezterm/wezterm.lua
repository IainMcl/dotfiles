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
config.font_size = 15
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
--- Mouse bindings
-------------------

config.mouse_bindings = {
    {
        event = { Up = { streak = 1, button = "Left" } },
        mods = "CTRL",
        action = "OpenLinkAtMouseCursor"
    }
}

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
    { key = "-", mods = "CTRL",   action = wezterm.action.DecreaseFontSize },
    { key = "+", mods = "CTRL",   action = wezterm.action.IncreaseFontSize },
    { key = "0", mods = "CTRL",   action = wezterm.action.ResetFontSize },
    { key = "t", mods = "LEADER", action = wezterm.action.ToggleFullScreen },
    { key = "f", mods = "LEADER", action = wezterm.action.TogglePaneZoomState },
    { key = "t", mods = "CTRL",   action = wezterm.action.SpawnTab("DefaultDomain") },
    { key = "w", mods = "CTRL",   action = wezterm.action.CloseCurrentTab({ confirm = true }) },
    {
        key = "b",
        mods = "LEADER",
        action = wezterm.action_callback(function()
            print("toggle background")
            local new_background = get_background_image()
            print(new_background)
            if new_background then
                print("new background")
                wezterm.set_background_image(new_background)
                -- wezterm.set_backbackground = {
                -- 	{
                -- 		source = {
                -- 			File = new_background,
                -- 		},
                -- 		hs = dimmer,
                -- 		vertical_align = "Bottom",
                -- 		horizontal_align = "Center",
                -- 	},
                -- }
            end
        end),
    },
}

return config

-- return config:append(appearance):build()
