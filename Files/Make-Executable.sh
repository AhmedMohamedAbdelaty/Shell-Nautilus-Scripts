#!/bin/bash
# Change the Install_Path.

INSTALL_PATH="/home/$USER/.gnome2/nemo-scripts/File System Management"

# Set IFS so that it won't consider spaces as entry separators.  Without this, spaces in file/folder names can make the loop go wacky.
IFS=$'\n'

# See if the Nautilus environment variable is empty
if [ -z $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS ]; then
    # If it's blank, set it equal to $1
    NAUTILUS_SCRIPT_SELECTED_FILE_PATHS=$1
fi

# Loop through the list (from either Nautilus or the command line)
for ARCHIVE_FULLPATH in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS; do
    NEWDIRNAME=${ARCHIVE_FULLPATH%.*}
    FILENAME=${ARCHIVE_FULLPATH##*/}
    NAME=${ARCHIVE_FULLPATH##*/.*}

if [ "$ARCHIVE_FULLPATH" ];then
        gnome-terminal -x sudo chmod +x "$ARCHIVE_FULLPATH"
        zenity --info --text="File "$ARCHIVE_FULLPATH" is now executable! :)"
    else
        # Install Script
        echo "Installing Nautilus-Extension.."
        echo "Install Script in: $INSTALL_PATH - Is that right? [y/n]"
        read input
        if [ "$input" == "y" ];then
            mv "$0" "$INSTALL_PATH"
            echo "Installation Successfully! :)"
        else
            echo ""
            echo "Enter the /home/<name>  NAME of your Homedir."
            echo "Example: your home is /home/jjd - so type: jjd:"
            read homedirname
            sleep 1
            echo "Installing Nautilus-Extension to /home/$homedirname/.gnome2/nemo-scripts/File System Management"
            mv "$0" "/home/$homedirname/.gnome2/nemo-scripts/File System Management"
            echo "Done! :)"
        fi
fi
done
