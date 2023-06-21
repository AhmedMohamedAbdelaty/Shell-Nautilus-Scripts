#!/bin/bash
#
# this code will determine exactly the path and the type of file,
# then it will display result through the dialog window.
#
# Nov 19, 2010
#Copyright by Nguyen Duc Long <Email: longnd.s8@gmail.com>
####################################################################################

if [ -e -n $1 ]; then
	x="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
else
	base="`echo $NAUTILUS_SCRIPT_CURRENT_URI | cut -d'/' -f3- | sed 's/%20/ /g'`"
	x="$base/${1##*/}"
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
\nnewline-delimited paths for selected files (only if local): $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS
\nnewline-delimited URIs for selected files: $NAUTILUS_SCRIPT_SELECTED_URIS
\nURI for current location: $NAUTILUS_SCRIPT_CURRENT_URI
\nVariable: $1
"

exit 0
