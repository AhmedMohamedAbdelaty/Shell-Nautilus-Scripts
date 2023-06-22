#!/bin/bash

# Get the path of the selected file
filename="$1"

# Prompt user for start and end times
start_time=$(zenity --entry --text "Enter start time in HH:MM:SS format" --title "Cut Audio/Video" --width 500)
end_time=$(zenity --entry --text "Enter end time in HH:MM:SS format" --title "Cut Audio/Video" --width 500)

# Extract file extension
extension="${filename##*.}"

# Set output file name
output="${filename%.*}-cut.$extension"

# Cut audio or video for specified range
ffmpeg -i "$filename" -ss "$start_time" -to "$end_time" -c:v libx264 -c:a copy "$output"

# Show message box when finished cutting
zenity --info --text "Finished cutting $filename from $start_time to $end_time. Output saved at $output."

