#!/usr/bin/env bash

script_version="1.0"

trap "echo 'Script interrupted. Exiting...'; exit 1" INT

for i in "$@"; do
    case $i in
        -v|--version ) echo "crilp's Nobara setup script ver. $script_version"; exit 0 ;;
        -h|--help ) echo "idk man"; exit 0 ;;
        * ) echo "Unknown option: $i"; exit 1 ;;
    esac
done

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
checkpoint "Is the user and home directory correct?"

# Source all functions
source "$user_home/.dotfiles/run.sh"

# Set up logging
log_dir="$user_home/.cache/script-logs"
mkdir -p "$log_dir"
# Keep only the last 5 log files
ls -t "$log_dir"/*.log 2>/dev/null | tail -n +6 | xargs -r rm --
# Make log file
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
log_file="$log_dir/run-$timestamp.log"
exec > >(tee >(awk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 >> "'"$log_file"'"; fflush(); }')) 2>&1

# MAIN SCRIPT -----------------------------------------------------------------------------------------------
# Make sure this is running on Nobara
echo "This is a custom script for use in Nobara Linux 42.  I cannot guarantee it will work in other distros."

checkpoint "Are you sure that you want to continue?"

echo

# Prompt which task checkpoint they would like to run
echo "Which tasks would you like to execute?"
echo "Provide the input as a spaced list of numbers or just type 0 for all tasks."
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

echo "Script completed.  Took $SECONDS seconds to complete."
