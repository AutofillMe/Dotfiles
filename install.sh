#!/usr/bin/env bash

trap "echo 'Script interrupted. Exiting...'; exit 1" INT

username="${SUDO_USER:-$(whoami)}"

# Set up logging
log_file="/home/$username/.dotfile-script.log"
exec > >(tee "$log_file") 2>&1

checkpoint() {
	while true; do
		read -rp "$1 [y/n]: " ans
		case $ans in
			[Yy]* ) break;;
			[Nn]* ) exit 1;;
			* ) echo "Please answer Y for Yes or N for No";;
		esac
	done
}

valid_input_checkpoint() {
	local tasks=("$@")
    # Validate user input to be a number and between 0 and 12
    local index
    for index in "${tasks[@]}"; do
        if ! [[ "$index" =~ ^[0-9]+$ ]] || (( index < 0 || index > 12 )); then
            echo "Invalid task number: $index"
            exit 1
        fi
    done
}

# MAIN SCRIPT -----------------------------------------------------------------------------------------------
# Make sure this is running on Nobara
echo "This is a custom script for use in Nobara Linux 42.  I cannot guarantee it will work in other distros."

checkpoint "Are you sure that you want to continue?"

all_tasks() {
	# All tasks placeholder
	echo "Running all tasks..."
    sleep 2
	copr_install
	dnf_install
	nerd_font_install
	font_check
	logout_delay
	rmtrash_install
	btop_theme_install
	NVChad_install
	tealdeer_update
	run_stow
	dnf_uninstall
	cleanup
}

copr_install() {
	echo "Adding needed COPR repos..."
    # Add needed COPRs
    sudo dnf copr enable lihaohong/yazi -y
    sudo dnf copr enable scottames/ghostty -y
	echo "Done."
}

dnf_install() {
	echo "Installing Packages..."
    # Install cli tools and packages
    dnfInstall=(
        fzf
        speedtest-cli
        tealdeer
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
}

nerd_font_install() {
	echo "Installing Nerd Font..."
    # Install Noto Nerdfont
    curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Noto.zip -o /home/$username/Downloads/Noto.zip
	echo "Unzipping file..."
    unzip -q /home/$username/Downloads/Noto.zip -d /home/$username/Downloads/Nerd-Noto/
    sudo mkdir /usr/share/fonts/nerds-noto/
    sudo mv /home/$username/Downloads/Nerd-Noto/*.ttf /usr/share/fonts/nerds-noto/

    rm -vf /home/$username/Downloads/Noto.zip
    rm -rvf /home/$username/Downloads/Nerd-Noto/
	echo "Done."
}

font_check() {
	echo "Performing Font Update and Check..."
    # Refresh Font Cache
    fc-cache -f
    if command -v rg &>/dev/null; then
	    fc-list | rg "NerdFont" --color=always | tail
	else
	    fc-list | grep "NerdFont" | tail
	fi

    # Check if the font installed
    checkpoint "Do you see NerdFont more than twice?"
	echo # Added to add newline for log file clarity
	echo "Done."
}

logout_delay() {
	echo "Setting Logout Delay..."
    # Chnage logout timer from 30 seconds to 5 seconds
    sudo sed -i.bak 's/property real timeout: *[0-9]\+/property real timeout: 5/' /usr/share/plasma/look-and-feel/org.kde.breeze.desktop/contents/logout/Logout.qml
	echo "Done."
}

rmtrash_install() {
	echo "Installing rmtrash..."
    # Install rmtrash
    git clone https://github.com/PhrozenByte/rmtrash /home/$username/Downloads/rmtrash/
    sudo mv /home/$username/Downloads/rmtrash/* /usr/local/bin/
    rm -rf /home/$username/Downloads/rmtrash/
	echo "Done."
}

btop_theme_install() {
	echo "Installing btop Theme..."
    # Install btop theme
    curl -L https://github.com/catppuccin/btop/releases/latest/download/themes.tar.gz -o /home/$username/Downloads/btop.tar.gz
    mkdir /home/$username/Downloads/btop
    tar -xzf /home/$username/Downloads/btop.tar.gz -C /home/$username/Downloads/btop
    mkdir -p /home/$username/.config/btop/themes
    mv /home/$username/Downloads/btop/themes/catppuccin_mocha.theme /home/$username/.config/btop/themes/catppuccin_mocha.theme
    rm -rf /home/$username/Downloads/btop*
	echo "Done."
}

NVChad_install() {
	echo "Install NVChad"
    # NVChad Starter Install
    git clone https://github.com/NvChad/starter /home/$username/.config/nvim
    rm -rf /home/$username/.config/nvim/.git
	# Add in custom maps and opts
	echo 'require("crilp")' >> /home/$username/.config/nvim/init.lua
	mkdir -p /home/$username/.config/nvim/lua/crilp
	echo "Done."
}

tealdeer_update() {
	echo "Running tealdeer init..."

    # Quick tealdeer update
    tldr --update
	echo "Done."
}

run_stow() {
    # Ask before stowing
    checkpoint "Ready for GNU Stow?"
	echo # Added to add newline for log file clarity

    # Clone my dotfiles
    sudo rm -f /home/$username/.config/konsolerc
    cd /home/$username/.dotfiles
    stow .
    cd /home/$username
	echo "Done."
}

dnf_uninstall() {
	echo "Uninstalling Junk..."
    # Uninstall programs I dont want or have alternatives to
    dnfRemove=(
        brave-browser
        starship
        neochat
        kate
        spectacle
    )

    sudo dnf remove -y "${dnfRemove[@]}"
}

cleanup() {
	echo "Running final cleanup..."
    # Final cleanup
    rm -rf /home/$username/.dotfiles/.git
	echo "Please close then reopen konsole, then run nvim and change the defaults."
}

# Prompt which task checkpoint they would like to run
echo "Which tasks would you like to execute?"
echo "Provide the input as a spaced list of numbers."
echo "0) All Tasks"
echo "1) copr_install"
echo "2) dnf_install"
echo "3) nerd_font_install"
echo "4) font_check"
echo "5) logout_delay"
echo "6) rmtrash_install"
echo "7) btop_theme_install"
echo "8) NVChad_install"
echo "9) tealdeer_update"
echo "10) run_stow"
echo "11) dnf_uninstall"
echo "12) cleanup"
read -p "Enter your choice: " -a selected_tasks

# Validate input: check if it's a number between 0 and 12
valid_input_checkpoint "${selected_tasks[@]}"

task_functions=(
	all_tasks
	copr_install
	dnf_install
	nerd_font_install
	font_check
	logout_delay
	rmtrash_install
	btop_theme_install
	NVChad_install
	tealdeer_update
	run_stow
	dnf_uninstall
	cleanup
)

# Run tasks
for index in "${selected_tasks[@]}"; do
	"${task_functions[$index]}"
done
