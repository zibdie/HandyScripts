#!/bin/bash

# For users with VMWare Workstation 17 Player
# Mount the shared folder and open right to it
# Tested on Ubuntu Desktop 22.04 LTS

MOUNT_POINT="/mnt/hgfs/"
MOUNT_COMMAND="sudo vmhgfs-fuse .host:/ $MOUNT_POINT -o allow_other -o uid=$(id -u)"
OPEN_EXPLORER_COMMAND="xdg-open $MOUNT_POINT"

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
    if [ ! -d "$MOUNT_POINT" ]; then
        sudo mkdir -p "$MOUNT_POINT"
    fi

    if [[ $(id -u) -eq 0 ]]; then
        echo "Running as root, no need for sudo for mount command."
        vmhgfs-fuse .host:/ "$MOUNT_POINT" -o allow_other -o uid=$(id -u "$SUDO_USER")
        # Switch to the original invoking user for opening the file explorer since we dont want file explorer running as root
        su - "$SUDO_USER" -c "$OPEN_EXPLORER_COMMAND"
    elif is_in_sudo_group && can_sudo_without_password; then
        echo "User '$USER' has passwordless sudo access. Continuing..."
        eval "$MOUNT_COMMAND"
        eval "$OPEN_EXPLORER_COMMAND"
    elif is_in_sudo_group; then
        echo "User '$USER' is in sudo group, prompting for password..."
        eval "$MOUNT_COMMAND"
        eval "$OPEN_EXPLORER_COMMAND"
    else
        echo "Error: User '$USER' is not in sudo group. Cannot perform operations requiring elevated privileges."
        exit 1
    fi
}

run_commands
