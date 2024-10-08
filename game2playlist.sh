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

declare -A SPECIAL_CORES
declare -A SPECIAL_PATHS

# include
source "${SCRIPT_DIR}/lib/utils.sh"
source "${SCRIPT_DIR}/lib/special.sh" > /dev/null 2>&1

# usage
if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
	echo "Usage: ./${SCRIPT_NAME} gamelist system_db playlists_dir rom_path core_path core_name"
	exit
fi

# functions
exit_zero() {
	echo "$1"
	exit 0
}

special_get() {
	local item_value_array
	local system_db="$1"

	local item_key
	for item_key in "${!SPECIAL_ITEMS[@]}"; do
		IFS=';' read -ra item_value_array <<< "${SPECIAL_ITEMS[$item_key]}"
		if [[ "${item_value_array[0]}" = "$system_db" ]]; then
			SPECIAL_PATHS["$item_key"]="${item_value_array[1]}"
			SPECIAL_CORES["$item_key"]="${item_value_array[2]}"
		fi
	done
}

intro_gen() {
	local playlist="$1"

	{
		echo "{"
		echo "  \"version\": \"1.0\","
		echo "  \"items\": ["
	} > "$playlist"
}

path_gen() {
	local line="$1"
	local json_rom
	local json_rom_no_ext
	local path_map
	local playlist="$2"
	local rom
	local rom_orig
	local rom_path="$3"
	local system_db="$4"

	# Strip off beginning ./
	mapfile -t path_map < <(echo "$line" | grep -Pio 'path>\.\/\K[^<]*')
	rom_orig="${path_map[0]}"

	if [[ -n "${SPECIAL_PATHS[$rom_orig]}" ]]; then
		rom="${SPECIAL_PATHS[$rom_orig]}"
	else
		rom="$rom_orig"
	fi

	json_rom=${rom//&amp;/\&}
	json_rom_no_ext=${rom%.*}

	echo "    {" >> "$playlist"

	if [ "${rom_path}" = "/media/Games" ]; then
		echo "      \"path\": \"${rom_path}/${json_rom_no_ext}/${json_rom}\"," >> "$playlist"
	else
		echo "      \"path\": \"${rom_path}/${json_rom}\"," >> "$playlist"
	fi

	if [ "$system_db" = "Coleco - ColecoVision" ]; then
		{
			echo "      \"subsystem_roms\": ["
			echo "        \"${rom_path}/${json_rom}\""
			echo "      ],"
			echo "      \"subsystem_ident\": \"cv\","
			echo "      \"subsystem_name\": \"ColecoVision\","
		} >> "$playlist"
	fi

	echo "$rom_orig"
}

label_gen() {
	local line="$1"
	local json_name
	local name_map
	local name
	local playlist="$2"

	mapfile -t name_map < <(echo "$line" | grep -Pio 'name>\K[^<]*')
	name="${name_map[0]}"
	name=$(sed "s/^${FAV_SYMBOL_ES}/${FAV_SYMBOL_RA}/" <<< $name)
	json_name=${name//&amp;/\&}

	{
		echo "      \"label\": \"${json_name}\","
	} >> "$playlist"
}

body_gen() {
	local core_name="$1"
	local core_name_new
	local core_name_new_trimmed
	local core_path="$2"
	local playlist="$3"
	local rom_orig="$4"
	local system_db="$5"

	if [[ -n "${SPECIAL_CORES[$rom_orig]}" ]]; then
		core_name_new="${SPECIAL_CORES[$rom_orig]}"
	else
		core_name_new="$core_name"
	fi

	core_name_new_trimmed=${core_name_new/_libretro.so/}

	{
		echo "      \"core_path\": \"${core_path}/${core_name_new}\","
		echo "      \"core_name\": \"${core_name_new_trimmed}\","
		echo "      \"crc32\": \"DETECT\","
		echo "      \"db_name\": \"${system_db}.lpl\""
		echo -n "    }"
	} >> "$playlist"
}

outro_gen() {
	local playlist="$1"

	{
		echo ""
		echo "  ]"
		echo "}"
	} >> "$playlist"
}

# main function
main() {
	local core_name="$6"
	local core_path="$5"
	local first_time
	local gamelist="$1"
	local playlist
	local playlists_dir="$3"
	local rom_path="$4"
	local rom_orig
	local system_db="$2"

	# check_inputs
	[[ "$gamelist" = "" ]] && echo "Missing gamelist" && exit 1
	[[ ! -f "$gamelist" ]] && exit_zero "${SCRIPT_NAME}: ${system_db} skipping - gamelist missing"
	[[ "$system_db" = "" ]] && echo "Missing system_db" && exit 1
	[[ "$playlists_dir" = "" ]] && echo "Missing playlists_dir" && exit 1
	[[ "$rom_path" = "" ]] && echo "Missing rom_path" && exit 1
	[[ "$core_path" = "" ]] && echo "Missing core_path" && exit 1
	[[ "$core_name" = "" ]] && echo "Missing core_name" && exit 1

	mkdir -p "$playlists_dir"
	playlist="${playlists_dir}/${system_db}.lpl"
	echo "${SCRIPT_NAME}: ${system_db} playlist - started"
	special_get "$system_db"
	intro_gen "$playlist"

	first_time="true"

	local line
	grep -e \<path\> -e \<name\> "$gamelist" | while read -r line ; do
		if [[ "$line" == *"<path"* ]]; then
			if [ "$first_time" = "false" ]; then
				{
					echo ","
				} >> "$playlist"
			fi

			first_time="false"
			rom_orig=$(path_gen "$line" "$playlist" "$rom_path" "$system_db")
		elif [[ "$line" == *"<name"* ]]; then
			label_gen "$line" "$playlist"
			body_gen "$core_name" "$core_path" "$playlist" "$rom_orig" "$system_db"
		fi
	done

	outro_gen "$playlist"
	echo "${SCRIPT_NAME}: ${system_db} playlist - finished"
}

main "${@}"
