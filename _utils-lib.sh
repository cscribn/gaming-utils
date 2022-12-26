#!/bin/bash

# variables
readonly utils_temp_dir="/c/Windows/Temp"

readonly -A system_dbs=(
	["3do"]="The 3DO Company - 3DO"
    ["amiga"]="Commodore - Amiga"
    ["amstradcpc"]="Amstrad - CPC"
    ["atari2600"]="Atari - 2600"
    ["atari5200"]="Atari - 5200"
	["atari7800"]="Atari - 7800"
	["atarilynx"]="Atari - Lynx"
	["atarist"]="Atari - ST"
	["c64"]="Commodore - 64"
	["coleco"]="Coleco - ColecoVision"
	["daphne"]="Daphne"
	["dkong"]="Donkey Kong"
	["dreamcast"]="Sega - Dreamcast"
	["fba"]="FBNeo - Arcade Games"
	["fds"]="Nintendo - Family Computer Disk System"
	["gamegear"]="Sega - Game Gear"
	["gb"]="Nintendo - Game Boy"
	["gba"]="Nintendo - Game Boy Advance"
	["gbc"]="Nintendo - Game Boy Color"
	["gx4000"]="Amstrad - GX4000"
	["intellivision"]="Mattel - Intellivision"
	["jaguar"]="Atari - Jaguar"
	["mame2003-plus"]="MAME 2003-Plus"
	["mame2010"]="MAME 2010"
	["mastersystem"]="Sega - Master System - Mark III"
	["megadrive"]="Sega - Mega Drive - Genesis"
	["msx"]="Microsoft - MSX"
	["n64"]="Nintendo - Nintendo 64"
	["nds"]="Nintendo - Nintendo DS"
	["neogeo"]="SNK - Neo Geo"
	["nes"]="Nintendo - Nintendo Entertainment System"
	["ngpc"]="SNK - Neo Geo Pocket Color"
	["openbor"]="OpenBOR"
	["pc88"]="NEC - PC-88"
	["pc98"]="NEC - PC-98"
	["pce-cd"]="NEC - PC Engine CD - TurboGrafx-CD"
	["pcengine"]="NEC - PC Engine - TurboGrafx 16"
	["pcfx"]="NEC - PC-FX"
	["psp"]="Sony - PlayStation Portable"
	["psx"]="Sony - PlayStation"
	["saturn"]="Sega - Saturn"
	["sega32x"]="Sega - 32X"
	["segacd"]="Sega - Mega-CD - Sega CD"
	["sg-1000"]="Sega - SG-1000"
	["shmups"]="Shoot 'Em Up"
	["snes"]="Nintendo - Super Nintendo Entertainment System"
	["snes-msu1"]="Nintendo - Super Nintendo Entertainment System - MSU1"
	["supergrafx"]="NEC - PC Engine SuperGrafx"
	["vic20"]="Commodore - VIC-20"
	["videopac"]="Magnavox - Odyssey2"
	["wonderswan"]="Bandai - WonderSwan"
	["wonderswancolor"]="Bandai - WonderSwan Color"
	["x68000"]="Sharp - X68000"
	["zxspectrum"]="Sinclair - ZX Spectrum"
)

readonly -A system_retro_corenames=(
	["amiga"]="PUAE"
    ["amstradcpc"]="cap32"
	["atari2600"]="Stella"
	["atari5200"]="Atari800"
	["atari7800"]="ProSystem"
	["atarilynx"]="Handy"
	["c64"]="VICE x64"
	["coleco"]="FinalBurn Neo"
	["dreamcast"]="Flycast"
	["gamegear"]="Genesis Plus GX"
	["fba"]="FinalBurn Neo"
	["gb"]="Gambatte"
	["gbc"]="Gambatte"
	["intellivision"]="FreeIntv"
    ["jaguar"]="Virtual Jaguar"
	["mame2003-plus"]="MAME 2003-Plus"
	["mame2010"]="MAME 2010"
	["mastersystem"]="Genesis Plus GX"
	["megadrive"]="Genesis Plus GX"
	["msx"]="blueMSX"
	["nds"]="DeSmuME 2015"
	["neogeo"]="FinalBurn Neo"
	["ngpc"]="Beetle NeoPop"
	["pc"]="DOSBox-pure"
	["pc88"]="QUASI88"
	["pcengine"]="Beetle SuperGrafx"
	["pcfx"]="Beetle PC-FX"
	["saturn"]="YabaSanshiro"
	["sg-1000"]="Genesis Plus GX"
	["shmups"]="FinalBurn Neo"
	["vic20"]="VICE xvic"
    ["videopac"]="O2EM"
	["x68000"]="PX68K"
	["zxspectrum"]="fuse"
)

# since these can become variable names using reflection, replace dashes with underscores
readonly -a systems_underscores=(
	"3do"
	"amiga"
	"amstradcpc"
	"atari2600"
	"atari5200"
	"atari7800"
	"atarilynx"
	"atarist"
	"c64"
	"coleco"
	"dkong"
	"doom"
	"dreamcast"
	"fba"
	"fds"
	"gamegear"
	"gb"
	"gba"
	"gbc"
	"gx4000"
	"intellivision"
	"jaguar"
	"mame2003_plus"
	"mame2010"
	"mastersystem"
	"megadrive"
	"msx"
	"n64"
	"nds"
	"neogeo"
	"nes"
	"ngpc"
	"pc"
	"pc88"
	"pc98"
	"pce_cd"
	"pcengine"
	"pcfx"
	"psp"
	"psx"
	"quake"
	"saturn"
	"sega32x"
	"segacd"
	"sg_1000"
	"shmups"
	"snes"
	"snes_msu1"
	"supergrafx"
	"vic20"
	"videopac"
	"wonderswan"
	"wonderswancolor"
	"x68000"
	"zxspectrum"
)

# methods
md5sum_check() {
	local target="$1"
	local machine="$2"
	local result=1
	local target_dir
	target_dir="$(dirname "$target")"
	local target_base
	target_base="$(basename "$target")"
	local md5name

	if [ -n "$machine" ]; then
		md5name="${target_base}-${machine}"
	else
		md5name="${target_base}"
	fi

	md5sum_gen "$1" "$2"
	local result

	if [ -f "${target_dir}/${md5name}".md5 ]; then
		cmp -s "${target_dir}/${md5name}".md5 "${utils_temp_dir}${target_dir}/${md5name}".md5
		result=$?
	fi

	if [ "$result" != 0 ] && [ -f "${utils_temp_dir}${target_dir}/${md5name}".md5 ]; then
		cp -p "${utils_temp_dir}${target_dir}/${md5name}".md5 "${target_dir}/${md5name}".md5
	fi

	rm -rf "${utils_temp_dir}${target_dir}/${md5name}".md5
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

	if [ -d "$target_base" ]; then
		md5=($(tar c "$target_base" | md5sum))
	else
		md5=($(md5sum "$target_base"))
	fi

	cd - > /dev/null || exit 1
	local md5name

	if [ -n "$machine" ]; then
		md5name="${target_base}-${machine}"
	else
		md5name="${target_base}"
	fi

	mkdir -p "${utils_temp_dir}${target_dir}"
	echo "${md5[0]}"  > "${utils_temp_dir}${target_dir}/${md5name}".md5
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
