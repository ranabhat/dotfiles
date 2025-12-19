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
		-- Increase font size
		{
			key = "f",
			mods = "LEADER",
			action = wezterm.action.IncreaseFontSize,
		},
		{
			key = "-",
			mods = "LEADER",
			action = wezterm.action.DecreaseFontSize,
		},

		{
			key = "0",
			mods = "CTRL",
			action = wezterm.action.ResetFontAndWindowSize,
		},
		{
			key = "q",
			mods = "LEADER",
			action = wezterm.action.ActivateCommandPalette,
		},

		{ key = "F9", mods = "ALT", action = wezterm.action.ShowTabNavigator },
		{
			key = "a",
			mods = "LEADER|CTRL",
			action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }),
		},
		{
			key = "Z",
			mods = "LEADER",
			action = wezterm.action.TogglePaneZoomState,
		},
		{
			key = "x",
			mods = "LEADER",
			action = wezterm.action.CloseCurrentPane({ confirm = false }),
		},
		-- {
		-- 	key = "c",
		-- 	mods = "LEADER",
		-- 	action = wezterm.action.SendString("clear\n"),
		-- },

		-- spawm zabbix command line in new tab
		-- spawm zabbix command line in new tab
		-- {
		-- 	key = "z",
		-- 	mods = "LEADER",
		-- 	action = wezterm.action.SpawnCommandInNewTab({
		-- 		args = { "/opt/homebrew/bin/zabbix-cli", "--config", home .. "/.zabbix-cli.toml" },
		-- 	}),
		-- },
		-- CTRL+SHIFT+Space, followed by 'a' will put us in activate-pane
		-- mode until we press some other key or until 1 second (1000ms)
		-- of time elapses

		-- scroll page
		{
			key = "m",
			mods = "LEADER",
			action = wezterm.action.ActivateKeyTable({
				name = "scroll",
				one_shot = false,
			}),
		},
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
		{
			key = "p",
			mods = "LEADER",
			action = wezterm.action.ActivateKeyTable({
				name = "pane_action",
				one_shot = false,
			}),
		},
		{
			key = "b",
			mods = "LEADER",
			action = wezterm.action.ActivateKeyTable({
				name = "ssh_to",
				timeout_milliseconds = 11000,
			}),
		},
		{
			key = "w",
			mods = "LEADER",
			action = wezterm.action_callback(function(window, pane)
				local home = wezterm.home_dir
				local workspaces = {
					{ id = home, label = "Home" },
					{ id = home .. "/Developer/dev-tools", label = "Tools" },
					{ id = home .. "/.dotfiles/.config", label = "Config" },
				}

				window:perform_action(
					wezterm.action.InputSelector({
						action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
							if not id and not label then
								wezterm.log_info("canceled")
							else
								wezterm.log_info("id = " .. id)
								wezterm.log_info("label = " .. label)
								inner_window:perform_action(
									wezterm.action.SwitchToWorkspace({
										name = label,
										spawn = {
											label = "Workspace: " .. label,
											cwd = id,
										},
									}),
									inner_pane
								)
							end
						end),
						title = "Choose Workspace",
						choices = workspaces,
						fuzzy = true,
						fuzzy_description = "Fuzzy find or make a workspace: ",
					}),
					pane
				)
			end),
		},
		{
			key = "9",
			mods = "ALT",
			action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
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
		pane_action = {

			{
				key = "p",
				action = wezterm.action.PaneSelect({
					alphabet = "1234567890",
				}),
			},

			{
				key = "s",
				action = wezterm.action.PaneSelect({
					mode = "SwapWithActive",
				}),
			},
			{
				key = "r",
				action = wezterm.action.RotatePanes("Clockwise"),
			},

			{ key = "Escape", action = "PopKeyTable" },
		},

		scroll = {
			{ key = "k", action = wezterm.action.ScrollByPage(-1) },
			{ key = "j", action = wezterm.action.ScrollByPage(1) },
			{ key = "K", action = wezterm.action.ScrollByLine(-1) },
			{ key = "J", action = wezterm.action.ScrollByLine(1) },
			{ key = "Escape", action = "PopKeyTable" },
		},
		ssh_to = {
			{
				key = "e",
				action = wezterm.action.SpawnCommandInNewTab({
					args = { "ssh", "etuProxy" },
				}),
			},
			{
				key = "0",
				action = wezterm.action.SplitPane({
					direction = "Down", -- or "Left", "Up", "Down"
					command = {
						args = { "ssh", "etuProxy" },
					},
				}),
			},

			{
				key = "t",
				action = wezterm.action.SpawnCommandInNewTab({
					args = { "ssh", "taka" },
				}),
			},
			{
				key = "1",
				action = wezterm.action.SplitPane({
					direction = "Down", -- or "Left", "Up", "Down"
					command = {
						args = { "ssh", "taka" },
					},
				}),
			},
			{
				key = "s",
				action = wezterm.action.SpawnCommandInNewTab({
					args = { os.getenv("HOME") .. "/Developer/dev-tools/scripts/device", "RAPFSA7PWQ" },
				}),
			},
			{
				key = "7",
				action = wezterm.action.SplitPane({
					direction = "Down", -- or "Left", "Up", "Down"
					command = {
						args = { os.getenv("HOME") .. "/Developer/dev-tools/scripts/device", "RAPFSA7PWQ" },
					},
				}),
			},

			{
				key = "m",
				action = wezterm.action.SpawnCommandInNewTab({
					args = { os.getenv("HOME") .. "/Developer/dev-tools/scripts/device", "4RPQD3Z33I" },
				}),
			},
			{
				key = "7",
				action = wezterm.action.SplitPane({
					direction = "Down", -- or "Left", "Up", "Down"
					command = {
						args = { os.getenv("HOME") .. "/Developer/dev-tools/scripts/device", "4RPQD3Z33I" },
					},
				}),
			},

			{ key = "Escape", action = "PopKeyTable" },
		},
	}
end
return M
