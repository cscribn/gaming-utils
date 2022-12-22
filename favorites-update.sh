#!/bin/bash

# settings
set -o errexit
set -o nounset
set -o pipefail
[[ "${TRACE-0}" = "1" ]] && set -o xtrace

# include
source ./_utils-lib.sh

# variables
declare script_name
script_name=$(basename "${0}")
declare favorites_dir
declare favorites_file
declare gamelists_dir
declare gamelist_file
declare system_db
declare thumbnails_dir

# usage
if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    echo "Usage: ./${script_name} system gamelists_dir favorites_dir thumbnails_dir"
    exit 1
fi

# helper functions
check_new() {
	local md5sum_check_favorites_echo=$(md5sum_check "${favorites_file}" "")
	local md5sum_check_gamelist_echo=$(md5sum_check "${gamelist_file}" "")

	if [[ "$md5sum_check_favorites_echo" = "0" ]] && [[ "$md5sum_check_gamelist_echo" = "0" ]]; then
        echo "${script_name}: ${system} no favorite changes"
        exit 0
	fi
}

clear_existing_favorites() {
    sed -i 's/name> /name>/g' "$gamelist_file"
    sed -i "s/\/opt\/retropie\/configs\/all\/retroarch\/thumbnails\/${system_db}\/Named_Boxarts\/!!!/\/opt\/retropie\/configs\/all\/retroarch\/thumbnails\/${system_db}\/Named_Boxarts\//g" "$gamelist_file"

    cd "$thumbnails_dir/${system_db}/Named_Boxarts" > /dev/null || exit 1
    shopt -s nullglob

    local thumbnail
    for thumbnail in !!!*; do
        mv "$thumbnail" "${thumbnail:3}"
    done

    shopt -u nullglob
    cd - > /dev/null || exit 1
}

set_favorites() {
    echo "${script_name}: ${system} setting favorites"

    local favorites
    readarray -t favorites < "$favorites_file"
    cd "$thumbnails_dir/${system_db}/Named_Boxarts" > /dev/null || exit 1

    local fav
    for fav in "${favorites[@]}"; do
        local fav_amped="${fav//amp;/}"
        local fav_sedkey
        fav_sedkey=$(sed_escape_keyword "$fav")
        local fav_sedrep
        fav_sedrep=$(sed_escape_replace "$fav")
        local fav_amped_ra
        fav_amped_ra=$(ra_escape "$fav_amped")
        local fav_amped_ra_png="$fav_amped_ra".png
        local fav_amped_ra_sedkey
        fav_amped_ra_sedkey=$(sed_escape_keyword "$fav_amped_ra")
        local fav_amped_ra_sedrep
        fav_amped_ra_sedrep=$(sed_escape_replace "$fav_amped_ra")

        if [ ! -f "$fav_amped_ra_png" ]; then
            echo "${script_name}: ${fav_amped_ra_png} not found"
            exit 1
        else
            mv "$fav_amped_ra_png" !!!"$fav_amped_ra_png"
        fi

        sed -i "s/name>${fav_sedkey}</name> ${fav_sedrep}</" "$gamelist_file"
        sed -i "s/\/opt\/retropie\/configs\/all\/retroarch\/thumbnails\/${system_db}\/Named_Boxarts\/${fav_amped_ra_sedkey}/\/opt\/retropie\/configs\/all\/retroarch\/thumbnails\/${system_db}\/Named_Boxarts\/!!!${fav_amped_ra_sedrep}/" "$gamelist_file"
    done

    cd - > /dev/null || exit 1
}

# main function
main() {
    # check_inputs
    system="$1"
    [[ "$system" = "" ]] && echo "Missing system" && exit 1

    gamelists_dir="$2"
    [[ "$gamelists_dir" = "" ]] && echo "Missing gamelists_dir" && exit 1

    favorites_dir="$3"
    [[ "$favorites_dir" = "" ]] && echo "Missing favorites_dir" && exit 1

    thumbnails_dir="$4"
    [[ "$thumbnails_dir" = "" ]] && echo "Missing thumbnails_dir" && exit 1

    favorites_file="${favorites_dir}/favorites-${system}.txt"
    gamelist_file="${gamelists_dir}/${system}/gamelist.xml"

    if [ ! -f "$gamelist_file" ]; then
        echo "${script_name}: ${system} no gamelist so no favorites"
        exit 0
    fi

    local md5sum_check_echo

    if [ ! -f "$favorites_file" ]; then
        echo "${script_name}: ${system} no favorites"
        md5sum_check_echo=$(md5sum_check "${gamelist_file}" "")
        exit 0
    fi

    if [ "$system" = "mame2003-plus" ]; then
        system_db="MAME"
    elif [[ "$system" = "mame"* ]]; then
        echo "${script_name}: ${system} no favorites (MAME)"
        md5sum_check_echo=$("${gamelist_file}" "")
        exit 0
    else
        system_db="${system_dbs[$system]}"
    fi

    check_new
    clear_existing_favorites
    set_favorites

    md5sum_check_echo=$(md5sum_check "${favorites_file}" "")
    md5sum_check_echo=$(md5sum_check "${gamelist_file}" "")
}

main "${@}"
