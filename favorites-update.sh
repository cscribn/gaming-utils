#!/bin/bash

# settings
set -o nounset
set -o pipefail
[[ "${TRACE-0}" = "1" ]] && set -o xtrace

# global variables
SCRIPT_NAME="$(basename "${0}")"
readonly SCRIPT_NAME
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
readonly SCRIPT_DIR

# include
source "${SCRIPT_DIR}/lib/utils.sh"

# usage
if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
	echo "Usage: ./${SCRIPT_NAME} system gamelists_dir favorites_dir thumbnails_dir"
	exit 1
fi

# functions
check_new() {
	local favorites_file="$1"
	local gamelist_file="$2"
	local md5sum_check_favorites_echo
	local md5sum_check_gamelist_echo
	local system="$3"

	md5sum_check_favorites_echo=$(md5sum_check "${favorites_file}" "")
	md5sum_check_gamelist_echo=$(md5sum_check "${gamelist_file}" "")

	if [[ "$md5sum_check_favorites_echo" = "0" ]] && [[ "$md5sum_check_gamelist_echo" = "0" ]]; then
		echo "${SCRIPT_NAME}: ${system} no favorite/gamelist changes"
		exit 0
	fi
}

clear_existing_favorites() {
	local gamelist_file="$1"
	local system="$2"
	local system_db="$3"
	local thumbnails_dir="$4"

	echo_color "${SCRIPT_NAME}: ${system} clearing favorites" "green"

	sed -i "s/name>${FAV_SYMBOL_ES}/name>/g" "$gamelist_file"
	sed -i "s/\/opt\/retropie\/configs\/all\/retroarch\/thumbnails\/${system_db}\/Named_Boxarts\/${FAV_SYMBOL_RA}/\/opt\/retropie\/configs\/all\/retroarch\/thumbnails\/${system_db}\/Named_Boxarts\//g" "$gamelist_file"

	cd "$thumbnails_dir/${system_db}/Named_Boxarts" > /dev/null || exit 1

	shopt -s nullglob

	local thumbnail
	for thumbnail in "${FAV_SYMBOL_RA}"*; do
		mv "$thumbnail" "${thumbnail:3}"
	done

	shopt -u nullglob

	cd - > /dev/null || exit 1
}

set_favorites() {
	local fav_amped
	local fav_amped_ra
	local fav_amped_ra_png
	local fav_amped_ra_sedkey
	local fav_amped_ra_sedrep
	local fav_not_found
	local fav_sedkey
	local fav_sedrep
	local favorites
	local favorites_file="$1"
	local gamelist_file="$2"
	local system="$3"
	local system_db="$4"
	local thumbnails_dir="$5"

	echo_color "${SCRIPT_NAME}: ${system} setting favorites" "green"

	readarray -t favorites < "$favorites_file"

	cd "$thumbnails_dir/${system_db}/Named_Boxarts" > /dev/null || exit 1

	fav_not_found=0

	local fav
	for fav in "${favorites[@]}"; do
		fav_amped="${fav//amp;/}"
		fav_sedkey=$(sed_escape_keyword "$fav")
		fav_sedrep=$(sed_escape_replace "$fav")
		fav_amped_ra=$(ra_escape "$fav_amped")
		fav_amped_ra_png="$fav_amped_ra".png
		fav_amped_ra_sedkey=$(sed_escape_keyword "$fav_amped_ra")
		fav_amped_ra_sedrep=$(sed_escape_replace "$fav_amped_ra")

		if [ -f "$fav_amped_ra_png" ]; then
			mv "$fav_amped_ra_png" "${FAV_SYMBOL_RA}${fav_amped_ra_png}"
			sed -i "s/name>${fav_sedkey}</name>${FAV_SYMBOL_ES}${fav_sedrep}</" "$gamelist_file"
			sed -i "s/\/opt\/retropie\/configs\/all\/retroarch\/thumbnails\/${system_db}\/Named_Boxarts\/${fav_amped_ra_sedkey}\.png/\/opt\/retropie\/configs\/all\/retroarch\/thumbnails\/${system_db}\/Named_Boxarts\/${FAV_SYMBOL_RA}${fav_amped_ra_sedrep}.png/" "$gamelist_file"
		else
			echo_color "${SCRIPT_NAME}: ${fav_amped_ra_png} not found" "red"
			fav_not_found=1
		fi
	done

	cd - > /dev/null || exit 1

	echo "$fav_not_found"
}

# main function
main() {
	local favorites_dir="$3"
	local favorites_file
	local gamelists_dir="$2"
	local gamelist_file
	local md5sum_check_echo
	local set_favorites_echo
	local system="$1"
	local system_db
	local thumbnails_dir="$4"

	# check_inputs
	[[ "$system" = "" ]] && echo "Missing system" && exit 1
	[[ "$gamelists_dir" = "" ]] && echo "Missing gamelists_dir" && exit 1
	[[ "$favorites_dir" = "" ]] && echo "Missing favorites_dir" && exit 1
	[[ "$thumbnails_dir" = "" ]] && echo "Missing thumbnails_dir" && exit 1

	favorites_file="${favorites_dir}/favorites-${system}.txt"
	gamelist_file="${gamelists_dir}/${system}/gamelist.xml"

	if [ ! -f "$gamelist_file" ]; then
		echo "${SCRIPT_NAME}: ${system} no gamelist so no favorites"
		exit 0
	fi

	if [ ! -f "$favorites_file" ]; then
		echo "${SCRIPT_NAME}: ${system} no favorites"
		md5sum_check_echo=$(md5sum_check "${gamelist_file}" "")
		exit 0
	fi

	system_db="${SYSTEM_DBS[$system]}"

	check_new "$favorites_file" "$gamelist_file" "$system"
	clear_existing_favorites "$gamelist_file" "$system" "$system_db" "$thumbnails_dir"

	set_favorites_echo=$(set_favorites "$favorites_file" "$gamelist_file" "$system" "$system_db" "$thumbnails_dir")

	[[ "$set_favorites_echo" = "1" ]] && rm -f "${gamelist_file}.md5" && exit 1

	md5sum_check_echo=$(md5sum_check "${favorites_file}" "")
	md5sum_check_echo=$(md5sum_check "${gamelist_file}" "")
}

main "${@}"
