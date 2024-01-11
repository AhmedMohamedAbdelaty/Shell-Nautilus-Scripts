#!/bin/bash
# Nautilus script to speed up video or audio file using FFmpeg
# Install zenity package if not already installed
if ! command -v zenity &>/dev/null; then
	sudo apt-get install -y zenity
fi
# Get selected files
IFS=$'\n'
selected_files=($NAUTILUS_SCRIPT_SELECTED_FILE_PATHS)

for selected_file in "${selected_files[@]}"; do
	# Check if selected file exists
	if [ ! -f "$selected_file" ]; then
		zenity --error --text="$selected_file does not exist"
		exit 1
	fi

	# Prompt user for the speed factor
	SPEED_FACTOR=$(zenity --entry --title="Speed up video or audio file" --text="Enter the desired speed (default is 2):")

	# Use default speed factor of 2 if user did not enter a value
	if [ -z "$SPEED_FACTOR" ]; then
		SPEED_FACTOR=2
	fi

	# Create an output file name based on the input file name
	OUTPUT_FILE="${selected_file%.*}_fast.${selected_file##*.}"

	# Use FFmpeg to speed up the input file and save it to the output file
	ffmpeg -i "$selected_file" -filter:v "setpts=PTS/$SPEED_FACTOR" -filter:a "atempo=$SPEED_FACTOR" "$OUTPUT_FILE"

	# Show a success message
	zenity --info --text="File '$selected_file' has been sped up and saved as '$OUTPUT_FILE'"
done
