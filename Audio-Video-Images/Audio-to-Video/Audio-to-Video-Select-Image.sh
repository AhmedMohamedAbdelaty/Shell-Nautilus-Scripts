#!/bin/bash
# Nautilus script to convert audio to video using FFmpeg
# Install zenity package if not already installed
if ! command -v zenity &>/dev/null; then
    sudo apt-get install -y zenity
fi
# Check if FFmpeg is installed
if ! command -v ffmpeg &>/dev/null; then
    zenity --error --text="FFmpeg is not installed. Please install FFmpeg and try again."
    exit
fi

# Prompt user to select an image file
image_file=$(zenity --file-selection --title="Select an Image File")

# Check if image file was selected
if [[ -z "$image_file" ]]; then
    zenity --error --text="No image file selected. Please try again."
    exit
fi

# Get selected file(s)
IFS=$'\n'
selected_files=($NAUTILUS_SCRIPT_SELECTED_FILE_PATHS)

for selected_file in "${selected_files[@]}"; do
    # Check if selected_file is a directory
    if [[ -d "$selected_file" ]]; then
        # Get list of audio files in directory
        audio_files=$(find "$selected_file" -maxdepth 1 -type f -iname "*.mp3" -o -iname "*.wav" -o -iname "*.ogg")

        if [[ -z "$audio_files" ]]; then
            zenity --info --text="No audio files found in '${selected_file}'."
            exit
        fi

        for input_audio in $audio_files; do
            # Get output video file path in the same directory as input audio file
            output_video=$(dirname "$input_audio")/$(basename "$input_audio" | cut -f 1 -d '_').$(date +%Y%m%d%H%M%S).mp4

            # Resize image to a width and height that are divisible by 2
            resized_image=$(mktemp).png
            ffmpeg -i "$image_file" -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" "$resized_image"

            # Convert audio file to video
            ffmpeg -loop 1 -i "$resized_image" -i "$input_audio" -c:v libx264 -preset fast -tune stillimage -c:a copy -shortest -pix_fmt yuv420p "$output_video"

            #zenity --info --text="Video conversion for '${input_audio}' completed successfully!"
        done
        zenity --info --text="Video conversion completed successfully!"

    else
        # Check if selected_file is an audio file
        if [[ "$selected_file" == *.mp3 || "$selected_file" == *.wav || "$selected_file" == *.ogg ]]; then
            # Check if input audio file exists
            if [ ! -f "$selected_file" ]; then
                zenity --error --text="Input audio file '${selected_file}' does not exist. Please enter a valid file path and try again."
                exit
            fi

            # Get output video file path in the same directory as input audio file
            output_video=$(dirname "$selected_file")/$(basename "$selected_file" | cut -f 1 -d '_').$(date +%Y%m%d%H%M%S).mp4

            # Resize image to a width and height that are divisible by 2
            resized_image=$(mktemp).png
            ffmpeg -i "$image_file" -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" "$resized_image"

            # Convert audio file to video
            ffmpeg -loop 1 -i "$resized_image" -i "$selected_file" -c:v libx264 -preset fast -tune stillimage -c:a copy -shortest -pix_fmt yuv420p "$output_video"

            zenity --info --text="Video conversion for '${selected_file}' completed successfully!"
        else
            # Selected file is not an audio file
            zenity --error --text="Please select an audio file and try again."
            exit
        fi
    fi
done
