#!/usr/bin/env bash

trap "echo 'Script interrupted. Exiting...'; exit 1" INT

# Make sure the script is not being run as root, as it may have unintended consequences
if [ "$EUID" -eq 0 ]; then
    echo "Do not run this script as root or with sudo."
    echo "Run it as a normal user instead."
    exit 1
fi

# Set user home directory and validates by printing to terminal
user_home=$HOME
echo "Running as user: $USER"
echo "Home directory: $user_home"


# Just in case it doesnt exist (It should)
mkdir -p "$user_home/Downloads"

# Set up logging
log_file="$user_home/.dotfile-script.log"
exec > >(tee "$log_file") 2>&1

checkpoint() {
	while true; do
		read -rp "$1 [y/n]: " ans
		case $ans in
			[Yy]* ) break ;;
			[Nn]* ) exit 1 ;;
			* ) echo "Please answer Y for Yes or N for No" ;;
		esac
	done
}

valid_input_checkpoint() {
	local tasks=("$@")

	# Check if user selected any tasks at all
	if [ ${#tasks[@]} -eq 0 ]; then
		echo "No tasks selected. Exiting..."
		exit 1
	fi
	
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

echo

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
    curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Noto.zip -o "$user_home/Downloads/Noto.zip"
	echo "Unzipping file..."
    unzip -q "$user_home/Downloads/Noto.zip" -d "$user_home/Downloads/Nerd-Noto/"
    sudo mkdir -p /usr/share/fonts/nerds-noto/
    sudo mv "$user_home/Downloads/Nerd-Noto/*.ttf /usr/share/fonts/nerds-noto/"

    rm -vf "$user_home/Downloads/Noto.zip"
    rm -rvf "$user_home/Downloads/Nerd-Noto/"
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
    # Change logout timer from 30 seconds to 5 seconds
    sudo sed -i.bak 's/property real timeout: *[0-9]\+/property real timeout: 5/' /usr/share/plasma/look-and-feel/org.kde.breeze.desktop/contents/logout/Logout.qml
	
	# Make sure the file is as expected
	if ! grep -q "property real timeout: 5" /usr/share/plasma/look-and-feel/org.kde.breeze.desktop/contents/logout/Logout.qml; then
   		echo "Warning: logout delay change may not have applied."
	fi
	
	echo "Done."
}

rmtrash_install() {
	echo "Installing rmtrash..."
    # Install rmtrash
    git clone https://github.com/PhrozenByte/rmtrash "$user_home/Downloads/rmtrash/"
    sudo install -m 755 "$user_home/Downloads/rmtrash/rmtrash" /usr/local/bin/
    rm -rf "$user_home/Downloads/rmtrash/"
	echo "Done."
}

btop_theme_install() {
	echo "Installing btop Theme..."
    # Install btop theme
    curl -L https://github.com/catppuccin/btop/releases/latest/download/themes.tar.gz -o "$user_home/Downloads/btop.tar.gz"
    mkdir "$user_home/Downloads/btop"
    tar -xzf "$user_home/Downloads/btop.tar.gz" -C "$user_home/Downloads/btop"
    mkdir -p $user_home/.config/btop/themes
    mv "$user_home/Downloads/btop/themes/catppuccin_mocha.theme" "$user_home/.config/btop/themes/catppuccin_mocha.theme"
    rm -rf "$user_home/Downloads/btop*"
	echo "Done."
}

NVChad_install() {
	echo "Install NVChad"
    # NVChad Starter Install
    git clone https://github.com/NvChad/starter "$user_home/.config/nvim"
    rm -rf "$user_home/.config/nvim/.git"
	# Add in custom maps and opts
	echo 'require("crilp")' >> "$user_home/.config/nvim/init.lua"
	mkdir -p "$user_home/.config/nvim/lua/crilp"
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
    sudo rm -f "$user_home/.config/konsolerc"
    cd "$user_home/.dotfiles"
    stow .
    cd "$user_home"
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
		plasma-systemmonitor
    )

    sudo dnf remove -y "${dnfRemove[@]}"
}

cleanup() {
	echo "Running final cleanup..."
    # Final cleanup
    rm -rf "$user_home/.dotfiles/.git"
	echo "Please close then reopen your terminal, then run nvim and change the defaults."
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

# If user selects 0 and other tasks, changes selected task to just 0 to reduce redundancy
if [[ " ${selected_tasks[*]} " =~ " 0 " ]]; then
    selected_tasks=(0)  # only run all_tasks
fi

# Run tasks
for index in "${selected_tasks[@]}"; do
	"${task_functions[$index]}"
done
