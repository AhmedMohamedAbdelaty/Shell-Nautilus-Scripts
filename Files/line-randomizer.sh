#!/bin/bash

# Check if file exists
if [ ! -f "$1" ]; then
  echo "File not found!"
  exit 1
fi

# Shuffle the lines of the file
shuf "$1" > "$1".shuf

# Overwrite the original file with the shuffled lines
mv "$1".shuf "$1"

echo "Lines randomized!"