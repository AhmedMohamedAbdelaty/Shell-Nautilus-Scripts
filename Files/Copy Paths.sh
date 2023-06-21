
#!/bin/bash

printf '%s' "$(printf '%s' "${NAUTILUS_SCRIPT_SELECTED_FILE_PATHS}" | sed 's/[[:space:]]/\\ /g' | sed 's/[*?\[\]\"]/\\&/g')" \
| {
	if command -v xsel >/dev/null 2>&1; then
		xsel -ib -l /dev/null
	elif command -v xclip >/dev/null 2>&1; then
		xclip -i -selection clipboard -f
	fi
}
