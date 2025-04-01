-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.initial_rows = 42
config.initial_cols = 150

-- Spawn a fish shell in login mode
config.default_prog = { "powershell.exe" }

config.default_cwd = "C:/myfiles"

-- For example, changing the color scheme:
config.color_scheme = "AdventureTime"

-- and finally, return the configuration to wezterm
return config
