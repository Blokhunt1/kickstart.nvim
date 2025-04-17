-- Pull in the wezterm API
local wezterm = require 'wezterm'
local mux = wezterm.mux

-- This will hold the configuration.
local config = wezterm.config_builder()

config.font_dirs = {
  os.getenv 'LOCALAPPDATA' .. '\\nvim\\wezterm_config\\fonts',
}
config.font = wezterm.font '0xProto Nerd Font Mono'

config.color_scheme = 'Catppuccin Mocha'

-- Override background to ensure it blends with tab bar
config.colors = {
  background = '#1e1e2e', -- Mocha base
  tab_bar = {
    background = '#1e1e2e',
    active_tab = {
      bg_color = '#89b4fa', -- blue
      fg_color = '#1e1e2e', -- dark text on bright tab
    },
    inactive_tab = {
      bg_color = '#313244',
      fg_color = '#cdd6f4',
    },
    inactive_tab_hover = {
      bg_color = '#45475a',
      fg_color = '#ffffff',
      italic = true,
    },
    new_tab = {
      bg_color = '#1e1e2e',
      fg_color = '#89b4fa',
    },
  },
}

wezterm.on('format-tab-title', function(tab)
  local pane = tab.active_pane
  local cwd_uri = pane.current_working_dir

  local cwd = cwd_uri and cwd_uri:match 'file:///[A-Z]:/(.*)' or ''
  cwd = cwd:gsub('/', '\\')

  return {
    { Text = '  ' .. cwd },
  }
end)

config.window_frame = {
  font = wezterm.font { family = '0xProto Nerd Font Mono', weight = 'Bold' },
  font_size = 10.5,
  active_titlebar_bg = '#1e1e2e', -- match your theme background
  inactive_titlebar_bg = '#1e1e2e',
}

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
config.default_prog = { 'pwsh.exe' }

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
    label = 'PowerShell (Admin)',
    args = { 'pwsh.exe' },
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

config.window_padding = {
  left = 3,
  right = 3,
  top = 3,
  bottom = 0,
}

-- For example, changing the color scheme:
config.color_scheme = 'Catppuccin Mocha' -- or Macchiato, Frappe, Latte

config.tab_bar_at_bottom = true

-- and finally, return the configuration to wezterm
return config
