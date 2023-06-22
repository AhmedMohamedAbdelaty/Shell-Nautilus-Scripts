#!/bin/bash

# Iterate through all files recursively
find . -type f -name "* *" -print0 | while IFS= read -r -d '' file; do
  # Replace spaces with hyphens and store the new name in a variable
  new_file_name="$(dirname "$file")/$(basename "$file"| tr ' ' '-')"
  
  # Perform the rename operation
  mv -n "$file" "$new_file_name"
  echo "Renamed '$file' to '$new_file_name'"
done

