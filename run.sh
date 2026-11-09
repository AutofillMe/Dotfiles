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
    neovim_prep
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
        python3.15
    )

    sudo dnf install -y "${dnfInstall[@]}"
    echo "Done"
}

nerd_font_install() {
    echo "Installing Nerd Font..."
    # Install Noto Nerdfont
    curl -fL --retry 3 https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip -o "$user_home"/Downloads/font.zip
    echo "Unzipping file..."
    unzip -q "$user_home"/Downloads/font.zip -d "$user_home"/Downloads/font/
    sudo mkdir -p /usr/share/fonts/nerd-font/
    sudo mv "$user_home"/Downloads/font/*.ttf /usr/share/fonts/nerd-font/

    rm -vf "$user_home"/Downloads/font.zip
    rm -rvf "$user_home"/Downloads/font/
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
    sudo sed -i.bak 's/property real timeout: *[0-9]\+/property real timeout: 5/' /usr/share/plasma/shells/org.kde.plasma.desktop/contents/logout/Logout.qml

    # Make sure the file is as expected
    if ! grep -q "property real timeout: 5" /usr/share/plasma/shells/org.kde.plasma.desktop/contents/logout/Logout.qml; then
        echo "Warning: logout delay change may not have applied."
    fi

    echo "Done."
}

neovim_prep() {
    echo "Prepping Neovim install..."
    # NVChad Starter Install
    mkdir -p ~/.config/nvim/
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

    # Change shell
    chsh -s /usr/bin/zsh
    
    # npm should be installed by now...need to double check later
    # sudo npm install -g tree-sitter-cli

    # Exit and reboot
    echo "Rebooting in 3 seconds..."
    echo "3..."
    sleep 1
    echo "2..."
    sleep 1
    echo "1..."
    sleep 1
    echo "Rebooting..."
    sleep 1
    reboot
}

post_install() {
    # install rust + tree-sitter-cli
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -sSf | sh -s -- -y
    cargo install --locked tree-sitter-cli
    cargo install --locked dysk

    # Remove bash files
    rm ${user_home}/.bash*

    # Remove zcompdump
    rm ${user_home}/.zcompdump

    # Move .gtkrc-2.0
    mv ${user_home}/.gtkrc-2.0 "$XDG_CONFIG_HOME"/gtk-2.0/gtkrc/.gtkrc-2.0
}
