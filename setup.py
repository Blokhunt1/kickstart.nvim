#Create a setup script that will instantly install and move all configs to right place

# 1. Setup LSP's to work with
# 1.1 Pyhton
# 1.2 Powershell
# 1.3 C
# 1.4 C++

import subprocess
import shutil
import os

localappdata = os.environ.get("LOCALAPPDATA")
if not localappdata:
    raise EnvironmentError("Environment variable LOCALAPPDATA not available")
nvim_folder = os.path.join(localappdata, "nvim")

userprofile = os.environ.get("USERPROFILE")
if not userprofile:
    raise EnvironmentError("Environment variable USERPROFILE not available")

appdataroaming = os.environ.get("APPDATA")
if not appdataroaming:
    raise EnvironmentError("Environment variable APPDATA not available")
qutebrowser_conf = os.path.join(appdataroaming, "qutebrowser", "config")

#copy items
shutil.copy(os.path.join(nvim_folder, "qutebrowser_conf", "config.py"), qutebrowser_conf) 
shutil.copy(os.path.join(nvim_folder, "wezterm_config", ".wezterm.lua"), userprofile)

print("Config files have been copied to locations")

