-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.initial_rows = 42
config.initial_cols = 150

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

-- For example, changing the color scheme:
config.color_scheme = 'AdventureTime'

-- and finally, return the configuration to wezterm
return config
