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

declare catver

# usage
if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    echo "Usage: ./${script_name} catver"
    exit
fi

# main function
main() {
	# check_inputs
	catver="$1"
    [[ "$catver" = "" ]] && echo "Missing catver" && exit 1

    grep -Pio '^[^;].*/ \K.*' "$catver" | sort -u
}

main "${@}"
