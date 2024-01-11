#!/bin/bash
# Install zenity package if not already installed
if ! command -v zenity &>/dev/null; then
    sudo apt-get install -y zenity
fi
# Ask user for input file path
input_file="$1"

# Determine if the input file is an audio or video file
file_extension="${input_file##*.}"
if [[ "$file_extension" == "mp3" || "$file_extension" == "wav" || "$file_extension" == "ogg" ]]; then
    output_extension="mp3"
else
    output_extension="mp4"
fi

# Ask user for start times in seconds, separated by commas (e.g. 10.5,20,30)
start_times_str="$(zenity --entry --text='Enter the start times in seconds, separated by commas:')"

# Convert the comma-separated string of start times into an array
IFS=',' read -ra start_times <<<"$start_times_str"

# Ask user for end time in seconds (e.g. 30 for 30 seconds)
end_time="$(zenity --entry --text='Enter the number of seconds from start:')"

# Get the directory path and base filename of the input file
input_dir="$(dirname "$input_file")"
input_filename="$(basename "$input_file")"

# Remove the file extension from the base filename
input_filename_without_ext="${input_filename%.*}"

# Loop through the start times and use ffmpeg to cut the segments from the input file
for start_time in "${start_times[@]}"; do
    # Construct the output file path using the input file directory, base filename, and output extension
    output_file="$input_dir/$input_filename_without_ext-$start_time-$((start_time + end_time)).$output_extension"

    # Use ffmpeg to cut the segment from the input file and save it to the output file
    ffmpeg -ss "$start_time" -i "$input_file" -t "$end_time" -c copy "$output_file"
done
