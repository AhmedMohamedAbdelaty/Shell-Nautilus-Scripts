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
# Create a log file to store the progress in the same dir of selected file
log_file=$(dirname "$1")/audio_to_video_conversion.log
# Redirect all output to the log file
exec > >(tee -a "$log_file") 2>&1
# Check if selected file is a directory
if [[ -d "$1" ]]; then
    # Get list of audio files in directory
    audio_files=$(find "$1" -maxdepth 1 -type f -iname "*.mp3" -o -iname "*.wav" -o -iname "*.ogg")
    if [[ -z "$audio_files" ]]; then
        zenity --info --text="No audio files found in '$1'."
        exit
    fi
    for input_audio in $audio_files; do
        # Get output video file path in the same directory as input audio file
        output_video=$(dirname "$input_audio")/$(basename "$input_audio" | cut -f 1 -d '.')_$(date +%Y%m%d%H%M%S).mp4

        # Extract thumbnail from input audio file
        thumbnail=$(ffmpeg -i "$input_audio" -filter:v "scale=w='if(gt(iw,ih),640,-2)':'if(gt(iw,ih),-2,640)',setsar=1" -vframes 1 -q:v 2 "$output_video.jpg" 2>&1 |
            zenity --progress --auto-close --text="Extracting thumbnail...")

        # if the file "output_video.jpg" is not created, then the audio file does not contain any image
        # ask the user to provide an image file using zenity file selection dialog
        if [ ! -f "$output_video.jpg" ]; then
            image_file=$(zenity --file-selection --title="Select an image file" --file-filter="Image files (png, jpg, jpeg) | *.png *.jpg *.jpeg")
            if [ -z "$image_file" ]; then
                zenity --error --text="No image file selected. Please select an image file and try again."
                exit
            fi
            # Extract thumbnail from selected image file
            thumbnail=$(ffmpeg -i "$image_file" -filter:v "scale=w='if(gt(iw,ih),640,-2)':'if(gt(iw,ih),-2,640)',setsar=1" -vframes 1 -q:v 2 "$output_video.jpg" 2>&1 |
                zenity --progress --auto-close --text="Extracting thumbnail...")
        fi

        # Convert audio file to video
        ffmpeg -loop 1 -i "$output_video.jpg" -i "$input_audio" -c:v libx264 -preset fast -tune stillimage -c:a copy -shortest "$output_video" 2>&1 |
            zenity --progress --auto-close --text="Converting audio to video..."
        # Remove thumbnail image file
        rm "$output_video.jpg"
    done
    zenity --info --text="Video conversion completed successfully!"
else
    # Check if selected_file is an audio file
    if [[ "$1" == *.mp3 || "$1" == *.wav || "$1" == *.ogg ]]; then
        # Check if input audio file exists
        if [ ! -f "$1" ]; then
            zenity --error --text="Input audio file '$1' does not exist. Please enter a valid file path and try again."
            exit
        fi
        # Get output video file path in the same directory as input audio file
        output_video=$(dirname "$1")/$(basename "$1" | cut -f 1 -d '.')_$(date +%Y%m%d%H%M%S).mp4
        # Extract thumbnail from input audio file
        thumbnail=$(ffmpeg -i "$1" -filter:v "scale=w='if(gt(iw,ih),640,-2)':'if(gt(iw,ih),-2,640)',setsar=1" -vframes 1 -q:v 2 "$output_video.jpg" 2>&1 |
            zenity --progress --auto-close --text="Extracting thumbnail...")

        # if the file "output_video.jpg" is not created, then the audio file does not contain any image
        # ask the user to provide an image file using zenity file selection dialog
        if [ ! -f "$output_video.jpg" ]; then
            image_file=$(zenity --file-selection --title="Select an image file" --file-filter="Image files (png, jpg, jpeg) | *.png *.jpg *.jpeg")
            if [ -z "$image_file" ]; then
                zenity --error --text="No image file selected. Please select an image file and try again."
                exit
            fi
            # Extract thumbnail from selected image file
            thumbnail=$(ffmpeg -i "$image_file" -filter:v "scale=w='if(gt(iw,ih),640,-2)':'if(gt(iw,ih),-2,640)',setsar=1" -vframes 1 -q:v 2 "$output_video.jpg" 2>&1 |
                zenity --progress --auto-close --text="Extracting thumbnail...")
        fi

        # Convert audio file to video
        ffmpeg -loop 1 -i "$output_video.jpg" -i "$1" -c:v libx264 -preset fast -tune stillimage -c:a copy -shortest "$output_video" 2>&1 |
            zenity --progress --auto-close --text="Converting audio to video..."
        # Remove thumbnail image file
        rm "$output_video.jpg"
        zenity --info --text="Video conversion for '$1' completed successfully!"
    else
        # Selected file is not an audio file
        zenity --error --text="Please select an audio file and try again."
        exit
    fi
fi
