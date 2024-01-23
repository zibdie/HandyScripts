#!/bin/bash

# Template to run root-required commands easily
# Adding 'sudo' not required and works without it either way.

# Remember to 'chmod +x root-required-template.sh' 

# Write your root-required commands here. COMMANDS variable is multi-line
COMMANDS="
sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get autoremove -y
"

is_in_sudo_group() {
    if id -nG "$USER" | grep -qw "sudo"; then
        return 0
    else
        return 1
    fi
}

can_sudo_without_password() {
    if sudo -n true 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

run_commands() {
    if [[ $(id -u) -eq 0 ]]; then
        echo "Running as root, no need for sudo."
        eval "${COMMANDS//sudo /}"
    elif is_in_sudo_group && can_sudo_without_password; then
        echo "User '$USER' has passwordless sudo access. Continuing..."
        eval "$COMMANDS"
    elif is_in_sudo_group; then
        echo "User '$USER'  is in sudo group, prompting for password..."
        eval "$COMMANDS"
    else
        echo "Error: User '$USER' is not in sudo group. Cannot perform operations requiring elevated privileges."
        exit 1
    fi
}

run_commands
