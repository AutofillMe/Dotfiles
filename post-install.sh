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

# plugins/init.lua ------------------------------------------------------------------------------------------------
# clean plugins/init.lua and enable format on save
sed -i '/-- event/c\    event = { "BufWritePre", "BufNewFile" },' ${user_home}/.config/nvim/lua/plugins/init.lua
sed -i '/-- test/d' ${user_home}/.config/nvim/lua/plugins/init.lua
sed -i '/-- { import/d' ${user_home}/.config/nvim/lua/plugins/init.lua
sed -i '/-- These/d' ${user_home}/.config/nvim/lua/plugins/init.lua

# Add todo-comments
sed -i '0,/{/s|{|{\
  {\
    "folke/todo-comments.nvim",\
    event = "VimEnter",\
    dependencies = { "nvim-lua/plenary.nvim" },\
    opts = { signs = false }\
  },|' ${user_home}/.config/nvim/lua/plugins/init.lua
  
# Add live-server
sed -i '0,/{/s|{|{\
    {\
        "barrettruth/live-server.nvim",\
        cmd = { "LiveServer", "LiveServerStart", "LiveServerStop", "LiveServerToggle" },\
    },|' ${user_home}/.config/nvim/lua/plugins/init.lua

# Add tree-sitter context
sed -i '0,/{/s|{|{\
    {\
        "nvim-treesitter/nvim-treesitter-context",\
        event = "BufRead",\
        config = function()\
            require("treesitter-context").setup {\
                enable = true,\
                max_lines = 5,\
                mode = "cursor",\
            }\
        end,\
    },|' ${user_home}/.config/nvim/lua/plugins/init.lua

# initialize whichkey to show on first space bar press
sed -i '0,/{/s|{|{\
  {\
        "folke/which-key.nvim",\
        event = "VeryLazy",\
        opts = function()\
            dofile(vim.g.base46_cache .. "whichkey")\
            return {}\
        end,\
    },|' ${user_home}/.config/nvim/lua/plugins/init.lua

# enable treesitter and add python, c, cpp
sed -i 's/-- //' ${user_home}/.config/nvim/lua/plugins/init.lua
sed -i 's/"html", "css"/&, "c", "cpp", "python"/' ${user_home}/.config/nvim/lua/plugins/init.lua

# other nvim files -------------------------------------------------------------------------------------
sed -i 's/-- //' ${user_home}/.config/nvim/lua/configs/conform.lua
sed -i '/html = { "prettier" },/a\
        python = { "ruff-format" },\
        c = { "clang-format" },\
        cpp = { "clang-format" },\
        sh = { "beautysh" },\
        json = { "jq" },\
        jsonc = { "jq" },' ${user_home}/.config/nvim/lua/configs/conform.lua
sed -i 's/"html", "cssls"/&, "pyrefly", "clangd"/' ${user_home}/.config/nvim/lua/configs/lspconfig.lua
sed -i 's/onedark/catppuccin/' ${user_home}/.config/nvim/lua/chadrc.lua

# npm should be installed by now...need to double check later
sudo npm install -g tree-sitter-cli

# Remove bash files
sudo rm -f ${user_home}/.bash*

# Exit and reboot
echo "Rebooting in 5 seconds..."
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
sleep 1
reboot
