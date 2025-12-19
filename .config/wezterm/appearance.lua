-- Appearance configuration module
local wezterm = require("wezterm")
local constants = require("constants")

local M = {}

function M.apply(config)
	-- Font settings
	config.font = wezterm.font({
		family = "JetBrains Mono",
		weight = "Bold",
		harfbuzz_features = {
			"calt=0",
			"clig=0",
			"liga=0",
		}, -- Disable ligatures if preferred
	})
	config.font_size = 12.5
	-- config.line_height = 1.2

	-- Color scheme and cursor
	config.color_scheme = "Tokyo Night"
	config.default_cursor_style = "BlinkingBar"

	-- Background
	-- config.background = {
	-- 	{
	-- 		source = {
	-- 			-- File = "/.config/wezterm/assets/monterey.png",
	-- 			File = constants.bg_image,
	-- 		},
	-- 		hsb = {
	-- 			hue = 1.0,
	-- 			saturation = 1.02,
	-- 			brightness = 0.25,
	-- 		},
	-- 		width = "100%",
	-- 		height = "100%",
	-- 	},
	-- 	{
	-- 		source = {
	-- 			Color = "#282c35",
	-- 		},
	-- 		height = "100%",
	-- 		width = "100%",
	-- 		opacity = 0.5,
	-- 	},
	-- }

	config.window_background_gradient = {
		-- Can be "Vertical" or "Horizontal".  Specifies the direction
		-- in which the color gradient varies.  The default is "Horizontal",
		-- with the gradient going from left-to-right.
		-- Linear and Radial gradients are also supported; see the other
		-- examples below
		orientation = "Vertical",

		-- Specifies the set of colors that are interpolated in the gradient.
		-- Accepts CSS style color specs, from named colors, through rgb
		-- strings and more
		colors = {
			"#0f0c29",
			"#302b63",
			"#24243e",
		},

		-- Instead of specifying `colors`, you can use one of a number of
		-- predefined, preset gradients.
		-- A list of presets is shown in a section below.
		-- preset = "Warm",

		-- Specifies the interpolation style to be used.
		-- "Linear", "Basis" and "CatmullRom" as supported.
		-- The default is "Linear".
		interpolation = "Linear",

		-- How the colors are blended in the gradient.
		-- "Rgb", "LinearRgb", "Hsv" and "Oklab" are supported.
		-- The default is "Rgb".
		blend = "Rgb",

		-- To avoid vertical color banding for horizontal gradients, the
		-- gradient position is randomly shifted by up to the `noise` value
		-- for each pixel.
		-- Smaller values, or 0, will make bands more prominent.
		-- The default value is 64 which gives decent looking results
		-- on a retina macbook pro display.
		-- noise = 64,

		-- By default, the gradient smoothly transitions between the colors.
		-- You can adjust the sharpness by specifying the segment_size and
		-- segment_smoothness parameters.
		-- segment_size configures how many segments are present.
		-- segment_smoothness is how hard the edge is; 0.0 is a hard edge,
		-- 1.0 is a soft edge.

		-- segment_size = 11,
		-- segment_smoothness = 0.0,
	}

	-- Window appearance
	config.window_decorations = "RESIZE" --disable the title bar but enable the resizable bor
	config.window_close_confirmation = "NeverPrompt"
	config.window_padding = {
		left = 3,
		right = 3,
		top = 0,
		bottom = 0,
	}

	-- Tab bar setting
	config.enable_tab_bar = true
	config.hide_tab_bar_if_only_one_tab = false
	config.tab_bar_at_bottom = true

	-- Performance settings
	config.max_fps = 120
	config.prefer_egl = true
	config.native_macos_fullscreen_mode = false
end
return M
