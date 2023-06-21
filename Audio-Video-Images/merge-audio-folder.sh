#!/bin/bash

# check if folder path is provided as argument
if [ -z "$1" ]; then
    echo "Please provide a folder path as argument"
    exit 1
fi

# extract folder name from path
folder_name=$(basename "$1")

# combine all audio files to one file in sorted order
ffmpeg -i "concat:$(find "$1" -name '*.mp3' | sort | tr '\n' '|')" -acodec copy "$folder_name.mp3" > output.log 2>&1

notify-send "Audio files merged successfully"