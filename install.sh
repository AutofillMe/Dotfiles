#!/usr/bin/env bash

checkpoint() {
	while true; do
		read -rp "$1 [y/n]" ans
		case $ans in
			[Yy]* ) break;;
			[Nn]* ) exit 1;;
			* ) echo "Please answer Y for Yes or N for No";;
		esac
	done
}

# Make sure this is running on Nobara
echo "This is a custom script for use in Nobara Linux 42.  I cannot garuntee it will work in other distros."

checkpoint "Are you sure that you want to continue?"

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

# Wait for installs
checkpoint "Install done?"

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
checkpoint "Did the font install?"

# Chnage logout timer
sudo sed -i.bak 's/property real timeout: *[0-9]\+/property real timeout: 5/' /usr/share/plasma/look-and-feel/org.kde.breeze.desktop/contents/logout/Logout.qml

# Install rmtrash
git clone https://github.com/PhrozenByte/rmtrash ~/Downloads/rmtrash/
sudo mv ~/Downloads/rmtrash/* /usr/local/bin/
rm -rf ~/Downloads/rmtrash/

# Final NVChad Install
git clone https://github.com/NvChad/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

# Ask tealdeer update
checkpoint "Ready for tldr --update?"

# Quick tealdeer update
tldr --update

# We did it
echo "All is well, please open up nvim and run :MasonInstallAll"

# Ask before stowing
checkpoint "Stow?"

# Clone my dotfiles
rm -f ~/.config/konsolerc
cd ~/.dotfiles
stow .
cd ~

# Ask uninstall
checkpoint "Swtich Shell and Uninstall?"

# Change shell
chsh -s $(which zsh)

# Uninstall stuff I dont want
dnfRemove=(
	brave-browser
	starship
)

sudo dnf remove -y "${dnfRemove[@]}"
