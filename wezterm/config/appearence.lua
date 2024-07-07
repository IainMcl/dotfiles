local function get_background_image()
	-- select a random background image from the backgroundimages folder
	local background_dir = "c:\\users\\iainm\\wezterm\\backgroundimages"
	local background_images = {
		background_dir .. "\\firewatch_night.jpg",
		background_dir .. "\\windows-error.jpg",
		background_dir .. "\\salty_mountains.png",
		background_dir .. "\\forrest.png",
		background_dir .. "\\comfy-home.png",
		background_dir .. "\\shaded_landscape.png",
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

local dimmer = { brightness = 0.2 }

local config = {

	color_scheme = "Catppuccin Mocha",
	-- font = wezterm.font_with_fallback({ "Fira Code", "Caskaydia Cove Nerd Font Complete Mono Regular" })
	font_size = 12,
	adjust_window_size_when_changing_font_size = false,
	line_height = 1.1,

	background = {
		{
			source = {
				file = get_background_image(),
			},
			hsb = dimmer,
			vertical_align = "bottom",
			horizontal_align = "center",
		},
	},
	-- window_background_image_mode = "cover"
	window_background_image_hsb = {
		brightness = 0.1,
		hue = 1.0,
		saturation = 1.0,
	},
}

return config
