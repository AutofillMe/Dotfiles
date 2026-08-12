#!/usr/bin/env bash

script_version="1.6"

validate_input() {
    local tasks=("$@")
    
    # Last arg is the index count, pop and assign to own var
    local max_index="${tasks[-1]}"
    tasks=("${tasks[@]:0:${#tasks[@]}-1}") # Re-index array

    # Check if user selected any tasks at all
    if [ ${#tasks[@]} -eq 0 ]; then
        echo "No tasks selected. Exiting..." >&2
        exit 1
    fi

    # Validate user input to be a number and between 0 and count
    local index
    for index in "${tasks[@]}"; do
        if ! [[ "$index" =~ ^[0-9]+$ ]] || (( index > max_index )); then
            echo "Invalid task number: $index" >&2
            exit 1
        fi
    done
}

show_help() {
    echo "Usage: install.sh"
    echo "            -h [--help]:"
    echo "                show help"
    echo "            -v [--version]:"
    echo "                show version"
}

trap "echo 'Script interrupted. Exiting...'; exit 1" INT

while getopts ":hv-:" opt; do
    case "${opt}" in
        h)
            show_help
            exit 0 ;;
        v)
            echo "crilp's Nobara setup script ver. $script_version"
            exit 0
            ;;
        -)
            case ${OPTARG} in
                help)
                    show_help
                    exit 0
                    ;;
                version)
                    echo "crilp's Nobara setup script ver. $script_version"
                    exit 0
                    ;;
                :)
                    echo "Missing argument for --$OPTARG" >&2
                    exit 1
                    ;;
                \?)
                    echo "Unknown option: --$OPTARG" >&2
                    exit 1
                    ;;
            esac ;;
        :)
            echo "Missing argument for -$OPTARG" >&2
            exit 1
            ;;
        \?)
            echo "Unknown option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

# Make sure the script is not being run as root, as it may have unintended consequences
if [ "$EUID" -eq 0 ]; then
    echo "Do not run this script as root or with sudo, as it may have unintended consequences." >&2
    echo "Run it as a normal user instead." >&2
    exit 1
fi

# Set user home directory and validates by printing to terminal
user_home=$HOME
echo "Running as user: $USER"
echo "Home directory: $user_home"

# Source all functions
source "$user_home/.dotfiles/run.sh"

# Set up logging
log_dir="$user_home/.cache/script-logs"
mkdir -p "$log_dir"
# Keep only the last 5 log files
ls -t "$log_dir"/*.log 2>/dev/null | tail -n +6 | xargs -r rm --
# Make log file
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
log_file="$log_dir/$timestamp.log"
# Save original stdout/stderr for logging
exec 3>&1 4>&2
# Redirect stdout
exec > >(
    tee >(
        awk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0; fflush(); }' >> "$log_file"
    ) >&3
)
# Redirect stderr
exec 2> >(
    tee >(
        awk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0; fflush(); }' >> "$log_file"
    ) | awk '{ print "\033[31m" $0 "\033[0m"; fflush(); }' >&4
)

# MAIN SCRIPT -----------------------------------------------------------------------------------------------
# Make sure this is running on Nobara
echo "This is a custom script for use in Nobara Linux (Fedora).  I cannot guarantee it will work in other distros."

if ! command -v dnf &>/dev/null; then
    echo "Could not find command: dnf.  This will break many of the tasks in this script."
fi

checkpoint "Are you sure that you want to continue?"

echo

# Prompt which task checkpoint they would like to run
task_functions=(
    all_tasks
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
)

echo "Which tasks would you like to execute?"
echo "Provide the input as a spaced list of numbers or just type 0 for all tasks."
max_index=-1
for task in "${task_functions[@]}"; do
    (( max_index++ ))
    echo "${max_index}) ${task}"
done
printf "Enter your choice: "
read -r -a selected_tasks

# Validate input: check if it's a number between 0 and max_index (set above)
validate_input "${selected_tasks[@]}" "$max_index"

# If user selects 0 and other tasks, changes selected task to just 0 to reduce redundancy
if [[ " ${selected_tasks[*]} " =~ " 0 " ]]; then
    selected_tasks=(0) # only run all_tasks
fi

# Run tasks
for task_index in "${selected_tasks[@]}"; do
    "${task_functions[${task_index}]}"
done

echo "Script completed.  Took ${SECONDS} seconds to complete."
