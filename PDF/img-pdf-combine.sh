#!/bin/bash

# convert folder of images to pdf or files 

IFS=$'\n'
selected_files=("$@")
unset IFS

if [ -z "$selected_files" ]; then
    zenity --error --text="No files selected"
    exit 1
fi

# if the selected is a folder 
if [ -d "${selected_files[0]}" ]; then
    selected_files=("${selected_files[0]}"/*)
fi

# get the directory of the first selected file
output_dir=$(dirname "${selected_files[0]}")

# create log file
log_file="${output_dir}/conversion.log"
touch "$log_file"

# convert images to pdf and output log to file
convert "${selected_files[@]}" "${output_dir}/converted_combined.pdf" 2>&1 | tee -a "$log_file"

zenity --info --text="Conversion complete. Log file saved at $log_file" --title="Converter"