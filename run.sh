#!/usr/bin/env bash

#----------------------------------------------------------
# Stores functions used in install.sh
#----------------------------------------------------------

confirm() {
    read -rp "${1:-Are you sure? [y/N]} " ans
    [[ "$ans" =~ ^([yY][eE][sS]|[yY])$ ]]
}

checkpoint() {
    while true; do
        read -rp "$1 [y/n]: " ans
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
        lolcat
        figlet
        git-delta
        fd-find
        tokei
        vlc
    )

    sudo dnf install -y "${dnfInstall[@]}"
}

nerd_font_install() {
    echo "Installing Nerd Font..."
    # Install Noto Nerdfont
    curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Noto.zip -o "$user_home"/Downloads/Noto.zip
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

btop_theme_install() {
    echo "Installing btop Theme..."
    # Install btop theme
    curl -L https://github.com/catppuccin/btop/releases/latest/download/themes.tar.gz -o "$user_home"/Downloads/btop.tar.gz
    mkdir "$user_home"/Downloads/btop
    tar -xzf "$user_home"/Downloads/btop.tar.gz -C "$user_home"/Downloads/btop
    mkdir -p "$user_home"/.config/btop/themes
    mv "$user_home"/Downloads/btop/themes/catppuccin_mocha.theme "$user_home"/.config/btop/themes/CatppuccinMocha.theme
    rm -rf "$user_home"/Downloads/btop*
    echo "Done."
}

NVChad_install() {
    echo "Installing NVChad"
    # NVChad Starter Install
    git clone https://github.com/NvChad/starter "$user_home"/.config/nvim
    rm -rf "$user_home"/.config/nvim/.git
    # Add in custom maps and opts
    echo 'require("crilp")' >>"$user_home"/.config/nvim/init.lua
    mkdir -p "$user_home"/.config/nvim/lua/crilp
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
    sudo rm -f "$user_home"/.config/konsolerc
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

    sudo dnf remove -y "${dnfRemove[@]}"
}

cleanup() {
    echo "Running final cleanup..."

    # Install flatpaks to replace removed packages
    flatpak install --user app.zen_browser.zen -y
    flatpak install --user io.missioncenter.MissionCenter -y

    # Select new defaults
    kcmshell6 componentchooser

    # Final cleanup
    echo "Rebooting, then open neovim and run :MasonInstallAll."
}
