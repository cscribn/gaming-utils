#!/bin/bash

# settings
set -o errexit
set -o pipefail
[[ "${TRACE-0}" = "1" ]] && set -o xtrace

# variables
declare script_name
script_name="$(basename "${0}")"
declare script_dir
script_dir="$(dirname "$0")"

declare rom_dir

# usage
if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
	echo "Usage: ./${script_name} rom_dir"
	exit
fi

# main function
main() {
	# check_inputs
	rom_dir="$1"
	[[ "$rom_dir" = "" ]] && echo "Missing rom_dir" && exit 1

	cd "$rom_dir" > /dev/null || exit

	local rom
	for rom in *; do
		local name="$rom"
		name="${name//\//_}"
		name="${name//[^a-zA-Z0-9_\-]/}"
		echo "$name"
	done

	cd - > /dev/null || exit
}

main "${@}"
