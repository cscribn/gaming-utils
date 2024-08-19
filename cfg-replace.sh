#!/bin/bash

# settings
set -o errexit
set -o nounset
set -o pipefail
[[ "${TRACE-0}" = "1" ]] && set -o xtrace

# global variables
SCRIPT_NAME="$(basename "${0}")"
readonly SCRIPT_NAME
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
readonly SCRIPT_DIR

# usage
if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
	echo "Usage: ${SCRIPT_NAME} target_file replacements_file"
	exit
fi

# functions
add_replace() {
	local key
	local -A replacements
	local replacements_file="$1"
	local target_file="$2"
	local value

	while IFS=" = " read -r key value; do
		replacements[$key]=$value # Don't enclose key or value in quotes. This way handles optional spaces.
	done < "$replacements_file"

	for key in "${!replacements[@]}"; do
		value="${replacements[$key]}"

		if [ "$(grep -E -c "^${key}[[:space:]]" "$target_file")" -ge 1 ]; then
			echo "${SCRIPT_NAME}: updating ${key} to ${value}"
			sed -i "s/^${key}[[:space:]].*/${key} = ${value}/" "$target_file"
		else
			value=${value//\\\//\/}
			echo "${SCRIPT_NAME}: adding ${key} with ${value}"
			echo "$key = $value" >> "$target_file"
		fi
	done

	env LC_COLLATE=C sort -f -o "$target_file" "$target_file"
}

# main function
main() {
	local replacements_file="$1"
	local target_file="$2"

	# check inputs
	[[ "$replacements_file" = "" ]] && echo "Missing replacements_file" && exit 1
	[[ "$target_file" = "" ]] && echo "Missing target_file" && exit 1

	add_replace "$replacements_file" "$target_file"
}

main "${@}"
