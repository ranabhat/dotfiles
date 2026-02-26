-- Keybindings configuration module

local wezterm = require("wezterm")
local home = os.getenv("HOME")

local M = {}
-- Show which key table is active in the status area
-- wezterm.on("update-right-status", function(window, _)
-- 	local name = window:active_key_table()
-- 	if name then
-- 		name = "TABLE: " .. name
-- 	end
-- 	window:set_right_status(name or "")
-- end)

function M.apply(config)
	-- Set leader key
	config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

	config.launch_menu = {
		{
			label = "Wezterm Keybindings",
			args = { "/opt/homebrew/bin/nvim", "wezterm/keybindings.lua" },
			cwd = home .. "/.dotfiles/.config",
		},
		{
			label = "Aerospace config",
			args = { "/opt/homebrew/bin/nvim", "aerospace/aerospace.toml" },
			cwd = home .. "/.dotfiles/.config",
		},

		{
			label = "Lazygit config",
			args = { "/opt/homebrew/bin/nvim", "lazygit/config.yml" },
			cwd = home .. "/.dotfiles/.config",
		},

		{
			label = "zshrc config",
			args = { "/opt/homebrew/bin/nvim", home .. "/.zshrc" },
		},

		{
			label = "fzf config",
			args = { "/opt/homebrew/bin/nvim", "fzf/fzfrc" },
			cwd = home .. "/.dotfiles/.config",
		},

		-- {
		-- 	-- Optional label to show in the launcher. If omitted, a label
		-- 	-- is derived from the `args`
		-- 	label = "Bash",
		-- 	-- The argument array to spawn.  If omitted the default program
		-- 	-- will be used as described in the documentation above
		-- 	args = { "bash", "-l" },
		--
		-- 	-- You can specify an alternative current working directory;
		-- 	-- if you don't specify one then a default based on the OSC 7
		-- 	-- escape sequence will be used (see the Shell Integration
		-- 	-- docs), falling back to the home directory.
		-- 	-- cwd = "/some/path"
		--
		-- 	-- You can override environment variables just for this command
		-- 	-- by setting this here.  It has the same semantics as the main
		-- 	-- set_environment_variables configuration option described above
		-- 	-- set_environment_variables = { FOO = "bar" },
		-- },
	}
	config.ssh_domains = {
		{
			name = "openclaw-mac-vm",
			remote_address = "192.168.64.4",
			username = "developer",
			multiplexing = "None",
			ssh_option = {
				identityfile = "~/.ssh/openclaw-mac-cm",
			},
		},
	}
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
			key = "q",
			mods = "LEADER",
			action = wezterm.action.ActivateCommandPalette,
		},
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
		{
			key = "f",
			mods = "ALT",
			action = wezterm.action.ActivateKeyTable({
				name = "font_size",
				until_unknown = true,
				one_shot = false,
			}),
		},

		-- scroll page
		{
			key = "m",
			mods = "ALT",
			action = wezterm.action.ActivateKeyTable({
				name = "scroll",
				until_unknown = true,
				one_shot = false,
			}),
		},
		{
			key = "p",
			mods = "ALT",
			action = wezterm.action.ActivateKeyTable({
				name = "pane_action",
				-- until_unknown = true,
				one_shot = true,
			}),
		},
		{
			key = "t",
			mods = "LEADER",
			action = wezterm.action.ActivateKeyTable({
				name = "move_tab",
				-- until_unknown = true,
				one_shot = true,
			}),
		},
		{ key = "n", mods = "CTRL|SHIFT", action = wezterm.action.SwitchWorkspaceRelative(1) },
		{ key = "p", mods = "CTRL|SHIFT", action = wezterm.action.SwitchWorkspaceRelative(-1) },
		{
			key = "a",
			mods = "ALT",
			action = wezterm.action.ActivateKeyTable({
				name = "ssh_to",
				-- until_unknown = true,
				one_shot = true,
			}),
		},
		-- { key = "F1", mods = "ALT", action = wezterm.action.ShowLauncher },
		{
			key = "F9",
			mods = "ALT",
			action = wezterm.action.ShowLauncherArgs({
				-- flags = "FUZZY|TABS|LAUNCH_MENU_ITEMS|WORKSPACES",
				flags = "FUZZY|LAUNCH_MENU_ITEMS|WORKSPACES",
			}),
		},
		{
			key = "F1",
			mods = "ALT",
			action = wezterm.action.ActivatePaneByIndex(0),
		},
		{
			key = "F2",
			mods = "ALT",
			action = wezterm.action.ActivatePaneByIndex(1),
		},
		{
			key = "F3",
			mods = "ALT",
			action = wezterm.action.ActivatePaneByIndex(2),
		},
		{
			key = "F4",
			mods = "ALT",
			action = wezterm.action.ActivatePaneByIndex(4),
		},
		{
			key = "F8",
			mods = "ALT",
			action = wezterm.action_callback(function(window, pane)
				local home = wezterm.home_dir
				local workspaces = {
					{ id = home .. "/Developer/repos/pe-github/parkkisahko-pilot", label = "PP-Ansible" },
					{ id = home .. "/Developer/dev-tools", label = "Tools" },
					{ id = home .. "/Developer/pe-issues/device-log", label = "Charger-Log" },
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
						fuzzy_description = "Fuzzy find or create a workspace: ",
					}),
					pane
				)
			end),
		},
	}

	config.key_tables = {
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
				key = "t",
				action = wezterm.action.PaneSelect({
					alphabet = "adfqwe",
					mode = "MoveToNewTab",
				}),
			},
			{
				key = "r",
				action = wezterm.action.RotatePanes("Clockwise"),
			},
			{
				key = "x",
				action = wezterm.action.CloseCurrentPane({ confirm = false }),
			},
			{ key = "h", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
			{ key = "l", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
			{ key = "k", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
			{ key = "j", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },

			-- { key = "Escape", action = "PopKeyTable" },
		},
		move_tab = {
			{
				key = "1",
				action = wezterm.action.MoveTab(0),
			},
			{
				key = "2",
				action = wezterm.action.MoveTab(1),
			},
			{
				key = "3",
				action = wezterm.action.MoveTab(2),
			},
			{
				key = "4",
				action = wezterm.action.MoveTab(3),
			},
			{
				key = "5",
				action = wezterm.action.MoveTab(4),
			},
			{
				key = "6",
				action = wezterm.action.MoveTab(5),
			},
			{
				key = "7",
				action = wezterm.action.MoveTab(6),
			},
		},
		font_size = {
			-- Increase font size
			{
				key = "+",
				action = wezterm.action.IncreaseFontSize,
			},
			{
				key = "-",
				action = wezterm.action.DecreaseFontSize,
			},

			{
				key = "=",
				action = wezterm.action.ResetFontAndWindowSize,
			},
		},
		scroll = {
			{ key = "h", action = wezterm.action.ActivatePaneDirection("Left") },
			{ key = "l", action = wezterm.action.ActivatePaneDirection("Right") },
			{ key = "k", action = wezterm.action.ActivatePaneDirection("Up") },
			{ key = "j", action = wezterm.action.ActivatePaneDirection("Down") },
			{ key = "u", action = wezterm.action.ScrollByPage(-1) },
			{ key = "d", action = wezterm.action.ScrollByPage(1) },
			{ key = "U", action = wezterm.action.ScrollByLine(-1) },
			{ key = "D", action = wezterm.action.ScrollByLine(1) },
			-- { key = "Escape", action = "PopKeyTable" },
		},
		ssh_to = {
			{
				key = "e",
				action = wezterm.action.SpawnCommandInNewTab({
					args = { "ssh", "etuProxy" },
				}),
			},
			{
				key = "E",
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
				key = "T",
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
					args = { home .. "/Developer/dev-tools/scripts/device", "RAPFSA7PWQ" },
				}),
			},
			{
				key = "S",
				action = wezterm.action.SplitPane({
					direction = "Down", -- or "Left", "Up", "Down"
					command = {
						args = { home .. "/Developer/dev-tools/scripts/device", "RAPFSA7PWQ" },
					},
				}),
			},

			{
				key = "m",
				action = wezterm.action.SpawnCommandInNewTab({
					args = { home .. "/Developer/dev-tools/scripts/device", "4RPQD3Z33I" },
				}),
			},
			{
				key = "M",
				action = wezterm.action.SplitPane({
					direction = "Down", -- or "Left", "Up", "Down"
					command = {
						args = { home .. "/Developer/dev-tools/scripts/device", "4RPQD3Z33I" },
					},
				}),
			},

			-- { key = "Escape", action = "PopKeyTable" },
		},
	}
end
return M
