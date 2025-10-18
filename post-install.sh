#!/usr/bin/env bash

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

trap "echo 'Script interrupted. Exiting...'; exit 1" INT

# Make sure the script is not being run as root, as it may have unintended consequences
if [ "$EUID" -eq 0 ]; then
    echo "Do not run this script as root or with sudo, as it may have unintended consequences."
    echo "Run it as a normal user instead."
    exit 1
fi

# Set user home directory and validates by printing to terminal
user_home=$HOME
echo "Running as user: $USER"
echo "Home directory: $user_home"
source "$user_home/.dotfiles/run.sh"
checkpoint "Is the user and home directory correct?"

# Make sure this is running on Nobara
echo "Run this in Ghostty after running install.sh."

checkpoint "Are you sure that you want to continue?"

# Change shell
chsh -s /usr/bin/zsh

# Fix NVChad configs and add python and c lsp and format
sed -i '/-- event/c\    event = { "BufWritePre" },' $user_home/.config/nvim/lua/plugins/init.lua
sed -i $'0,/{/s|{|{\\\n  {\\\n    "folke/todo-comments.nvim",\\\n    event = "VimEnter",\\\n    dependencies = { "nvim-lua/plenary.nvim" },\\\n    opts = { signs = false }\n  },|' $user_home/.config/nvim/lua/plugins/init.lua
sed -i 's/-- //' $user_home/.config/nvim/lua/configs/conform.lua
sed -i '/html = { "prettier" },/a\        python = { "isort", "black" },\n\        c = { "clang-format" },\n\        cpp = { "clang-format" },\n\        sh = { "shfmt" },' $user_home/.config/nvim/lua/configs/conform.lua
sed -i 's/"html", "cssls"/&, "pyright", "clangd"/' $user_home/.config/nvim/lua/configs/lspconfig.lua
sed -i 's/onedark/catppuccin/' $user_home/.config/nvim/lua/chadrc.lua

# Remove bash files
rm -f $user_home/.bash*
rm $user_home/.config/starship.toml

# Exit and reboot
echo "Rebooting in 5 seconds..."
sleep 1
echo "5..."
sleep 1
echo "4..."
sleep 1
echo "3..."
sleep 1
echo "2..."
sleep 1
echo "1..."
sleep 1
echo "Rebooting..."
sleep 2
reboot
