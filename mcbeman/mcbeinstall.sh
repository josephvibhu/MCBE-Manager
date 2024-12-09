#!/bin/bash
#v1.0

# Function to install minecraft bedrock server
install_server() {
    echo "Checking for the latest version of Minecraft Bedrock server available..."

    # Set random number for user-agent
    RandNum=$RANDOM

    # Download the latest version of Minecraft Bedrock server page
    curl -H "Accept-Encoding: identity" -H "Accept-Language: en" -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.33 (KHTML, like Gecko) Chrome/90.0.$RandNum.212 Safari/537.33" -o mcbeman/temp/version.html https://minecraft.net/en-us/download/server/bedrock/

    # Extract the download URL for the latest server version
    LATEST_VERSION=$(basename $(grep -o 'https://www.minecraft.net/bedrockdedicatedserver/bin-linux/[^"]*' downloads/version.html))  # Get the latest version file name

    echo "Download URL: $DownloadURL"
    echo "LATEST_VERSION: $LATEST_VERSION"

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

    # Move the installed server files into the correct location
    mv "$EXTRACTED_FOLDER" "mcbeman/Server/bedrock-server"

    # Update the version.txt file to the maintain version info for future updates
    echo "Updating the version.txt file..."
    echo "$LATEST_VERSION" > "$VERSION_FILE"

    # Modify the server.properties file
    echo "Modifying server.properties file..."
    SERVER_PROPERTIES="mcbeman/Server/bedrock-server/server.properties"
    if [[ -f "$SERVER_PROPERTIES" ]]; then
        sed -i 's/^view-distance=.*/view-distance=64/' "$SERVER_PROPERTIES"
        sed -i 's/^max-threads=.*/max-threads=0/' "$SERVER_PROPERTIES"
        sed -i 's/^server-port=.*/server-port=41675/' "$SERVER_PROPERTIES"
    else
        echo "server.properties not found. Creating a new one..."
        cat <<EOF > "$SERVER_PROPERTIES"
# Minecraft Bedrock Server Properties
view-distance=64
max-threads=0
server-port=41675
EOF
    fi

    echo "Server install and configuration complete!"

    echo "Server install complete!"
}

# Only call update_server if this script is executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_server
fi
