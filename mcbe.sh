#!/bin/bash

# Source the modular functions
source ~/mcbeman/mcbeupv3
source ~/mcbeman/mcbebak

mcbe() {
    cd ~/mcbeman/Server/bedrock-server || { echo "Directory not found!"; exit 1; }

    # Check if worlds directory exists
    [ -d "worlds" ] || { echo "No 'worlds' directory found!"; exit 1; }

    echo "Listing available worlds in 'worlds' directory..."
    worlds=$(ls -d worlds/*/ | sed 's|^worlds/||' | sed 's|/||')

    [ -n "$worlds" ] || { echo "No worlds available in the 'worlds' directory!"; exit 1; }

    echo "Available worlds:"
    echo "$worlds"

    read -p "Enter the name of the world: " world_name
    world_name=$(echo "$world_name" | xargs)

    # Check if world exists
    echo "$worlds" | grep -qw "$world_name" || { echo "World '$world_name' does not exist!"; exit 1; }

    # Update server.properties
    sed -i "s/^level-name=.*/level-name=$world_name/" server.properties || { echo "Failed to update server.properties"; exit 1; }

    echo "Starting the Minecraft server with world '$world_name'..."
    LD_LIBRARY_PATH=. ./bedrock_server

    # Prompt to backup world
    read -p "Do you want to backup the world (y/n)? " backup_choice
    if [ "$backup_choice" == "y" ]; then
        mcbebak "$world_name"
    else
        echo "Skipping backup for '$world_name'."
    fi

    # Prompt to update server
    read -p "Do you want to update the server (y/n)? " update_choice
    if [ "$update_choice" == "y" ]; then
        mcbeup
    else
        echo "Skipping server update."
    fi
}

# Main function
main() {
    mcbe
}

main
