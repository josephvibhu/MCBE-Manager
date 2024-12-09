#!/bin/bash
#v3.2

# Function to check if an update is needed and perform it
update_server() {
    echo "Checking for the latest version of Minecraft Bedrock server..."

    # Set random number for user-agent
    RandNum=$RANDOM

    # Define the current version file path
    VERSION_FILE="/mcbeman/Server/bedrock-server/version.txt"

    # Read the current version from the version.txt file
    if [[ -f "$VERSION_FILE" ]]; then
        CURRENT_VERSION=$(cat "$VERSION_FILE")
        echo "Current version: $CURRENT_VERSION"
    else
        echo "No current version found. Proceeding with the update."
        CURRENT_VERSION=""
    fi

    # Finding the latest version by opening the site and simulating the download link
    # Download the latest version of Minecraft Bedrock server page
    curl -H "Accept-Encoding: identity" -H "Accept-Language: en" -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.33 (KHTML, like Gecko) Chrome/90.0.$RandNum.212 Safari/537.33" -o mcbeman/temp/version.html https://minecraft.net/en-us/download/server/bedrock/

    # Extract the download URL for the latest server version
    LATEST_VERSION=$(basename $(grep -o 'https://www.minecraft.net/bedrockdedicatedserver/bin-linux/[^"]*' downloads/version.html))  # Get the latest version file name

    echo "Download URL: $DownloadURL"
    echo "LATEST_VERSION: $LATEST_VERSION"

    # Compare current version with the latest version
    if [[ "$CURRENT_VERSION" == "$LATEST_VERSION" ]]; then
        echo "You are already running the latest version ($CURRENT_VERSION). No update needed."
        return 0  # No update needed, exit the function
    else
        echo "New version found: $LATEST_VERSION. Proceeding with the update."
    fi

    # Backup the Old Version 
    mv mcbeman/Server/bedrock-server mcbeman/temp/bak/bedrock-server.bak
    rm -r mcbeman/Server/bedrock-server

    # Download the latest version of Minecraft Bedrock dedicated server
    echo "Downloading the latest version of Minecraft Bedrock server..."
    UserName=$(whoami)
    curl -H "Accept-Encoding: identity" -H "Accept-Language: en" -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.33 (KHTML, like Gecko) Chrome/90.0.$RandNum.212 Safari/537.33" -o "mcbeman/temp/$LATEST_VERSION" "$DownloadURL"

    # Unzip the downloaded file
    echo "Unzipping the downloaded file..."
    unzip -o -q "mcbeman/temp/$LATEST_VERSION" -d "mcbeman/temp"

    # Clean up the HTML file after extracting
    rm -f mcbeman/temp/version.html

    # Rename the extracted folder to 'bedrock-server'
    echo "Renaming the extracted folder to 'bedrock-server'..."
    EXTRACTED_FOLDER=$(ls -d mcbeman/temp/bedrock-server*)  # Get the extracted folder's name

    # Move the updated server files into the correct location
    mv "$EXTRACTED_FOLDER" "mcbeman/temp/bedrock-server"

    # Update the version.txt file to the new version
    echo "Updating the version.txt file..."
    echo "$LATEST_VERSION" > "$VERSION_FILE"

    # Restore configuration and worlds
    [ -d ~/mcbeman/temp/bak/bedrock-server.bak ] && {
        echo "Restoring configuration and worlds..."
        cp ~mcbeman/temp/bak/bedrock-server.bak/server.properties ~/mcbeman/Server/bedrock-server || { echo "Failed to restore server.properties"; exit 1; }
        cp -r ~mcbeman/temp/bak/bedrock-server.bak/worlds ~/mcbeman/Server/bedrock-server || { echo "Failed to restore worlds"; exit 1; }
    }

    echo "Server update complete!"
}

# Only call update_server if this script is executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    update_server
fi
