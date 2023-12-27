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

	readonly temp_dir="${rom_dir}/7z2zip_temp"
	readonly zip_dir="${rom_dir}-zip"

	cd "$rom_dir" > /dev/null || exit

	local rom
	for rom in *.7z; do
		zip_file="${zip_dir}/${rom%.*}.zip"
		rm "$zip_file"
		7z x "$rom" -o"$temp_dir"

		cd "$temp_dir" || exit

		num_files=$(ls -1q ./* | wc -l)

		if [[ $num_files -eq 2 ]]; then
			7z a "$zip_file" ./*
		fi

		cd - || exit

		rm -r "$temp_dir"
	done

	cd - > /dev/null || exit
}

main "${@}"
