#!/bin/bash

# prompt user to select a folder
folder=$(zenity --file-selection --directory --title="Select a folder containing audio files")

# combine all audio files to one file in sorted order
ffmpeg -i "concat:$(find "$folder" -name '*.mp3' | sort | tr '\n' '|')" -acodec copy output.mp3 > output.log 2>&1

