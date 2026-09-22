-- Main Wezterm configuration file
local wezterm = require("wezterm")
local commands = require("commands")
local home = os.getenv("HOME")
local mux = wezterm.mux

local config = wezterm.config_builder()
local gpus = wezterm.gui.enumerate_gpus()
wezterm.log_info("reloading")
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
-- local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
-- bar.apply_to_config(config, {
-- 	modules = {
-- 		cwd = {
-- 			enabled = false,
-- 		},
--
-- 		hostname = {
-- 			enabled = false,
-- 		},
--
-- 		clock = {
-- 			enabled = false,
-- 		},
--
-- 		username = {
-- 			enabled = false,
-- 		},
-- 	},
-- })

-- Apply tabline plugin
-- Alternative to bar plugin
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({
	-- options = { theme = "Tokyo Night" },
	-- options = { theme = "GruvboxDark" },
	-- by default following theme is chosen
	-- options = { theme = "Catppuccin Mocha" },
	section_separators = {
		left = wezterm.nerdfonts.pl_left_hard_divider,
		right = wezterm.nerdfonts.pl_right_hard_divider,
	},
	component_separators = {
		left = wezterm.nerdfonts.pl_left_soft_divider,
		right = wezterm.nerdfonts.pl_right_soft_divider,
	},
	tab_separators = {
		left = wezterm.nerdfonts.pl_left_hard_divider,
		right = wezterm.nerdfonts.pl_right_hard_divider,
	},
	sections = {
		tab_active = {
			"index",
			{ "parent", padding = 0 },
			"/",
			{ "cwd", padding = { left = 0, right = 1 } },
			{ "zoomed", padding = 0 },
		},
		tab_inactive = {
			"index",
			{ "parent", padding = 0 },
			"/",
			{ "cwd", padding = { left = 0, right = 1 } },
			-- { "zoomed", padding = 0 },
		},
		tabline_x = { " " },
		tabline_y = { "datetime", "battery" },
		tabline_z = { "domain" },
	},
})
tabline.apply_to_config(config)
wezterm.on("gui-startup", function(cmd)
	-- allow `wezterm start -- something` to affect what we spawn
	-- in our initial window
	local args = {}
	if cmd then
		args = cmd.args
	end

	-- Set a workspace for coding on a current project
	-- Top pane is for the editor, bottom pane is for the build tool
	-- local project_dir = wezterm.home_dir .. "/Developer"
	-- local tab, build_pane, window = mux.spawn_window({
	-- 	workspace = "coding",
	-- 	cwd = project_dir,
	-- 	args = args,
	-- })
	-- -- build_pane:split({
	-- -- 	size = 0.3,
	-- -- 	cwd = project_dir,
	-- -- })
	-- build_pane:split({
	-- 	direction = "Top",
	-- 	-- size = 0.7,
	-- 	top_level = true,
	-- 	cwd = project_dir,
	-- 	args = { "/opt/homebrew/bin/nvim" },
	-- })
	-- may as well kick off a build in that pane
	-- build_pane:send_text 'cargo build\n'
	-- A workspace for interacting with a local machine that
	-- runs some docker containers for home automation
	-- local tab, pane, window = mux.spawn_window({
	-- 	workspace = "automation",
	-- 	args = { "ssh", "taka" },
	-- })

	local tab, pane, window = mux.spawn_window({
		workspace = "dev",
		cwd = wezterm.home_dir .. "/Developer",
		args = args,
	})

	-- pane:split({
	-- 	direction = "Left",
	-- 	size = 0.5,
	-- 	cwd = wezterm.home_dir .. "/Developer/dev-tools",
	-- })

	mux.set_active_workspace("dev")
end)

-- General setiings
config.underline_thickness = 3
config.cursor_thickness = 4
config.underline_position = -6
config.automatically_reload_config = true
config.initial_cols = 120
config.initial_rows = 28
config.scrollback_lines = 2500
config.adjust_window_size_when_changing_font_size = false
config.quick_select_remove_styling = true
config.webgpu_preferred_adapter = gpus[1]
config.front_end = "WebGpu"
config.animation_fps = 1
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.quick_select_patterns = {
	-- match things that look like sha1 hashes
	-- (this is actually one of the default patterns)
	"[0-9a-f]{7,40}",
	"[A-Z2-7]{10}",
	"tolppa40A36BxC4_\\d{5}",
}
config.default_cwd = home .. "/Developer"
return config
