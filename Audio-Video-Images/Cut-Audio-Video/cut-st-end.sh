#!/bin/bash
# Install zenity package if not already installed
if ! command -v zenity &>/dev/null; then
  sudo apt-get install -y zenity
fi
# Get the path of the selected file
filename="$1"

# Create log file
log_file="cut_log.txt"

# Prompt user for start and end times
start_time=$(zenity --entry --text "Enter start time in HH:MM:SS format" --title "Cut Audio/Video" --width 500)
end_time=$(zenity --entry --text "Enter end time in HH:MM:SS format" --title "Cut Audio/Video" --width 500)

# Extract file extension
extension="${filename##*.}"

# Set output file name
output="${filename%.*}-cut.$extension"

# Open window indicating processing
zenity --info --text="Processing..." --title="Cutting Audio/Video" --width=300 &

# Cut audio or video for specified range
# ffmpeg -i "$filename" -ss "$start_time" -to "$end_time" -c:v libx264 -c:a copy "$output" >>"$log_file" 2>&1
ffmpeg -i "$filename" -ss "$start_time" -to "$end_time" -c:a copy "$output" >>"$log_file" 2>&1

# Check if the process was successful
if [ $? -eq 0 ]; then
  # Show success message box
  zenity --info --text "Successfully cut $filename from $start_time to $end_time. Output saved at $output."
else
  # Show error message box
  zenity --error --text "Error occurred while cutting $filename. Check $log_file for details."
fi

# Close the processing window
pkill zenity
