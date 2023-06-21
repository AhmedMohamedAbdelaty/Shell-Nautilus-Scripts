#!/bin/bash

# Set up variables
palette="${1%.*}_palette.png"
filters="fps=${2:-24},scale=-1:720:flags=lanczos"
newname="${1%.*}_720p.gif"

# Generate palette
ffmpeg -v warning -i "$1" \
    -vf "$filters,palettegen" \
    -y "$palette"

# Create GIF
ffmpeg -v warning -i "$1" \
    -i "$palette" \
    -lavfi "$filters [x]; [x][1:v] paletteuse" \
    -y "$newname"

# Notify user that conversion is complete
notify-send "GIF created from $1"