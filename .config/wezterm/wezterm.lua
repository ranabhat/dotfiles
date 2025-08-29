-- Pull in the wezterm API
local wezterm = require("wezterm")
local constants = require("constants")
local commands = require("commands")
local function move_pane(key, direction)
	return {
		key = key,
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection(direction),
	}
end
local function move_pane(key, direction)
	return {
		key = key,
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection(direction),
	}
end
-- This will hold the configuration.
local config = wezterm.config_builder()
-- This is where you actually apply your config choices.
config = {
	automatically_reload_config = true,
	enable_tab_bar = false,
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE", --disable the title bar but enable the resizable border
	hide_tab_bar_if_only_one_tab = true,
	initial_cols = 120,
	initial_rows = 28,
	-- font = wezterm.font("JetBrains Mono", { weight = "Bold" }),
	font = wezterm.font({
		family = "JetBrains Mono",
		weight = "Bold",
		harfbuzz_features = {
			"calt=0",
			"clig=0",
			"liga=0",
		}, -- Disable ligatures if preferred
	}),
	font_size = 12.5,
	color_scheme = "Nord (Gogh)",
	default_cursor_style = "BlinkingBar",
	background = {
		{
			source = {
				-- File = "/Users/paribeshranabhat/.config/wezterm/assets/monterey.png",
				File = constants.bg_darker,
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
			opacity = 0.9,
		},
	},
	window_padding = {
		left = 3,
		right = 3,
		top = 0,
		bottom = 0,
	},
	max_fps = 120,
	prefer_egl = true,
	leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 },
	keys = {
		{
			key = '"',
			mods = "LEADER",
			action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "%",
			mods = "LEADER",
			action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "a",
			mods = "LEADER|CTRL",
			action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }),
		},
		move_pane("j", "Down"),
		move_pane("k", "Up"),
		move_pane("h", "Left"),
		move_pane("l", "Right"),
		{ key = "F1", mods = "ALT", action = wezterm.action.ActivatePaneByIndex(0) },
		{ key = "F2", mods = "ALT", action = wezterm.action.ActivatePaneByIndex(1) },
		{ key = "F3", mods = "ALT", action = wezterm.action.ActivatePaneByIndex(2) },
		{ key = "F4", mods = "ALT", action = wezterm.action.ActivatePaneByIndex(3) },
	},

	-- Custom Commands
	wezterm.on("augment-command-palette", function()
		return commands
	end),
}
-- For example, changing the initial geometry for new windows:
-- config.initial_cols = 120
-- config.initial_rows = 28

-- or, changing the font size and color scheme.
-- config.font_size = 10
-- config.color_scheme = "AdventureTime"

-- Finally, return the configuration to wezterm:
return config
