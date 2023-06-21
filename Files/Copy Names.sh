
unset -v \
	names
IFS="$(printf '\n!')"; IFS="${IFS%!}"
for FILE_PATH in ${NAUTILUS_SCRIPT_SELECTED_FILE_PATHS}; do
	names="${names:+${names}${IFS}}$(basename "${FILE_PATH}")"
done

printf '%s' "${names}" \
| {
	if test "$(command -pv xsel)"; then
		xsel -ib -l /dev/null
	elif test "$(command -pv xclip)"; then
		xclip -i -selection clipboard -f
	fi
}
