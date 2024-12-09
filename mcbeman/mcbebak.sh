#!/bin/bash

mcbebak() {
    world_name=$1
    world_directory="worlds/$world_name"

    # Check if the world directory exists
    if [ ! -d "$world_directory" ]; then
        echo "World '$world_name' directory does not exist for backup!"
        exit 1
    fi

    # Prompt user for backup confirmation
    read -p "Do you want to back up the world '$world_name' (y/n)? " backup_choice
    if [ "$backup_choice" != "y" ]; then
        echo "Backup skipped for '$world_name'."
        return
    fi

    # Generate timestamp and backup directory
    timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
    backup_directory="mcbe:/Minecraft_Backups/$world_name-$timestamp/"

    echo "Backing up world '$world_name' to Google Drive..."
    rclone copy "$world_directory" "$backup_directory" --progress || { echo "Failed to back up '$world_name'."; exit 1; }

    echo "Backup completed successfully for '$world_name'."
}
