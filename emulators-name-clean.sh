#!/bin/bash

# settings
set -o errexit
set -o pipefail
[[ "${TRACE-0}" = "1" ]] && set -o xtrace

# global variables
SCRIPT_NAME="$(basename "${0}")"
readonly SCRIPT_NAME
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
readonly SCRIPT_DIR

# usage
if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
	echo "Usage: ./${SCRIPT_NAME} rom_dir"
	exit
fi

# main function
main() {
	local name
	local rom_dir="$1"

	# check_inputs
	[[ "$rom_dir" = "" ]] && echo "Missing rom_dir" && exit 1

	cd "$rom_dir" > /dev/null || exit

	local rom
	for rom in *; do
		name="$rom"
		name="${name//\//_}"
		name="${name//[^a-zA-Z0-9_\-]/}"
		echo "$name"
	done

	cd - > /dev/null || exit
}

main "${@}"
