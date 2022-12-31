#!/bin/bash

# settings
set -o errexit
set -o nounset
set -o pipefail
[[ "${TRACE-0}" = "1" ]] && set -o xtrace

# variables
declare script_name
script_name="$(basename "${0}")"
declare script_dir
script_dir="$(dirname "$0")"

declare target_file
declare replacements_file

# usage
if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    echo "Usage: ${script_name} target_file replacements_file"
    exit
fi

# helper functions
add_replace() {
    local key
    local value
    local -A replacements

	while IFS=" = " read -r key value; do
		replacements[$key]=$value # Don't enclose key or value in quotes. This way handles optional spaces.
	done < "$replacements_file"

	for key in "${!replacements[@]}"; do
		value="${replacements[$key]}"

		if [ "$(grep -E -c "^${key}[[:space:]]" "$target_file")" -ge 1 ]; then
            echo "${script_name}: updating ${key} to ${value}"
			sed -i "s/^${key}[[:space:]].*/${key} = ${value}/" "$target_file"
		else
			echo "${script_name}: adding ${key} with ${value}"
			echo "$key = $value" >> "$target_file"
		fi
	done

	env LC_COLLATE=C sort -f -o "$target_file" "$target_file"
}

# main function
main() {
	# check inputs
	target_file="$1"
	[[ "$target_file" = "" ]] && echo "Missing target_file" && exit 1

	replacements_file="$2"
	[[ "$replacements_file" = "" ]] && echo "Missing replacements_file" && exit 1

	add_replace
}

main "${@}"
