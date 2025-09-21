#!/usr/bin/env bash

username="${SUDO_USER:-$(whoami)}"

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

# Make sure this is running on Nobara
echo "This is a custom script for use in Nobara Linux 42.  I cannot garuntee it will work in other distros."

checkpoint "Are you sure that you want to continue?"

all_tasks() {
	# All tasks placeholder
	echo "Running all tasks..."
	sleep 2
}

copr_install() {
    # Add needed COPRs
    sudo dnf copr enable lihaohong/yazi -y
    sudo dnf copr enable scottames/ghostty -y
}

dnf_install() {
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
    # Install Noto Nerdfont
    curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Noto.zip -o /home/$username/Downloads/Noto.zip
    unzip /home/$username/Downloads/Noto.zip -d /home/$username/Downloads/Nerd-Noto/
    sudo mkdir /usr/share/fonts/nerds-noto/
    sudo mv /home/$username/Downloads/Nerd-Noto/*.ttf /usr/share/fonts/nerds-noto/

    rm -vf /home/$username/Downloads/Noto.zip
    rm -rvf /home/$username/Downloads/Nerd-Noto/
}

font_check() {
    # Refresh Font Cache
    fc-cache -fv
    fc-list | rg "NerdFont"

    # Check if the font installed
    checkpoint "Do you see NerdFont more than twice?"
}

logout_delay() {
    # Chnage logout timer from 30 seconds to 5 seconds
    sudo sed -i.bak 's/property real timeout: *[0-9]\+/property real timeout: 5/' /usr/share/plasma/look-and-feel/org.kde.breeze.desktop/contents/logout/Logout.qml
}

rmtrash_install() {
    # Install rmtrash
    git clone https://github.com/PhrozenByte/rmtrash /home/$username/Downloads/rmtrash/
    sudo mv /home/$username/Downloads/rmtrash/* /usr/local/bin/
    rm -rf /home/$username/Downloads/rmtrash/
}

btop_theme_install() {
    # Install btop theme
    curl -L https://github.com/catppuccin/btop/releases/latest/download/themes.tar.gz -o /home/$username/Downloads/btop.tar.gz
    mkdir /home/$username/Downloads/btop
    tar -xzf /home/$username/Downloads/btop.tar.gz -C /home/$username/Downloads/btop
    mkdir -p /home/$username/.config/btop/themes
    mv /home/$username/Downloads/btop/themes/catppuccin_mocha.theme /home/$username/.config/btop/themes/catppuccin_mocha.theme
    rm -rf /home/$username/Downloads/btop*
}

NVChad_install() {
    # Final NVChad Install
    git clone https://github.com/NvChad/starter /home/$username/.config/nvim
    rm -rf /home/$username/.config/nvim/.git
}

tealdeer_update() {
    # Ask tealdeer update
    checkpoint "Ready for tldr --update?"

    # Quick tealdeer update
    tldr --update
}

stow() {
    # Ask before stowing
    checkpoint "Ready for GNU Stow?"

    # Clone my dotfiles
    sudo rm -f /home/$username/.config/konsolerc
    cd /home/$username/.dotfiles
    stow .
    cd /home/$username
}

dnf_uninstall() {
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
    # Final cleanup
    rm -rf /home/$username/.dotfiles/.git
}

# Prompt which task checkpoint they would like to run
echo "Which task(s) would you like to run?"
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
echo "10) stow"
echo "11) dnf_uninstall"
echo "12) cleanup"
read -p "Enter your choice: " start

# Validate input: check if it's a number between 1 and 5
if ! [[ "$start" =~ ^[0-12]$ ]]; then
    echo "Invalid input: Please enter a number between 1 and 5, or 'all'."
    exit 0
fi

# Run tasks starting from selected number
for (( i=start; i<=12; i++ )); do
    case $i in
		0) all_tasks ;;
        1) copr_install ;;
        2) dnf_install ;;
        3) nerd_font_install ;;
        4) font_check ;;
        5) logout_delay ;;
        6) rmtrash_install ;;
        7) btop_theme_install ;;
        8) NVChad_install ;;
        9) tealdeer_update ;;
        10) stow ;;
        11) dnf_uninstall ;;
        12) cleanup ;;
    esac
done
