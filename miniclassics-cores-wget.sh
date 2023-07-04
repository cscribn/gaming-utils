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

declare today
today=$(date +%F)
readonly classicmodscloud_psclassic="https://classicmodscloud.com/classic_libretro/nightly/PlayStation_Classic/${today}/so/"
readonly classicmodscloud_segamini="https://classicmodscloud.com/classic_libretro/nightly/Sega_Mega_drive_Mini/${today}/so/"
readonly psclassic_dir="${script_dir}/cores-psclassic-modmyclassic-nightly"
readonly segamini_dir="${script_dir}/cores-segamini-modmyclassic-nightly"

# usage
if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
	echo "Usage: ./${script_name}"
	exit
fi

# main function
main() {
	rm -f "${psclassic_dir}/"*
	wget -nd -r -l 1 -P "$psclassic_dir" -A so -e robots=off "$classicmodscloud_psclassic"

	rm -f "${segamini_dir}/"*
	wget -nd -r -l 1 -P "$segamini_dir" -A so -e robots=off "$classicmodscloud_segamini"
}

main "${@}"
