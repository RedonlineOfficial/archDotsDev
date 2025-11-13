#!/usr/bin/env python3
# ----------------------------------------------------
# Title: init.py
# Author: RedonlineOfficial
# Updated: 13NOV2025
# About: Entry point to install script.
# ----------------------------------------------------

# Imports
import subprocess
import argparse
import tempfile
import os
import sys

# Argument Parser
parser = argparse.ArgumentParser(description = "Arch Linux Installer based on my preferences.")

# Arguments
parser.add_argument(
    "--debug",
    action="store_true",
    help="Enable debug mode (shows command output)"
)
args = parser.parse_args()

# Packages
packages = [
    # Core Hyprland
    'hyprland',
    'hypridle',
    'hyprlock',
    'hyprpolkitagent',
    'xdg-desktop-portal-hyprland',

    # Extra Hyprland
    'hyprpaper',
    'hyprpicker',
    'hyprsunset',

    # Core Utils
    'xdg-desktop-dirs',
    'wl-clipboard',
    'pipewire',
    'wireplumber',
    'bluez',
    'bluez-utils',
    'udiskie',

    # User interface
    'ly',
    'swaync',
    'waybar',
    'walker',

    # Fonts
    'noto-fonts',
    'ttf-hack-nerd',

    # Core Applications
    'kitty',
    'pacmanfm-qt',

    # Shell applications
    'zsh',
    'git',
    'bluetui',
    'stow',
    'neovim'
]

aurPackages = [ 
    'zen-browser-git'
]

def updateSystem():
    try:
        command = ['sudo', 'pacman', '-Syyu', '--noconfirm' ]

        if args.debug:
            print(f"[DEBUG] Running command: {' '.join(command)}")
            result = subprocess.run(command)
        else:
            result = subprocess.run(
                command,
                stdout = subprocess.PIPE,
                stderr = subprocess.PIPE,
                text = True
            )
        if result.returncode == 0:
            print(f"Successfully updated!")
        else:
            print(f"Update failed!")
            if not args.debug:
                print(result.stderr)
    except Exception as e:
        print(f"An error has occured: {str(e)}")

def installPackages():
    try: 
        command = [ 'sudo', 'pacman', '-S', '--noconfirm' ] + packages

        if args.debug:
            print(f"[DEBUG] Running command: {' '.join(command)}")
            result = subprocess.run(command)
        else:
            result = subprocess.run(
                command,
                stdout = subprocess.PIPE,
                stderr = subprocess.PIPE,
                text = True
            )
        if result.returncode == 0:
            print(f"Successfully installed: {', '.join(packages)}")
        else:
            print(f"Installation failed for: {', '.join(packages)}")
            if not args.debug:
                print(result.stderr)
    except Exception as e:
        print(f"An error has occured: {str(e)}")

def installAurHelper():
    def run(cmd, cwd=None, debug=False, check=False):
        if debug:
            print(f"[DEBUG] Running command: {' '.join(command)}")
            return subprocess.run(cmd, cwd=cwd)
        else:
            return subprocess.run(
                cmd,
                cwd=cwd,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                check=check
            )
    def main():
        try:
            checkIfYayInstalled = ['pacman', '-Q', 'yay']
            result = run(checkIfYayInstalled, debug=args.debug)

            if result.returncode == 0:
                print("yay is already installed.")
                return 0

            print("yay is NOT installed -- installing yay-bin from AUR...")

            with tempfile.TemporaryDirectory() as tmpDir:
                print(f"Using temporary directory: {tmpDir}")

                cloneCommand = ['git', 'clone', 'https://aur.archlinux.org/yay-bin.git']
                r = run(cloneCommand, cwd=tmpDir, debug=args.debug)
                if r.returncode != 0:
                    print("Failed to clone yay-bin repository.")
                    if not args.debug:
                        print(r.stderr)
                    return 1
                
                print("Successfully cloned yay-bin repository.")

                repoDir = os.path.join(tmpDir, 'yay-bin')
                if not os.path.isdir(repoDir):
                    print("Repository directory not found:", repoDir)
                    return 1

                makepkgCommand = ['makepkg', '-si', '--noconfirm']
                print("Building and installing yay-bin...")
                r = run(makepkgCommand, cwd=repoDir, debug=args.debug)
                if r.returncode == 0:
                    print("yay-bin built and installed successfully!")
                    return 0
                else:
                    print("makepkg failed.")
                    if not args.debug:
                        print(r.stderr)
                    return 1
        except FileNotFoundError as fnf:
            print("Required program not found:", fnf)
            print("Make sure git and base-devel are installed.")
            return 2
        except subprocess.CalledProcessError as cpe:
            print("A command failed:", cpe)
            return 3
        except Exception as e:
            print("Unexpected error:", str(e))
            return 4

def installAurPackages():
    try: 
        command = [ 'sudo', 'yay', '-S', '--answerclean', 'None', '--answerdiff', 'None', '--noconfirm' ] + aurPackages

        if args.debug:
            print(f"[DEBUG] Running command: {' '.join(command)}")
            result = subprocess.run(command)
        else:
            result = subprocess.run(
                command,
                stdout = subprocess.PIPE,
                stderr = subprocess.PIPE,
                text = True
            )
        if result.returncode == 0:
            print(f"Successfully installed: {', '.join(aurPackages)}")
        else:
            print(f"Installation failed for: {', '.join(aurPackages)}")
            if not args.debug:
                print(result.stderr)
    except Exception as e:
        print(f"An error has occured: {str(e)}")

# Logic
print('Starting the full Hyprland Desktop install')
updateSystem()
installPackages()
installAurHelper()
installAurPackages()
