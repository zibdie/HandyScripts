#!/bin/bash

# Pi-hole Weekly Maintenance Script
# Runs system updates, cleanup, and Pi-hole updates automatically
# Created for weekly cron execution

# Set non-interactive mode for apt
export DEBIAN_FRONTEND=noninteractive

# Log file for maintenance activities
LOG_FILE="/var/log/pihole-maintenance.log"

# Function to log with timestamp
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | sudo tee -a "$LOG_FILE"
}

log "=== Starting Pi-hole Weekly Maintenance ==="

# Clean package cache and lists to prevent hash sum mismatches
log "Cleaning package cache and lists..."
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*

# Update package lists
log "Updating package lists..."
sudo apt-get update

# Upgrade packages (non-interactive)
log "Upgrading packages..."
sudo apt-get dist-upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

# Remove unnecessary packages
log "Removing unnecessary packages..."
sudo apt-get autoremove -y

# Update Pi-hole
log "Updating Pi-hole..."
sudo pihole -up

log "=== Pi-hole Weekly Maintenance Complete ==="
log "Rebooting system to apply all changes..."

# Reboot to apply all changes
sudo reboot
