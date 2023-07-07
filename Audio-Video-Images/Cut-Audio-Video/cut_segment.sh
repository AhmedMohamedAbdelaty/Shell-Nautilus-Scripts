#!/bin/bash

# Set default segment length
SEGMENT_LENGTH=60

# Get selected file(s)
selected_file="$1"

# Check if selected file exists
if [ ! -f "$selected_file" ]
then
	zenity --error --text="File '$selected_file' does not exist'"
	exit 1
fi

# Prompt user for segment length in seconds
SEGMENT_LENGTH=$(zenity --entry --title="Split a video or audio file" --text="Enter the desired segment length in seconds (default is 60):")

# Use default segment length of 60 seconds if user did not enter a value
if [ -z "$SEGMENT_LENGTH" ]
then
	SEGMENT_LENGTH=60
fi

# Get the selected file extension
FILE_EXTENSION="${selected_file##*.}"

# Set the output file prefix
OUTPUT_PREFIX="${selected_file%.*}_part"

# Use FFmpeg to split the selected file into segments
ffmpeg -i "$selected_file" -c copy -map 0 -segment_time "$SEGMENT_LENGTH" -reset_timestamps 1 -f segment "${OUTPUT_PREFIX}%03d.${FILE_EXTENSION}"

zenity --info --text="File '$selected_file' has been split into ${SEGMENT_LENGTH}-second segments."
