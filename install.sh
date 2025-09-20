#!/usr/bin/env bash

# Make sure this is running on Nobara
echo "This is a custom script for use in Nobara Linux 42.  I cannot garuntee it will work in other distros."

while true; do
	read -rp "Are you sure that you want to continue? [y/n]" yn
	case $yn in
		[Yy]* ) break;;
		[Nn]* ) exit 1;;
		* ) echo "Please answer Y for Yes or N for No";;
	esac
done

# Add needed COPRs
sudo dnf copr enable lihaohong/yazi -y
sudo dnf copr enable scottames/ghostty -y

# Install cli tools and packages
dnfInstall=(
	fzf
	speedtest-cli
	tealdeer
	fastfetch
	bat
	trash-cli
	ripgrep
 	zoxide
	neovim
 	du-dust
  	zsh
   	stow
	lsd
 	node
  	ghostty
   	yazi
)

sudo dnf install -y "${dnfInstall[@]}"

# Install Noto Nerdfont
curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Noto.zip --output ~/Downloads/Noto.zip
unzip ~/Downloads/Noto.zip -d ~/Downloads/Nerd-Noto/
sudo mkdir /usr/share/fonts/nerds-noto/
sudo mv ~/Downloads/Nerd-Noto/*.ttf /usr/share/fonts/nerds-noto/

rm -vf ~/Downloads/Noto.zip
rm -rvf ~/Downloads/Nerd-Noto/

# Refresh Font Cache
fc-cache -fv
fc-list | rg "NerdFont"

# Check if the font installed
while true; do
	read -rp "Did the font install? [y/n]" ans
	case $ans in
		[Yy]* ) break;;
		[Nn]* ) exit 2;;
		* ) echo "Please answer Y/y for Yes or N/n for No";;
	esac
done

# Chnage logout timer
sudo sed -i.bak 's/property real timeout: *[0-9]\+/property real timeout: 5/' /usr/share/plasma/look-and-feel/org.kde.breeze.desktop/contents/logout/Logout.qml

# Install rmtrash
git clone https://github.com/PhrozenByte/rmtrash ~/Downloads/rmtrash/
sudo mv ~/Downloads/rmtrash/* /usr/local/bin/
rm -rf ~/Downloads/rmtrash/

# Download Catppuccin Theme
git clone https://github.com/catppuccin/konsole.git ~/Downloads/catppuccin/
sudo mkdir -p ~/.local/share/konsole/
sudo mv ~/Downloads/catppuccin/themes/catppuccin-mocha.colorscheme ~/.local/share/konsole/
rm -rf ~/Downloads/catppuccin/

# Final NVChad Install
git clone https://github.com/NvChad/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

# Ask tealdeer update
while true; do
	read -rp "Ready for tldr --update? [y/n]" ans
	case $ans in
		[Yy]* ) break;;
		[Nn]* ) exit 2;;
		* ) echo "Please answer Y/y for Yes or N/n for No";;
	esac
done

# Quick tealdeer update
tldr --update

# We did it
echo "All is well, please open up nvim and run :MasonInstallAll"

# Ask before stowing
while true; do
	read -rp "Stow? [y/n]" ans
	case $ans in
		[Yy]* ) break;;
		[Nn]* ) exit 2;;
		* ) echo "Please answer Y/y for Yes or N/n for No";;
	esac
done

# Clone my dotfiles
rm ~/.config/konsolerc
cd ~/.dotfiles
stow .
cd ~

# Ask uninstall
while true; do
	read -rp "Unisntall? [y/n]" ans
	case $ans in
		[Yy]* ) break;;
		[Nn]* ) exit 2;;
		* ) echo "Please answer Y/y for Yes or N/n for No";;
	esac
done

# Uninstall stuff I dont want
dnfRemove=(
	brave-browser
	starship
)

sudo dnf remove -y "${dnfRemove[@]}"
