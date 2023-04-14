# Install chocolatey

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

###############################################################################
# install Neovim
###############################################################################

choco install neovim

# Add neovim to path 
# C:\tools\neowim\nvim-win64\bin # This may already be done by choco

# Clone my dotfiles

###############################################################################
# Dotfiles
###############################################################################

git clone https://github.com/IainMcl/dotfiles.git $HOME

###############################################################################
# Neovim
###############################################################################

# Remove any current nvim configurations
Remove-Item -Path $HOME\AppData\Local\nvim -Recurse -Force

# create symlink to neovimrc
cmd /c mklink /J $HOME\AppData\Local\nvim $HOME\dotfiles\nvim\

# Install packer for neovim
git clone https://github.com/wbthomason/packer.nvim "$env:LOCALAPPDATA\nvim-data\site\pack\packer\start\packer.nvim"

###############################################################################
# Windows Terminal
###############################################################################

# To install fonts for CaskydiaCove 
# https://www.nerdfonts.com/font-downloads
# https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/CascadiaCode.zip
# Copy the windows mono regular file to C:\Windows\Fonts\

# Create symlink for windows terminal settings

# Define the source and destination paths
$dotfilesPath = "$HOME\dotfiles"
$settingsJsonPath = "$dotfilesPath\Powershell\WindowsTerminal\settings.json"
$windowsTerminalSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"

# Remove the existing settings.json file (if it exists)
Remove-Item "$windowsTerminalSettingsPath\settings.json" -Force -ErrorAction SilentlyContinue

# Create a symbolic link to the dotfiles/settings.json file
New-Item -ItemType SymbolicLink -Path "$windowsTerminalSettingsPath\settings.json" -Target $settingsJsonPath

###############################################################################
# Powershell
###############################################################################
# Create a symlink for Microsoft.PowerShell_profile.ps1
$powershellProfilePath = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
$dotfilesPowershellProfilePath = "$dotfilesPath\Powershell\Microsoft.PowerShell_profile.ps1"
if (Test-Path $powershellProfilePath) {
    Remove-Item $powershellProfilePath
}
New-Item -ItemType SymbolicLink -Path $powershellProfilePath -Target $dotfilesPowershellProfilePath

# Install Oh-My-Posh for windows terminal
winget install JanDeDobbeleer.OhMyPosh -s winget

# Install  New Terminal Icons for PowerShell
Install-Module -Name Terminal-Icons -Repository PSGallery
