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
local config = {}
-- This is where you actually apply your config choices.
config.automatically_reload_config = true
config.enable_tab_bar = false
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE" --disable the title bar but enable the resizable bor
config.hide_tab_bar_if_only_one_tab = true
config.initial_cols = 120
config.initial_rows = 28
-- font = wezterm.font("JetBrains Mono", { weight = "Bold" }),
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
config.color_scheme = "Nord (Gogh)"
config.default_cursor_style = "BlinkingBar"
config.background = {
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
		opacity = 0.3,
	},
}
config.window_padding = {
	left = 3,
	right = 3,
	top = 0,
	bottom = 0,
}
config.default_cwd = "/Users/paribeshranabhat/Developer/"
-- config.default_gui_startup_args = { "ssh", "etuProxy" }
config.max_fps = 120
config.prefer_egl = true
config.native_macos_fullscreen_mode = false
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
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
	{
		key = '"',
		mods = "LEADER",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},

	{
		key = "Z",
		mods = "LEADER",
		action = wezterm.action.TogglePaneZoomState,
	},

	{
		key = "n",
		mods = "LEADER",
		action = wezterm.action.ToggleFullScreen,
	},
	-- CTRL+SHIFT+Space, followed by 'a' will put us in activate-pane
	-- mode until we press some other key or until 1 second (1000ms)
	-- of time elapses
	{
		key = "r",
		mods = "LEADER",
		action = wezterm.action.ActivateKeyTable({
			name = "resize_pane",
			one_shot = false,
		}),
	},
	{
		key = "a",
		mods = "LEADER",
		action = wezterm.action.ActivateKeyTable({
			name = "activate_pane",
			timeout_milliseconds = 1000,
		}),
	},
	move_pane("j", "Down"),
	move_pane("k", "Up"),
	move_pane("h", "Left"),
	move_pane("l", "Right"),
	{ key = "F1", mods = "ALT", action = wezterm.action.ActivatePaneByIndex(0) },
	{ key = "F2", mods = "ALT", action = wezterm.action.ActivatePaneByIndex(1) },
	{ key = "F3", mods = "ALT", action = wezterm.action.ActivatePaneByIndex(2) },
	{ key = "F4", mods = "ALT", action = wezterm.action.ActivatePaneByIndex(3) },
}

config.key_tables = {
	resize_pane = {
		{ key = "h", action = wezterm.action.AdjustPaneSize({ "Left", 1 }) },
		{ key = "l", action = wezterm.action.AdjustPaneSize({ "Right", 1 }) },
		{ key = "k", action = wezterm.action.AdjustPaneSize({ "Up", 1 }) },
		{ key = "j", action = wezterm.action.AdjustPaneSize({ "Down", 1 }) },
		{ key = "Escape", action = "PopKeyTable" },
	},
	activate_pane = {
		{ key = "h", action = wezterm.action.ActivatePaneDirection("Left") },
		{ key = "l", action = wezterm.action.ActivatePaneDirection("Right") },
		{ key = "k", action = wezterm.action.ActivatePaneDirection("Up") },
		{ key = "j", action = wezterm.action.ActivatePaneDirection("Down") },
	},
}
-- Custom Commands
wezterm.on("augment-command-palette", function()
	return commands
end)
-- For example, changing the initial geometry for new windows:
-- config.initial_cols = 120
-- config.initial_rows = 28

-- or, changing the font size and color scheme.
-- config.font_size = 10
-- config.color_scheme = "AdventureTime"

-- Finally, return the configuration to wezterm:
return config
