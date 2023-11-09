#!/bin/bash

# settings
set -o errexit
set -o pipefail
[[ "${TRACE-0}" = "1" ]] && set -o xtrace

# variables
declare script_name
script_name="$(basename "${0}")"
declare script_dir
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
declare rom_dir

# usage
if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    echo "Usage: ./${script_name} rom_path"
    exit
fi

# main function
main() {
	# check_inputs
	rom_dir="$1"
    [[ "$rom_dir" = "" ]] && echo "Missing rom_dir" && exit 1

	[[ ! -d "$rom_dir" ]] && echo "rom_dir doesn't exist" && exit 1

	cd "$rom_dir" > /dev/null || exit
	find . -name "*.m3u" -type f -delete

	local rom
	for rom in *; do

        rom_no_disk=$(echo "$rom" | sed 's/(Disk [^)]*)//g;s/(System)//g;s/(Data)//g;s/\[a\]//g')

		echo "$rom" >> "${rom_no_disk%.*}".m3u
	done

	cd - > /dev/null || exit
}

main "${@}"
