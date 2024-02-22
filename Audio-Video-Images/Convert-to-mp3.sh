#!/bin/bash
# Nautilus script to convert video to audio using FFmpeg
# Install zenity package if not already installed
if ! command -v zenity &>/dev/null; then
	sudo apt-get install -y zenity
fi
input_video="$1"

# Log file path in the same directory as input video file
log_file=$(dirname "$input_video")/$(basename "$input_video" | cut -f 1 -d '.').log

# Check if FFmpeg is installed
if ! command -v ffmpeg &>/dev/null; then
	zenity --error --text="FFmpeg is not installed. Please install FFmpeg and try again."
	echo "$(date) - FFmpeg is not installed" >>"$log_file"
	exit
fi

# Check if input video file exists
if [ ! -f "$input_video" ]; then
	zenity --error --text="Input video file '$input_video' does not exist. Please enter a valid file path and try again."
	echo "$(date) - Input video file '$input_video' does not exist" >>"$log_file"
	exit
fi

# Get output audio file path in the same directory as input video file
output_audio=$(dirname "$input_video")/$(basename "$input_video" | cut -f 1 -d '.')"converted".mp3

# Extract thumbnail from input video file
thumbnail=$(ffmpeg -i "$input_video" -filter:v "scale=w='if(gt(iw,ih),640,-2)':'if(gt(iw,ih),-2,640)',setsar=1" -vframes 1 -q:v 2 "$output_audio.jpg" 2>&1 | grep -oP "(?<=thumbnail:).*(?=')")
# Convert video file to audio
ffmpeg -i "$input_video" -vn -acodec libmp3lame -ac 2 -ab 160k -ar 48000 "$output_audio"

# Remove thumbnail image file
rm "$output_audio.jpg"

zenity --info --text="Audio conversion for '${input_video}' completed successfully!"
echo "$(date) - Audio conversion for '${input_video}' completed successfully" >>"$log_file"
