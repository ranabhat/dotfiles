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
	config.background = {
		{
			source = {
				-- File = "/.config/wezterm/assets/monterey.png",
				File = constants.bg_image,
			},
			hsb = {
				hue = 1.0,
				saturation = 1.02,
				brightness = 0.25,
			},
			width = "100%",
			height = "100%",
		},
		{
			source = {
				Color = "#282c35",
			},
			height = "100%",
			width = "100%",
			opacity = 0.3,
		},
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
