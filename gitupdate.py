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
wezterm_conf = os.path.join(userprofile, ".wezterm.lua")

appdataroaming = os.environ.get("APPDATA")
if not appdataroaming:
    raise EnvironmentError("Environment variable APPDATA not available")
qutebrowser_conf = os.path.join(appdataroaming, "qutebrowser", "config", "config.py")

os.makedirs(os.path.join(nvim_folder, "qutebrowser_conf"), exist_ok=True)

#copy items
shutil.copy(qutebrowser_conf, os.path.join(nvim_folder, "qutebrowser_conf")) 
shutil.copy(wezterm_conf, os.path.join(nvim_folder, "wezterm_config"))

val = input("Enter commit description: ")

subprocess.run(["git", "add", "."])
subprocess.run(["git", "commit", "-m", val])
subprocess.run(["git", "push"])

print("Successfully pushed git repo to github!")

