#!/usr/bin/env bash

username="${SUDO_USER:-$(whoami)}"

set -e

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
	mpv
	btop
	flameshot
)

sudo dnf install -y "${dnfInstall[@]}"

# Install Noto Nerdfont
FILE="/home/$username/Downloads/Noto.zip"

if [[ -f "$FILE" ]]; then
    echo "File already exists: $FILE. Skipping download..."
else
    echo "Downloading..."
    curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Noto.zip -o "$FILE"
fi
unzip /home/$username/Downloads/Noto.zip -d /home/$username/Downloads/Nerd-Noto/
sudo mkdir /usr/share/fonts/nerds-noto/
sudo mv /home/$username/Downloads/Nerd-Noto/*.ttf /usr/share/fonts/nerds-noto/

rm -vf /home/$username/Downloads/Noto.zip
rm -rvf /home/$username/Downloads/Nerd-Noto/

# Refresh Font Cache
fc-cache -fv
fc-list | rg "NerdFont"

# Check if the font installed
checkpoint "Did the font install?"

# Chnage logout timer
sudo sed -i.bak 's/property real timeout: *[0-9]\+/property real timeout: 5/' /usr/share/plasma/look-and-feel/org.kde.breeze.desktop/contents/logout/Logout.qml

# Install rmtrash
git clone https://github.com/PhrozenByte/rmtrash /home/$username/Downloads/rmtrash/
sudo mv /home/$username/Downloads/rmtrash/* /usr/local/bin/
rm -rf /home/$username/Downloads/rmtrash/

# Install btop theme
curl -L https://github.com/catppuccin/btop/releases/latest/download/themes.tar.gz -o /home/$username/Downloads/btop.tar.gz
tar -xzf /home/$username/Downloads/btop.tar.gz -C /home/$username/Downloads/btop
mkdir ~/.config/btop/themes
mv /home/$username/Downloads/btop/themes/catppuccin_mocha.theme ~/.config/btop/themes/catppuccin_mocha.theme
rm -rf /home/$username/Downloads/btop
rm /home/$username/Downloads/btop.tar.gz

# Final NVChad Install
git clone https://github.com/NvChad/starter /home/$username/.config/nvim
rm -rf /home/$username/.config/nvim/.git

# Ask tealdeer update
checkpoint "Ready for tldr --update?"

# Quick tealdeer update
tldr --update

# We did it
echo "All is well, please open up nvim and run :MasonInstallAll"

# Ask before stowing
checkpoint "Stow?"

# Clone my dotfiles
rm -f /home/$username/.config/konsolerc
cd /home/$username/.dotfiles
stow .
cd /home/$username

# Ask uninstall
checkpoint "Swtich Shell and Uninstall?"

# Change shell
chsh -s /usr/bin/zsh

# Uninstall stuff I dont want
dnfRemove=(
	brave-browser
	starship
	neochat
	kate
	spectacle
)

sudo dnf remove -y "${dnfRemove[@]}"

rm -rf /home/$username/.dotfiles/.git
