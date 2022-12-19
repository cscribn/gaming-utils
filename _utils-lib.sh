#!/bin/bash

# variables
readonly temp_dir="/c/Windows/Temp"

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
		cmp -s "${target_dir}/${md5name}".md5 "${temp_dir}${target_dir}/${md5name}".md5
		result=$?
	fi

	if [ "$result" != 0 ] && [ -f "${temp_dir}${target_dir}/${md5name}".md5 ]; then
		cp -p "${temp_dir}${target_dir}/${md5name}".md5 "${target_dir}/${md5name}".md5
	fi

	rm -rf "${temp_dir}${target_dir}/${md5name}".md5
	return $result
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

	mkdir -p "${temp_dir}${target_dir}"
	echo "${md5[0]}"  > "${temp_dir}${target_dir}/${md5name}".md5
}
