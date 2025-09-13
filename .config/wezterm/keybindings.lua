-- Keybindings configuration module

local wezterm = require("wezterm")
local home = os.getenv("HOME")

local M = {}

-- Helper function for pane movement
local function move_pane(key, direction)
	return {
		key = key,
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection(direction),
	}
end

function M.apply(config)
	-- Set leader key
	config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

	--Keybindings
	config.keys = {
		-- Pane splitting
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

		{
			key = "x",
			mods = "LEADER",
			action = wezterm.action.CloseCurrentPane({ confirm = false }),
		},
		{
			key = "c",
			mods = "LEADER",
			action = wezterm.action.SendString("clear\n"),
		},
		-- spawm zabbix command line in new tab
		{
			key = "z",
			mods = "LEADER",
			action = wezterm.action.SpawnCommandInNewTab({
				args = { "/opt/homebrew/bin/zabbix-cli", "--config", home .. "/.zabbix-cli.toml" },
			}),
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
			{ key = "h", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
			{ key = "l", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
			{ key = "k", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
			{ key = "j", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },
			{ key = "Escape", action = "PopKeyTable" },
		},
		activate_pane = {
			{ key = "h", action = wezterm.action.ActivatePaneDirection("Left") },
			{ key = "l", action = wezterm.action.ActivatePaneDirection("Right") },
			{ key = "k", action = wezterm.action.ActivatePaneDirection("Up") },
			{ key = "j", action = wezterm.action.ActivatePaneDirection("Down") },
		},
	}
end
return M
