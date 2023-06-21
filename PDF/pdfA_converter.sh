#!/bin/bash
# Nautilus script to convert PDF files to PDF/A format using Ghostscript

# Check if any files are selected
if [[ -z "$1" ]]; then
    zenity --error --text="No files selected."
    exit 1
fi

# Ask user if they want to delete original files
delete_files=$(zenity --question --text="Do you want to delete the original PDF files?" --title="PDF to PDF/A Converter")

# Loop through each selected file or folder and convert PDF files to PDFA format
for file in "$@"
do
    if [[ -d "$file" ]]; then
        # Convert all PDF files in the selected folder to PDFA format
        for pdf_file in "$file"/*.pdf
        do
            # Get the file name without extension
            filename=$(basename -- "$pdf_file")
            filename="${filename%.*}"

            # Convert the file to PDFA format
            gs -dPDFA -dBATCH -dNOPAUSE -dUseCIEColor -sProcessColorModel=DeviceCMYK -sDEVICE=pdfwrite -sPDFACompatibilityPolicy=1 -sOutputFile="$file/$filename"_PDFA.pdf "$pdf_file"

            # Check if original file should be deleted
            if [[ "$delete_files" == "true" ]]; then
                rm "$pdf_file"
            fi
        done
    elif [[ -f "$file" && "${file##*.}" == "pdf" ]]; then
        # Convert a single selected PDF file to PDFA format
        # Get the file name without extension
        filename=$(basename -- "$file")
        filename="${filename%.*}"

        # Convert the file to PDFA format
        gs -dPDFA -dBATCH -dNOPAUSE -dUseCIEColor -sProcessColorModel=DeviceCMYK -sDEVICE=pdfwrite -sPDFACompatibilityPolicy=1 -sOutputFile="${file%.*}_PDFA.pdf" "$file"

        # Check if original file should be deleted
        if [[ "$delete_files" == "true" ]]; then
            rm "$file"
        fi
    fi
done

# Show a message indicating the conversion is complete
zenity --info --text="PDF to PDF/A conversion complete." --title="PDF to PDF/A Converter"
