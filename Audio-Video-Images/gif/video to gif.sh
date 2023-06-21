#!/bin/bash

# Set up variables
palette="${NAUTILUS_SCRIPT_SELECTED_FILE_PATHS%.*}_palette.png"
filters="fps=${2:-24},scale=-1:720:flags=lanczos"
newname="${NAUTILUS_SCRIPT_SELECTED_FILE_PATHS%.*}_720p.gif"

# Generate palette
ffmpeg -v warning -i "$1" \
    -vf "$filters,palettegen" \
    -y "$palette"

# Create GIF
ffmpeg -v warning -i "$1" \
    -i "$palette" \
    -lavfi "$filters [x]; [x][1:v] paletteuse" \
    -y "$newname"

# Open the file
nautilus "$newname" &
