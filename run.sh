#!/usr/bin/env bash

#----------------------------------------------------------
# Stores functions used in install.sh
#----------------------------------------------------------

confirm() {
    printf "%s" "${1:-Are you sure? [Y/N]} "
    read -r ans
    [[ "$ans" =~ ^([yY][eE][sS]|[yY])$ ]]
}

checkpoint() {
    while true; do
        printf "%s [y/n]: " "$1"
        read -r ans
        case $ans in
            [Yy]*) break ;;
            [Nn]*) exit 1 ;;
            *) echo "Please answer Y for Yes or N for No" ;;
        esac
    done
}

all_tasks() {
    # All tasks placeholder
    echo "Running all tasks..."
    sleep 2
    copr_install
    dnf_install
    nerd_font_install
    font_check
    logout_delay
    NVChad_install
    tealdeer_update
    run_stow
    dnf_uninstall
    cleanup
}

copr_install() {
    echo "Adding needed COPR repos..."
    # Add needed COPRs
    sudo dnf copr enable lihaohong/yazi -y >&3
    sudo dnf copr enable scottames/ghostty -y >&3
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
        lolcat
        figlet
        git-delta
        fd-find
        tokei
        vlc
    )

    sudo dnf install -y "${dnfInstall[@]}" >&3
}

nerd_font_install() {
    echo "Installing Nerd Font..."
    # Install Noto Nerdfont
    curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Noto.zip -o "$user_home"/Downloads/Noto.zip >&3
    echo "Unzipping file..."
    unzip -q "$user_home"/Downloads/Noto.zip -d "$user_home"/Downloads/Nerd-Noto/
    sudo mkdir -p /usr/share/fonts/nerds-noto/
    sudo mv "$user_home"/Downloads/Nerd-Noto/*.ttf /usr/share/fonts/nerds-noto/

    rm -vf "$user_home"/Downloads/Noto.zip
    rm -rvf "$user_home"/Downloads/Nerd-Noto/
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
        echo "Warning: logout delay change may not have applied." >&2
    fi

    echo "Done."
}

NVChad_install() {
    echo "Installing NVChad"
    # NVChad Starter Install
    if git clone --single-branch -q https://github.com/NvChad/starter "$user_home"/.config/nvim; then
        rm -rf "$user_home"/.config/nvim/.git
    else
        echo "Failed to clone $repo" >&2
        return 1
    fi
    # Add in custom maps and opts
    echo 'require("crilp")' >>"$user_home"/.config/nvim/init.lua
    mkdir -p "$user_home"/.config/nvim/lua/crilp
    echo "Done."
}

tealdeer_update() {
    echo "Running tealdeer init..."

    # Quick tealdeer update
    tldr --update >&3
    echo "Done."
}

run_stow() {
    # Ask before stowing
    checkpoint "Ready for GNU Stow?"
    echo # Added to add newline for log file clarity

    # Clone my dotfiles
    cd "$user_home"/.dotfiles
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

    sudo dnf remove -y "${dnfRemove[@]}" >&3
}

cleanup() {
    echo "Running final cleanup..."

    # Install flatpaks to replace removed packages
    flatpak install --user app.zen_browser.zen -y
    flatpak install --user io.missioncenter.MissionCenter -y

    # Select new defaults
    kcmshell6 componentchooser

    # Final cleanup
    echo "Please reboot, then open neovim and run :MasonInstallAll."
}
