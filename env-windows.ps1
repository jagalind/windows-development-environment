#-------------------------------------------------------------------------------#
# This script installs all the stuff we need to develop things.                 #
# Run PowerShell with admin priveleges and this to allow script to run:         #
# `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass`                  #  
# Then type `env-windows`, and go make some coffee.                             #
#-------------------------------------------------------------------------------#

# Functions

function Update-Environment-Path
{
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") `
        + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# Package Managers

# Choco
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# Create PowerShell profile file before installing choco. 
if (-Not (Test-Path $profile -PathType Leaf))
{
    New-Item -Path $profile -ItemType "file" -Force
}

Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | iex
Update-Environment-Path

# Choco Core Extenstions
choco install chocolatey-core.extension

# Git
choco install git.install --params "/GitAndUnixToolsOnPath /NoAutoCrlf" --yes
choco install tortoisegit --yes
Update-Environment-Path
# git config --global alias.pom 'pull origin master'
# git config --global alias.last 'log -1 HEAD'
# git config --global alias.ls "log --pretty=format:'%C(yellow)%h %ad%Cred%d %Creset%s%Cblue [%cn]' --decorate --date=short"
# git config --global alias.ammend "commit -a --amend"
# git config --global alias.standup "log --since yesterday --author $(git config user.email) --pretty=short"
# git config --global alias.everything "! git pull && git submodule update --init --recursive"
# git config --global alias.aliases "config --get-regexp alias"
# Update-Environment-Path

# C/C++ Languages
choco install VisualStudio2015Community --yes --timeout 0 -package-parameters "--AdminFile .\tools_msvc2015AdminDeployment.xml"

# VS Code
choco install vscode --yes
choco install vscode-icons --yes
choco install vscode-gitlens --yes
Update-Environment-Path

code --install-extension huizhou.githd
code --install-extension ms-vscode.cpptools
code --install-extension ms-vscode.PowerShell

# VirtualBox
choco install virtualbox --yes

# File Management
choco install cmder --yes
choco install meld --yes
choco install 7zip.install --yes
choco install notepadplusplus.install --yes

# Media Viewers
choco install vlc --yes

# Browsers
choco install googlechrome --yes

# Misc
choco install sysinternals --yes
choco install adobereader --yes
choco install SkypeForBusinessBasic --yes
choco install teraterm --yes
choco install MobaXTerm --yes
# choco install slack --yes

# FTDI Drivers - Checksum Fails - Ignore for now
choco install ftdi-drivers --ignore-checksums --yes 

# MS Office 2018 - Stil pre-production
choco install --yes office2019-proplus --pre

Update-Environment-Path

Write-Output "Finished! Run `choco upgrade all` to get the latest software"
