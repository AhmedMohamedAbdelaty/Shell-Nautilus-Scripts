#!/bin/bash

# Set the path to the directory where the script will be installed
INSTALL_PATH="/usr/local/bin"

# Set IFS so that it won't consider spaces as entry separators. Without this, spaces in file/folder names can make the loop go wacky.
IFS=$'\n'

# Check if any file paths were passed as arguments
if [ $# -eq 0 ]; then
    # If no arguments were passed, prompt the user to select files
    echo "Please select the files you want to make executable:"
    read -e -p "> " -i "$HOME/" -a files
else
    # If arguments were passed, use them as the list of files to make executable
    files=("$@")
fi

# Loop through the list of files
for file in "${files[@]}"; do
    # Check if the file exists
    if [ -e "$file" ]; then
        # Make the file executable
        chmod +x "$file"
        echo "File '$file' is now executable!"
    else
        echo "File '$file' does not exist!"
    fi
done
