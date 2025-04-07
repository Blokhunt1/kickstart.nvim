-- Pull in the wezterm API
local wezterm = require 'wezterm'
local mux = wezterm.mux

-- This will hold the configuration.
local config = wezterm.config_builder()

config.font_dirs = {
  os.getenv 'LOCALAPPDATA' .. '\\nvim\\wezterm_config\\fonts',
}
config.font = wezterm.font '0xProto Nerd Font Mono'
-- This is where you actually apply your config choices
config.initial_rows = 42
config.initial_cols = 150

-- Open in full screen
wezterm.on('gui-startup', function(window)
  local tab, pane, window = mux.spawn_window(cmd or {})
  local gui_window = window:gui_window()
  gui_window:perform_action(wezterm.action.ToggleFullScreen, pane)
end)

-- Spawn a fish shell in login mode
config.default_prog = { 'powershell.exe' }

--- Check if a file or directory exists in this path
function exists(file)
  local ok, err, code = os.rename(file, file)
  if not ok then
    if code == 13 then
      -- Permission denied, but it exists
      return true
    end
  end
  return ok, err
end

--- Check if a directory exists in this path
function is_dir(path)
  -- "/" works on both Unix and Windows
  return exists(path .. '/')
end

if is_dir 'C:\\myFiles' then
  wezterm.log_info 'Found C:/myFiles'
  config.default_cwd = 'C:/myFiles'
elseif is_dir 'H:\\MyFiles' then
  wezterm.log_info 'Found H:/MyFiles'
  config.default_cwd = 'H:/MyFiles'
else
  wezterm.log_error 'No valid default_cwd found!'
end

-- inside your wezterm.lua
config.launch_menu = {
  {
    label = 'Admin PowerShell',
    args = { 'powershell', '-NoExit', '-Command', 'Start-Process powershell -Verb runAs' },
  },
}

config.keys = {
  { key = '1', mods = 'ALT', action = wezterm.action.ActivateTab(0) },
  { key = '2', mods = 'ALT', action = wezterm.action.ActivateTab(1) },
  { key = '3', mods = 'ALT', action = wezterm.action.ActivateTab(2) },
  { key = '4', mods = 'ALT', action = wezterm.action.ActivateTab(3) },
  { key = '5', mods = 'ALT', action = wezterm.action.ActivateTab(4) },
  { key = '6', mods = 'ALT', action = wezterm.action.ActivateTab(5) },
  { key = '7', mods = 'ALT', action = wezterm.action.ActivateTab(6) },
  { key = '8', mods = 'ALT', action = wezterm.action.ActivateTab(7) },
  { key = '9', mods = 'ALT', action = wezterm.action.ActivateTab(-1) }, -- last tab
}

config.adjust_window_size_when_changing_font_size = false

-- For example, changing the color scheme:
config.color_scheme = 'AdventureTime'

-- and finally, return the configuration to wezterm
return config
