-- Main Wezterm configuration file
local wezterm = require("wezterm")
local commands = require("commands")
local home = os.getenv("HOME")

local config = wezterm.config_builder()

-- Import modular configuartion files
local appearance = require("appearance")
local keybindings = require("keybindings")

-- Apply configuration from modules
appearance.apply(config)
keybindings.apply(config)

-- Custom Commands
wezterm.on("augment-command-palette", function()
	return commands
end)

-- Apply bar plugin
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
bar.apply_to_config(config, {
	modules = {
		cwd = {
			enabled = false,
		},

		hostname = {
			enabled = false,
		},

		clock = {
			enabled = false,
		},

		username = {
			enabled = false,
		},
	},
})

-- General setiings
config.automatically_reload_config = true
config.initial_cols = 120
config.initial_rows = 28
config.default_cwd = home .. "/Developer"
return config
