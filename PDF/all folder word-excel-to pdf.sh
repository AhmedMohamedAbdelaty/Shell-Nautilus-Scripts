#!/bin/bash

# Get the input path from the first argument
input_path="$1"

# Check if the input path is a directory or a file
if [ -d "$input_path" ]; then
    # Input path is a directory

    # Use the selected folder as the output folder if none was specified
    output_folder="$input_path"

    # Check if the folder exists
    if [ ! -d "$input_path" ]; then
        zenity --error --text="$input_path is not a directory"
        exit 1
    fi

    # Convert all the PowerPoint, Word, and Excel documents in the folder to PDF
    find "$input_path" -type f \( -iname "*.ppt*" -o -iname "*.doc*" -o -iname "*.xls*" \) -execdir libreoffice --headless --convert-to pdf --outdir "$output_folder" {} +

    # Show a pop-up message when the conversion is complete
    zenity --info --text="Conversion complete!"

elif [ -f "$input_path" ]; then
    # Input path is a file

    # Use the same directory as the input file for the output folder
    output_folder=$(dirname "$input_path")

    # Check if LibreOffice is installed
    if ! command -v libreoffice &>/dev/null; then
        zenity --error --text="LibreOffice is not installed. Please install LibreOffice to convert files to PDF."
        exit 1
    fi

    # Check if the file is a PowerPoint, Word, or Excel document
    if [[ "$input_path" =~ \.(ppt|pptx|doc|docx|xls|xlsx)$ ]]; then
        # Convert the file to PDF
        libreoffice --headless --convert-to pdf --outdir "$output_folder" "$input_path"

        # Show a pop-up message when the conversion is complete
        zenity --info --text="Conversion complete!"
    else
        zenity --error --text="Unsupported file format. Only PowerPoint, Word, and Excel documents are supported."
        exit 1
    fi
else
    # Input path is neither a directory nor a file
    zenity --error --text="$input_path does not exist"
    exit 1
fi
