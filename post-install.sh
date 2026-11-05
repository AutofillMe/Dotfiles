#!/usr/bin/env bash

checkpoint() {
    while true; do
        read -rp "$1 [y/n]: " ans
        case ${ans} in
        [Yy]*) break ;;
        [Nn]*) exit 1 ;;
        *) echo "Please answer Y for Yes or N for No" ;;
        esac
    done
}

trap "echo 'Script interrupted. Exiting...'; exit 1" INT

# Make sure the script is not being run as root, as it may have unintended consequences
if [ "${EUID}" -eq 0 ]; then
    echo "Do not run this script as root or with sudo, as it may have unintended consequences." >&2
    echo "Run it as a normal user instead." >&2
    exit 1
fi

# Set user home directory and validates by printing to terminal
user_home=$HOME
echo "Running as user: $USER"
echo "Home directory: ${user_home}"
checkpoint "Is the user and home directory correct?"

# Make sure this is running on Nobara
echo "Run this in Ghostty after running install.sh."

checkpoint "Are you sure that you want to continue?"

# Change shell
chsh -s /usr/bin/zsh

# npm should be installed by now...need to double check later
sudo npm install -g tree-sitter-cli

# Remove bash files
sudo rm -f ${user_home}/.bash*

echo "Please exit and reopen Ghostty"
exit 0
