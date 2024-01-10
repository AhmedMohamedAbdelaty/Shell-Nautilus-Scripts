#!/bin/bash

# Get directory name from first argument
dir_name="$1"

# Create Markdown file with same name
md_file="${dir_name}.md"
touch "$md_file"

# Get all files in that directory
files=("$dir_name"/*)

# Write files to Markdown list
echo "# $dir_name To-Do List" >>"$md_file"
for file in "${files[@]}"; do
    echo "- [ ] ${file##*/}" | sed 's/"//g' >>"$md_file"
done

# Inform user Markdown file create as a notification and open it
notify-send "To-Do List Created" "$md_file"
xdg-open "$md_file"
