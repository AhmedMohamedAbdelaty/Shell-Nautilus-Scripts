#!/bin/bash
#
# this code will determine exactly the path and the type of file,
# then it will display result through the dialog window.
#
# Nov 19, 2010
# Copyright by Nguyen Duc Long

if [ -e -n $1 ]; then
	x="$1"
else
	x="$PWD/${1##*/}"
fi

if [ -f "$x" ]; then
	Result="this is file: $x"
elif [ -d "$x" ]; then
	Result="this is folder: $x"
elif [ -z "$x" ]; then
	Result="not determine this object yet: $x"
	
else
	Result="It's exist: $x"
fi

zenity --title "Result of checking object" --info --text "$Result
\npaths for selected files (only if local): $PWD
\nVariable: $1
"

exit 0
