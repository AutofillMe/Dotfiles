#!/usr/bin/env zsh

checkpoint() {
	while true; do
		echo -n "$1 [y/n]: "
		read ans
		case $ans in
			[Yy]* ) break ;;
			[Nn]* ) exit 1 ;;
			* ) echo "Please answer Y for Yes or N for No" ;;
		esac
	done
}

# Make sure this is running on Nobara
echo "Run this in Ghostty after running install.sh."

checkpoint "Are you sure that you want to continue?"

# Change shell
chsh -s /usr/bin/zsh

# Remove bash files
rm -f ~/.bash*
rm ~/.config/starship.toml

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
