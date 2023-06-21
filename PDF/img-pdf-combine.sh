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

# convert images to pdf
convert "${selected_files[@]}" "${output_dir}/converted_combined.pdf"

zenity --info --text="conversion complete." --title="Converter"
