#!/bin/bash

# RUN YOUR 'ROOT REQUIRED' COMMANDS HERE! 
# You dont need to add sudo, can work with or without!
COMMANDS="
sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get autoremove -y
"

# Function to check if user is in the sudo group
is_in_sudo_group() {
    if id -nG "$USER" | grep -qw "sudo"; then
        return 0
    else
        return 1
    fi
}

# Function to check if sudo can be executed without a password
can_sudo_without_password() {
    if sudo -n true 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to execute the commands with sudo, prompt for password if needed
run_commands() {
    if [[ $(id -u) -eq 0 ]]; then
        echo "Running as root, no need for sudo."
        # Execute commands without sudo as root
        eval "${COMMANDS//sudo /}"
    elif is_in_sudo_group && can_sudo_without_password; then
        echo "User has passwordless sudo access."
        # Execute commands as they are
        eval "$COMMANDS"
    elif is_in_sudo_group; then
        echo "User is in sudo group, prompting for password..."
        # Execute commands as they are
        eval "$COMMANDS"
    else
        echo "Error: User is not in sudo group. Cannot perform operations requiring elevated privileges."
        exit 1
    fi
}

# Run the commands
run_commands
