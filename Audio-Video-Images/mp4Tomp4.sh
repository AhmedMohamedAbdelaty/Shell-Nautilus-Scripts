#!/bin/bash

LOG_FILE="conversion.log"

# Function to log messages
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    log "ffmpeg is not installed. Install it with 'sudo pacman -S ffmpeg'."
    exit 1
fi

# Check if zenity is installed
if ! command -v zenity &> /dev/null; then
    log "zenity is not installed. Install it with 'sudo pacman -S zenity'."
    exit 1
fi

# Check if the user provided an input file
if [ -z "$1" ]; then
    log "Usage: $0 input_file.mp4"
    exit 1
fi

# Get the input file and output file names
INPUT_FILE="$1"
OUTPUT_FILE="${INPUT_FILE%.*}_converted.mp4"

# Convert the input MP4 file to a compatible format
log "Starting conversion of $INPUT_FILE to $OUTPUT_FILE"

# Run ffmpeg with a progress bar using zenity
(
    ffmpeg -i "$INPUT_FILE" -c:v libx264 -c:a aac -strict experimental -preset fast -movflags +faststart "$OUTPUT_FILE" 2>&1 | tee -a "$LOG_FILE" | \
    while IFS= read -r line; do
        echo "$line" | grep -oP 'time=\K[0-9:.]+' | awk -F: '{ print ($1 * 3600 + $2 * 60 + $3) / 60 }' | \
        awk '{ printf "%.0f\n", $1 }' | zenity --progress --title="Converting $INPUT_FILE" --text="Converting $INPUT_FILE to $OUTPUT_FILE" --percentage=0 --auto-close
    done
)

# Notify the user of the successful conversion
if [ $? -eq 0 ]; then
    log "Conversion completed successfully. Output file: $OUTPUT_FILE"
    zenity --info --title="Conversion Complete" --text="Conversion completed successfully. Output file: $OUTPUT_FILE"
else
    log "An error occurred during the conversion."
    zenity --error --title="Conversion Failed" --text="An error occurred during the conversion."
fi

log "Conversion process finished."
