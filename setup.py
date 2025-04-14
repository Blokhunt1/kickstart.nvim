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


# Resolve the PowerShell profile path
import subprocess

# Run PowerShell to get the actual $PROFILE path
result = subprocess.run(
    ["powershell", "-NoProfile", "-Command", "$PROFILE"],
    capture_output=True,
    text=True
)

powershell_profile = result.stdout.strip()
print(f"Resolved PowerShell profile path: {powershell_profile}")

starship_line = "Invoke-Expression (&starship init powershell)"

# Create the profile file if it doesn't exist
if not os.path.exists(powershell_profile):
    os.makedirs(os.path.dirname(powershell_profile), exist_ok=True)
    with open(powershell_profile, "w", encoding="utf-16") as f:
        f.write("")

# Check if the line already exists
with open(powershell_profile, "r", encoding="utf-16") as f:
    contents = f.read()

if starship_line not in contents:
    with open(powershell_profile, "a", encoding="utf-16") as f:
        f.write(f"\n{starship_line}\n")
    print(f"✅ Starship init line added to: {powershell_profile}")
else:
    print(f"ℹ️ Starship init line already present in: {powershell_profile}")

print("Config files have been copied to locations")

