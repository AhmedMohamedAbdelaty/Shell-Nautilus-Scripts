#!/bin/bash
# Nautilus script to convert audio mp3 to ogg using FFmpeg

input_audio="$1"

# Log file path in the same directory as input audio file
log_file=$(dirname "$input_audio")/$(basename "$input_audio" | cut -f 1 -d '.').log

# Check if FFmpeg is installed
if ! command -v ffmpeg &> /dev/null
then
    zenity --error --text="FFmpeg is not installed. Please install FFmpeg and try again."
    echo "$(date) - FFmpeg is not installed" >> "$log_file"
    exit
fi

# Check if input audio file exists
if [ ! -f "$input_audio" ]
then
    zenity --error --text="Input audio file '$input_audio' does not exist. Please enter a valid file path and try again."
    echo "$(date) - Input audio file '$input_audio' does not exist" >> "$log_file"
    exit
fi

# Get output ogg file path in the same directory as input audio file
output_ogg=$(dirname "$input_audio")/$(basename "$input_audio" | cut -f 1 -d '.').ogg

# Convert audio file to ogg
ffmpeg -i "$input_audio" -acodec libvorbis -ac 2 -ab 160k -ar 48000 "$output_ogg"

zenity --info --text="Audio conversion for '${input_audio}' completed successfully!"
echo "$(date) - Audio conversion for '${input_audio}' completed successfully" >> "$log_file"
