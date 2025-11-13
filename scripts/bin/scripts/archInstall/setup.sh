#!/usr/bin/sudo bash
# -----------------------------------------------------------
# Title:    setup.sh
# Author:   Redonline
# Updated:  13NOV2025
# About:    Setup script for the rest of the scripts
#           as python does not come preinstalled on Arch Linux
# ------------------------------------------------------------

# Set python version
pythonVer="3"
pythonPkg="python${pythonVer}"

# Update
echo -e "Updating system...\n"
pacman -Syyu --noconfirm
echo -e "\nSystem Updated!"

# Install Python
echo -e "\nInstalling ${pythonPkg}, standby...\n"
pacman -S --needed --noconfirm ${pythonPkg}
echo -e "\n${pythonPkg} installed!\n" 

# Start python portion
${0%/*}/desktopInstall.py
