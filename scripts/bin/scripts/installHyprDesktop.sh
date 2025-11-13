# -------------------------------------------------------------------------
# Title: installHyprDesktop.sh
# About: Simple script to install everything needed for my hyprland desktop
# Updated: 13NOV2025
# -------------------------------------------------------------------------

# Package Variables
hyprEcosystem=(
  "hyprland"  # Base Hyprland package
  "hyprpaper" # Hyprland wallpaper engine
  "hyprpicker"  # Color picker
  "hypridle"  # Hyprland idle management daemon
  "hyprlock"  # Hyprland lockscreen utility
  "hyprsunset"  # Hyprland blue-light filter
  "hyprpolkitagent" # Hyprland polkit agent
  "xdg-desktop-portal-hyprland" # Hyprland xdg-desktop-portal backend
)

coreDesktopUtils=(
  # Utilities
  "xdg-desktop-dirs"  # User default directories
  "zsh" # Zsh shell
  "wl-clipboard"  # Clipboard management
  "pipewire"  # Sound and video engine
  "wireplumber" # Session and policy manager for pipewire
  "bluez" # Bluetooth management
  "bluez-utils" # Provides bluetoothctl
  "udiskie" # Automatic mounting of storage drives

  # System fonts
  "noto-fonts"  # Primary system fonts
  "ttf-hack-nerd" # Hack font patched with nerd fonts

  # User Interface
  "ly"  # Display manager
  "swaync"  # Notification daemon
  "waybar"  # Status bar
  "walker"  # Run menu

  # Core Applications
  "kitty" # Terminal emulator
  "neovim"  # Text editor
  "pcmanfm-qt"  # QT6 File manager
)

aurApplications=(
  "zen-browser-bin" # Enhanced firefox based browser
)

# Run updates
updateSystem() {
  sudo pacman -Syyu --noconfirm
  trap updateError ERR
}

updateError() {
  echo "System failed to update.  (c)ontinue, (r)etry, (a)bort?: "
  read -r local errResponse
  case "$errResponse" in
    c | C)
      echo "Continuing to install..."
      installHyprEcosystem
      ;;
    r | R)
      echo "Retrying update..."
      updateSystem
      ;;
    a | A)
      echo "Aborting..."
      exit 1
      ;;
    *)
      echo "Invalid option entered, please enter a valid option"
      updateError
      ;;
  esac
}

installYay() {
  if pacman -Q "yay" &>/dev/null; then
    echo "yay is already installed skipping..."
  else
    echo "yay not installed, installing..."
    sudo pacman -S --needed --noconfirm git base-devel
    cwd=$PWD
    cd $(mktemp -d)
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si
    echo "Installation done"
    cd $cwd
  fi
}

installHyprEcosystem() {
  echo "Installing the following packages:"

  # Verify
  printf '%s\n' "${hyprEcosystem[@]}"
  echo "Continue? [Y/n]: "
  read -r local insResponse
  case "$insResponse" in
    "" | [yY])
      echo "Starting install..."
      ;;
    [nN])
      echo "Aborting..."
      exit 1
      ;;
    *)
      echo "Invalid option, try again"
      installHyprEcosystem
      ;;
  esac

  # Continue install
  sudo pacman -S --needed --noconfirm "${hyprEcosystem[@]}"
  trap installError ERR
}

installCoreDesktopUtils() {
  echo "Installing the following packages:"

  # Verify
  printf '%s\n' "${coreDesktopUtils}"
  echo "Continue? [Y/n]: "
  read -r local insResponse
  case "$insResponse" in
    "" | [yY])
      echo "Starting install..."
      ;;
    [nN])
      echo "Aborting..."
      exit 1
      ;;
    *)
      echo "Invalid option, try again"
      installHyprEcosystem
      ;;
  esac

  # Continue install
  sudo pacman -S --needed --noconfirm "${coreDesktopUtils}"
  trap installError ERR
}

installAurApplications() {
  echo "Installing the following packages:"

  # Verify
  printf '%s\n' "${aurApplications}"
  echo "Continue? [Y/n]: "
  read -r local insResponse
  case "$insResponse" in
    "" | [yY])
      echo "Starting install..."
      ;;
    [nN])
      echo "Aborting..."
      exit 1
      ;;
    *)
      echo "Invalid option, try again"
      installHyprEcosystem
      ;;
  esac

  # Continue install
  yay -S --needed --answerclean None --answerdiff None --noconfirm "${aurApplications}"
  trap installError ERR
}

installError() {
  echo "Package installation failed.  (C)ontinue, (R)etry, (A)bort?: "
  read -r local errResponse
  case "$errResponse" in
    c | C)
      echo "Continuing to install..."
      installHyprEcosystem
      ;;
    r | R)
      echo "Retrying update..."
      updateSystem
      ;;
    a | A)
      echo "Aborting..."
      exit 1
      ;;
    *)
      echo "Invalid option entered, please enter a valid option"
      installError
      ;;
  esac
}

echo "Starting full Hyprland desktop install..."
updateSystem
installHyprEcosystem
installCoreDesktopUtils
installYay
installAurApplications
echo "Hyprland Desktop install is complete.  Goodbye!"
