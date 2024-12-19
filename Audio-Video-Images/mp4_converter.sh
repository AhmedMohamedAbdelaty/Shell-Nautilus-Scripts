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

# Get input file (use Zenity file selection if not provided)
if [ -z "$1" ]; then
    INPUT_FILE=$(zenity --file-selection --title="Select an MP4 file to convert")
    if [ -z "$INPUT_FILE" ]; then
        log "No input file selected."
        exit 1
    fi
else
    INPUT_FILE="$1"
fi

# Allow user to select output file name and location
OUTPUT_FILE=$(zenity --file-selection --save --confirm-overwrite \
    --title="Save Converted File As" \
    --filename="$(dirname "$INPUT_FILE")/$(basename "${INPUT_FILE%.*}_converted.mp4")")
if [ -z "$OUTPUT_FILE" ]; then
    log "No output file selected."
    exit 1
fi

# Ask user to choose conversion method
CONVERSION_METHOD=$(zenity --list --radiolist \
    --title="Conversion Method" \
    --text="Choose conversion method:" \
    --column="Select" --column="Option" \
    TRUE "Re-encode (better compatibility)" FALSE "Copy Streams (faster, same quality)")

if [ "$CONVERSION_METHOD" = "Re-encode (better compatibility)" ]; then
    # Let user select encoding preset and CRF value
    PRESET=$(zenity --list --radiolist \
        --title="Encoding Speed Preset" \
        --text="Select encoding speed preset:" \
        --column="Select" --column="Preset" \
        TRUE "fast" FALSE "medium" FALSE "slow")

    CRF=$(zenity --entry \
        --title="Select Video Quality" \
        --text="Enter CRF value (0-51, lower is better quality, default is 23):" \
        --entry-text="23")

    FFMPEG_PARAMS="-c:v libx264 -preset $PRESET -crf $CRF -c:a aac -movflags +faststart"
else
    # Use stream copy to avoid re-encoding
    FFMPEG_PARAMS="-c:v copy -c:a copy -movflags +faststart"
fi

# Get duration of input file for progress calculation
DURATION_SEC=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$INPUT_FILE")
DURATION_MS=$(awk -v duration="$DURATION_SEC" 'BEGIN { printf("%.0f\n", duration * 1000) }')

# Display start popup with Cancel and OK buttons
if ! zenity --question --title="Starting Conversion" --text="The conversion process has started." --ok-label="OK" --cancel-label="Cancel"; then
    log "Conversion cancelled by user."
    exit 1
fi

# Convert the input MP4 file to a compatible format
log "Starting conversion of $INPUT_FILE to $OUTPUT_FILE"

# Start the conversion process without progress bar
ffmpeg -i "$INPUT_FILE" $FFMPEG_PARAMS "$OUTPUT_FILE" 2>&1 | tee -a "$LOG_FILE"

# Check if conversion was successful
if [ -f "$OUTPUT_FILE" ]; then
    log "Conversion completed successfully. Output file: $OUTPUT_FILE"
    # Ask if the user wants to open the output file
    if zenity --question --title="Conversion Complete" --text="Conversion completed successfully.\nOutput file: $OUTPUT_FILE\n\nDo you want to open the file?" --ok-label="Yes" --cancel-label="No"; then
        xdg-open "$OUTPUT_FILE"
    fi
else
    log "An error occurred during the conversion."
    zenity --error --title="Conversion Failed" --text="An error occurred during the conversion."
fi

log "Conversion process finished."
