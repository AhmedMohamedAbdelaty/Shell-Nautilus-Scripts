#!/bin/bash

# compine files to pdf
IFS=$'\n'
selected_files=("$@")
seleceted_files_name=()
unset IFS

# if the selected is files not folder , then the name is the first file name
# if the selected is folder, then the name is the folder name
if [ -d "${selected_files[0]}" ]; then
    seleceted_files_name=("${selected_files[0]}")
else
    seleceted_files_name=("${selected_files[0]##*/}")
fi

# if the seleceted file is a directory, then use the files in the directory
if [ -d "${selected_files[0]}" ]; then
    selected_files=("${selected_files[0]}"/*)
fi

# convert to pdf using pdfunite
pdfunite "${selected_files[@]}" "${seleceted_files_name[0]}.pdf"

# a pop-up message to show the result or show the error message
if [ $? -eq 0 ]; then
    notify-send "Success" "Files are combined successfully"
else
    notify-send "Error" "Files are not combined successfully"
fi
