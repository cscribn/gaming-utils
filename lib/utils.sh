#!/bin/bash

# variables
readonly utils_temp_dir="/c/Windows/Temp"

declare -A rom_dats=(
	["astdelux"]="mame2003-plus"
	["astinvad"]="mame2003-plus"
	["astrob"]="mame2003-plus"
	["astrof"]="mame2003-plus"
	["bigfight"]="mame2010"
	["bigkong"]="mame2010"
	["bublbobr"]="mame2003-plus"
	["crysking"]="mame2010"
	["ddragon"]="mame2003-plus"
	["foodf"]="mame2003-plus"
	["gorf"]="mame2003-plus"
	["moonwlkb"]="mame2003-plus"
	["ncv1"]="mame2010"
	["ncv2"]="mame2010"
	["outrun"]="mame2003-plus"
	["polepos"]="mame2010"
	["polepos2"]="mame2010"
	["salmndr2"]="mame2003-plus"
	["shienryu"]="mame2003-plus"
)

declare -A system_dats=(
	["arcade"]="arcade"
	["arcade-pre90s"]="arcade"
	["arcade-pst90s"]="arcade"
	["coleco"]="coleco"
	["neogeo"]="neogeo"
	["spectrum"]="spectrum"
)

readonly -A system_dbs=(
	["3do"]="3DO Company - 3DO"
	["amiga"]="Commodore - Amiga"
	["amstradcpc"]="Amstrad - CPC"
	["arcade-pre90s"]="Arcade - Pre-90s"
	["arcade-pst90s"]="Arcade - Post-90s"
	["atari2600"]="Atari - 2600"
	["atari5200"]="Atari - 5200"
	["atari7800"]="Atari - 7800"
	["atarijaguar"]="Atari - Jaguar"
	["atarilynx"]="Atari - Lynx"
	["atarist"]="Atari - ST"
	["c64"]="Commodore - 64"
	["coleco"]="Coleco - ColecoVision"
	["daphne"]="Arcade - Laser Disc"
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
	["megadrive-msu"]="Sega - Mega Drive - Genesis - MSU"
	["moto"]="Thomson - MOTO"
	["msx"]="Microsoft - MSX"
	["n64"]="Nintendo - Nintendo 64"
	["nds"]="Nintendo - Nintendo DS"
	["neogeo"]="SNK - Neo Geo"
	["nes"]="Nintendo - Nintendo Entertainment System"
	["ngpc"]="SNK - Neo Geo Pocket Color"
	["openbor"]="OpenBOR Team - OpenBOR"
	["pc"]="Microsoft - DOS"
	["pc88"]="NEC - PC-88"
	["pc98"]="NEC - PC-98"
	["pce-cd"]="NEC - PC Engine CD - TurboGrafx-CD"
	["pcengine"]="NEC - PC Engine - TurboGrafx 16"
	["pcfx"]="NEC - PC-FX"
	["psp"]="Sony - PlayStation Portable"
	["psx"]="Sony - PlayStation"
	["quake"]="Microsoft - DOS - Quake"
	["saturn"]="Sega - Saturn"
	["sega32x"]="Sega - 32X"
	["segacd"]="Sega - Mega-CD - Sega CD"
	["sg-1000"]="Sega - SG-1000"
	["snes"]="Nintendo - Super Nintendo Entertainment System"
	["snes-msu1"]="Nintendo - Super Nintendo Entertainment System - MSU1"
	["supergrafx"]="NEC - PC Engine SuperGrafx"
	["vic20"]="Commodore - VIC-20"
	["videopac"]="Magnavox - Odyssey2"
	["wonderswan"]="Bandai - WonderSwan"
	["wonderswancolor"]="Bandai - WonderSwan Color"
	["x1"]="Sharp - X1"
	["x68000"]="Sharp - X68000"
	["zxspectrum"]="Sinclair - ZX Spectrum"
)

readonly -a systems_fba_nonarcade=(
	"coleco"
)

readonly -A system_retro_corenames=(
	["amiga"]="PUAE"
	["amstradcpc"]="cap32"
	["atari2600"]="Stella"
	["atari5200"]="Atari800"
	["atari7800"]="ProSystem"
	["atarijaguar"]="Virtual Jaguar"
	["atarilynx"]="Handy"
	["c64"]="VICE x64"
	["coleco"]="FinalBurn Neo"
	["fba"]="FinalBurn Neo"
	["gamegear"]="Genesis Plus GX"
	["gb"]="Gambatte"
	["gbc"]="Gambatte"
	["intellivision"]="FreeIntv"
	["mame2003-plus"]="MAME 2003-Plus"
	["mame2010"]="MAME 2010"
	["mastersystem"]="Genesis Plus GX"
	["megadrive"]="Genesis Plus GX"
	["megadrive-msu"]="Genesis Plus GX"
	["moto"]="theodore"
	["msx"]="blueMSX"
	["neogeo"]="FinalBurn Neo"
	["ngpc"]="Beetle NeoPop"
	["pc"]="DOSBox-pure"
	["pc88"]="QUASI88"
	["pcfx"]="Beetle PC-FX"
	["quake"]="TyrQuake"
	["sg-1000"]="Genesis Plus GX"
	["snes"]="Snes9x 2010"
	["snes-msu1"]="Snes9x"
	["vic20"]="VICE xvic"
	["videopac"]="O2EM"
	["x1"]="x1"
	["x68000"]="PX68K"
	["zxspectrum"]="fuse"
)

# helper functions
check_favorites() {
	local favorites_dir="$1"
	local system="$2"
	local rom_scrape_dir="$3"
	local check_images="$4"
	local result=0

	favorites="${favorites_dir}/favorites-${system}.txt"

	[[ ! -f "$favorites" ]] && return 0

	echo "Check favorites - ${system}..."
	local -a faves
	readarray -t faves < "$favorites"

	local fav
	for fav in "${faves[@]}"; do
		local fav_amped="${fav//amp;/}"
		local fav_amped_sedkey
		fav_amped_sedkey=$(sed_escape_keyword "$fav_amped")
		local fav_amped_ra
		fav_amped_ra=$(ra_escape "$fav_amped")
		local fav_amped_ra_sedkey
		fav_amped_ra_sedkey=$(sed_escape_keyword "$fav_amped_ra")
		local check_dir
		local fav_not_found

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
	local message="$1"
	local color

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
	local target="$1"
	local machine="$2"
	local real_target
	real_target="$(realpath "$target")"
	local target_dir
	target_dir="$(dirname "$real_target")"
	local target_base
	target_base="$(basename "$real_target")"
	local result=1
	local md5name

	if [[ -n "$machine" ]]; then
		md5name="${target_base}-${machine}"
	else
		md5name="${target_base}"
	fi

	md5sum_gen "$1" "$2"
	local result

	if [[ -f "${target_dir}/${md5name}".md5 ]]; then
		cmp -s "${target_dir}/${md5name}".md5 "${utils_temp_dir}/${target_dir}/${md5name}".md5
		result=$?
	fi

	if [[ "$result" != 0 ]] && [[ -f "${utils_temp_dir}/${target_dir}/${md5name}".md5 ]]; then
		cp -p "${utils_temp_dir}/${target_dir}/${md5name}".md5 "${target_dir}/${md5name}".md5
	fi

	rm -rf "${utils_temp_dir}/${target_dir}/${md5name}".md5
	echo "$result"
}

md5sum_gen() {
	local target="$1"
	local machine="$2"
	local real_target
	real_target="$(realpath "$target")"
	local target_dir
	target_dir="$(dirname "$real_target")"
	local target_base
	target_base="$(basename "$real_target")"

	cd "$target_dir" > /dev/null || exit 1

	local md5

	if [[ -d "$target_base" ]]; then
		md5=($(tar c "$target_base" | md5sum))
	else
		md5=($(md5sum "$target_base"))
	fi

	cd - > /dev/null || exit 1

	local md5name

	if [[ -n "$machine" ]]; then
		md5name="${target_base}-${machine}"
	else
		md5name="${target_base}"
	fi

	mkdir -p "${utils_temp_dir}/${target_dir}"
	echo "${md5[0]}"  > "${utils_temp_dir}/${target_dir}/${md5name}".md5
}

mkrm() {
	mkdir -p "${1:?Missing directory}"
	rm -rf "${1:?}"/*
}

ra_escape() {
	echo "$1" | tr '&*/:\`<>?\\|' '_'
}

rm_empty_dirs() {
	local target_dir="$1"
	local machine="$2"

	cd "${target_dir:?}" > /dev/null || exit 1
	find . -type d -empty -delete
	cd - > /dev/null || exit 1
}

rm_empty_dirs_ssh() {
	local target_dir="$1"
	local machine="$2"

	ssh "pi@${machine}" "cd \"${target_dir}\" > /dev/null || exit 1; find . -type d -empty -delete; cd - > /dev/null || exit 1"
}

sed_escape_keyword() {
	printf '%s\n' "$1" | sed -e 's/[]\/$*.^[]/\\&/g'
}

sed_escape_replace() {
	printf '%s\n' "$1" | sed -e 's/[\/&]/\\&/g'
}
