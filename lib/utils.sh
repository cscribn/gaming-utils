#!/bin/bash

# global variables
readonly ENABLE_A500=true
readonly ENABLE_PSCLASSIC=true
readonly ENABLE_RETROTG16=true
readonly ENABLE_RETROVIEG=true
readonly ENABLE_SEGAMINI=true
readonly FAV_SYMBOL_ES=" ☆"
readonly FAV_SYMBOL_RA="!!!"
readonly -A SYSTEM_DATS=(
	["arcade-pre90s"]="arcade"
	["arcade-pst90s"]="arcade"
	["coleco"]="coleco"
	["neogeo"]="neogeo"
	["spectrum"]="spectrum"
)
readonly -A SYSTEM_DBS=(
	["3do"]="Panasonic - 3DO"
	["amiga"]="Commodore - Amiga"
	["amstradcpc"]="Amstrad - CPC"
	["arcade-pre90s"]="Arcade - 80s and Before"
	["arcade-pst90s"]="Arcade - 90s and After"
	["atari2600"]="Atari - 2600"
	["atari5200"]="Atari - 5200"
	["atari7800"]="Atari - 7800"
	["atarilynx"]="Atari - Lynx"
	["c64"]="Commodore - 64"
	["coleco"]="Coleco - ColecoVision"
	["doom"]="Microsoft - DOS - DOOM"
	["dreamcast"]="Sega - Dreamcast"
	["fds"]="Nintendo - Family Computer Disk System"
	["gamegear"]="Sega - Game Gear"
	["gb"]="Nintendo - Game Boy"
	["gba"]="Nintendo - Game Boy Advance"
	["gbc"]="Nintendo - Game Boy Color"
	["intellivision"]="Mattel - Intellivision"
	["mastersystem"]="Sega - Master System - Mark III"
	["megadrive"]="Sega - Mega Drive - Genesis"
	["msx"]="Microsoft - MSX"
	["n64"]="Nintendo - Nintendo 64"
	["neogeo"]="SNK - Neo Geo"
	["nes"]="Nintendo - Nintendo Entertainment System"
	["ngpc"]="SNK - Neo Geo Pocket Color"
	["pc"]="Microsoft - DOS"
	["pc98"]="NEC - PC-98"
	["pce-cd"]="NEC - PC Engine CD - TurboGrafx-CD"
	["pcengine"]="NEC - PC Engine - TurboGrafx 16"
	["psp"]="Sony - PlayStation Portable"
	["psx"]="Sony - PlayStation"
	["psxclassic"]="Sony - PlayStation Classic"
	["saturn"]="Sega - Saturn"
	["sega32x"]="Sega - 32X"
	["segacd"]="Sega - Mega-CD - Sega CD"
	["sg-1000"]="Sega - SG-1000"
	["snes"]="Nintendo - Super Nintendo Entertainment System"
	["vic20"]="Commodore - VIC-20"
	["videopac"]="Magnavox - Odyssey2"
	["wonderswan"]="Bandai - WonderSwan"
	["x68000"]="Sharp - X68000"
	["zxspectrum"]="Sinclair - ZX Spectrum"
)
readonly -a SYSTEMS_FBA_NONARCADE=(
	"coleco"
)
readonly UTILS_TEMP_DIR="/c/Windows/Temp"

# functions
check_favorites() {
	local check_dir
	local fav_amped
	local fav_amped_ra
	local fav_amped_ra_sedkey
	local fav_amped_sedkey
	local fav_not_found
	local -a faves
	local favorites_dir="$1"
	local system="$2"
	local rom_scrape_dir="$3"
	local check_images="$4"

	favorites="${favorites_dir}/favorites-${system}.txt"

	[[ ! -f "$favorites" ]] && return 0

	echo "Check favorites - ${system}..."
	readarray -t faves < "$favorites"

	local fav
	for fav in "${faves[@]}"; do
		fav_amped="${fav//amp;/}"
		fav_amped_sedkey=$(sed_escape_keyword "$fav_amped")
		fav_amped_ra=$(ra_escape "$fav_amped")
		fav_amped_ra_sedkey=$(sed_escape_keyword "$fav_amped_ra")

		if [[ "$check_images" = 0 ]]; then
			check_dir="${rom_scrape_dir}/${system}/media/Named_Boxarts"
			fav_not_found=1

			compgen -G "${check_dir}/${fav_amped_sedkey}."* > /dev/null && fav_not_found=0

			compgen -G "${check_dir}/${fav_amped_ra_sedkey}."* > /dev/null &&
			fav_not_found=0
		else
			check_dir="${rom_scrape_dir}/${system}"
			fav_not_found=1

			compgen -G "${check_dir}/${fav_amped_sedkey}."* > /dev/null &&
			fav_not_found=0
		fi

		[[ "$fav_not_found" = 1 ]] && echo "${fav} not found"
	done

	return "$fav_not_found"
}

echo_color() {
	local color
	local message="$1"

	case $2 in
		green)
			color=2
			;;
		*)
			color=1 # red
			;;
	esac

	echo "$(tput setab ${color})${message}$(tput sgr 0)"
}

md5sum_check() {
	local machine="$2"
	local md5name
	local real_target
	local result
	local target="$1"
	local target_base
	local target_dir

	real_target="$(realpath "$target")"
	target_base="$(basename "$real_target")"

	if [[ -n "$machine" ]]; then
		md5name="${target_base}-${machine}"
	else
		md5name="${target_base}"
	fi

	md5sum_gen "$target" "$machine"
	target_dir="$(dirname "$real_target")"
	result=1

	if [[ -f "${target_dir}/${md5name}".md5 ]]; then
		cmp -s "${target_dir}/${md5name}".md5 "${UTILS_TEMP_DIR}/${target_dir}/${md5name}".md5
		result=$?
	fi

	if [[ "$result" != 0 ]] && [[ -f "${UTILS_TEMP_DIR}/${target_dir}/${md5name}".md5 ]]; then
		cp -p "${UTILS_TEMP_DIR}/${target_dir}/${md5name}".md5 "${target_dir}/${md5name}".md5
	fi

	rm -rf "${UTILS_TEMP_DIR}/${target_dir}/${md5name}".md5
	echo "$result"
}

md5sum_gen() {
	local machine="$2"
	local md5
	local md5name
	local real_target
	local target_base
	local target_dir
	local target="$1"

	real_target="$(realpath "$target")"
	target_dir="$(dirname "$real_target")"

	cd "$target_dir" > /dev/null || exit 1

	target_base="$(basename "$real_target")"

	if [[ -d "$target_base" ]]; then
		md5=($(tar c "$target_base" | md5sum))
	else
		md5=($(md5sum "$target_base"))
	fi

	cd - > /dev/null || exit 1

	if [[ -n "$machine" ]]; then
		md5name="${target_base}-${machine}"
	else
		md5name="${target_base}"
	fi

	mkdir -p "${UTILS_TEMP_DIR}/${target_dir}"
	echo "${md5[0]}"  > "${UTILS_TEMP_DIR}/${target_dir}/${md5name}".md5
}

mkrm() {
	local dir="$1"

	mkdir -p "${dir:?Missing directory}"
	rm -rf "${dir:?}"/*
}

ra_escape() {
	echo "$1" | tr '&*/:\`<>?\\|' '_'
}

sed_escape_keyword() {
	printf '%s\n' "$1" | sed -e 's/[]\/$*.^[]/\\&/g'
}

sed_escape_replace() {
	printf '%s\n' "$1" | sed -e 's/[\/&]/\\&/g'
}
