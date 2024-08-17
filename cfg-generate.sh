#!/bin/bash

# settings
set -o pipefail
[[ "${TRACE-0}" = "1" ]] && set -o xtrace

# global variables
SCRIPT_NAME="$(basename "${0}")"
readonly SCRIPT_NAME
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
readonly SCRIPT_DIR

readonly -A A500_CFG_DIRS=(
	["Mupen64Plus GLES3"]="Mupen64Plus GLES2"
	["Mupen64Plus-Next"]="Mupen64 Xtreme Amped"
	["Opera"]="Opera Xtreme"
	["PrBoom"]="PrBoom Xtreme"
	["PUAE 2021"]="P-UAE Xtreme"
	["Stella"]="Stella 2014"
	["VICE x64"]="VICE Xtreme x64"
)

readonly -A CORENAME_CORE_OPTIONS=(
	["Atari800"]="atari800_"
	["Beetle SuperGrafx"]="sgx_"
	["Beetle WonderSwan"]="wswan_"
	["cap32"]="cap32_"
	["DuckStation"]="duckstation_"
	["FCEUmm"]="fceumm_"
	["FinalBurn Neo"]="fbneo-"
	["Flycast"]="reicast_"
	["fuse"]="fuse_"
	["Gambatte"]="gambatte_"
	["MAME 2003-Plus"]="mame2003-plus_"
	["MAME"]="mame_current_"
	["Mupen64Plus GLES3"]="mupen64plus-"
	["Mupen64Plus-Next"]="mupen64plus-"
	["Neko Project II kai"]="np2kai_"
	["Nestopia"]="nestopia_"
	["Opera"]="opera_"
	["ParaLLEl N64"]="parallel-n64-"
	["PPSSPP"]="ppsspp_"
	["PUAE 2021"]="puae_"
	["QUASI88"]="q88_"
	["theodore"]="theodore_"
	["VICE x64"]="vice_"
	["VICE xvic"]="vice_"
)
readonly -A PSCLASSIC_CFG_DIRS=(
	["Mupen64Plus GLES3"]="Mupen64Plus GLES2"
	["Mupen64Plus-Next"]="Mupen64Plus-Next GLES3"
	["Opera"]="Opera Xtreme"
	["PrBoom"]="PrBoom Xtreme"
	["PUAE 2021"]="P-UAE Xtreme"
	["VICE x64"]="VICE Xtreme x64"
)
readonly -A SEGAMINI_CFG_DIRS=(
	["Mupen64Plus GLES3"]="Mupen64Plus GLES2"
	["Mupen64Plus-Next"]="Mupen64Plus-Next GLES2"
	["Opera"]="Opera Xtreme"
	["PrBoom"]="PrBoom Xtreme"
	["PUAE 2021"]="P-UAE Xtreme"
	["Stella"]="Stella 2014"
	["VICE x64"]="VICE Xtreme x64"
)
readonly -A RETROPAD_CFG_DIRS=(
	["Mupen64Plus GLES3"]="Mupen64Plus GLES2"
)
readonly -A SYSTEM_RETRO_CORENAMES=(
	["3do"]="Opera"
	["amiga"]="PUAE 2021"
	["arcade-pre90s"]="FinalBurn Neo"
	["arcade-pre90s_2"]="MAME 2003-Plus"
	["arcade-pre90s_3"]="MAME 2010"
	["arcade-pst90s"]="FinalBurn Neo"
	["arcade-pst90s_2"]="MAME 2003-Plus"
	["arcade-pst90s_3"]="MAME 2010"
	["atari2600"]="Stella"
	["atari5200"]="Atari800"
	["atari7800"]="ProSystem"
	["atarilynx"]="Handy"
	["c64"]="VICE x64"
	["coleco"]="FinalBurn Neo"
	["dreamcast"]="Flycast"
	["doom"]="PrBoom"
	["fds"]="Nestopia"
	["gamegear"]="Genesis Plus GX"
	["gb"]="Gambatte"
	["gba"]="mGBA"
	["gbc"]="Gambatte"
	["intellivision"]="FreeIntv"
	["mastersystem"]="Genesis Plus GX"
	["megadrive"]="Genesis Plus GX"
	["msx"]="blueMSX"
	["msx_2"]="fMSX"
	["n64"]="Mupen64Plus GLES3"
	["n64_2"]="Mupen64Plus-Next"
	["n64_3"]="ParaLLEl N64"
	["neogeo"]="FinalBurn Neo"
	["nes"]="Nestopia"
	["nes_2"]="FCEUmm"
	["ngpc"]="Beetle NeoPop"
	["pc"]="DOSBox-pure"
	["pc98"]="Neko Project II kai"
	["pce-cd"]="Beetle SuperGrafx"
	["pcengine"]="Beetle SuperGrafx"
	["psp"]="PPSSPP"
	["psx"]="PCSX-ReARMed"
	["psx_2"]="DuckStation"
	["psxclassic"]="PCSX-ReARMed"
	["quake"]="TyrQuake"
	["sega32x"]="PicoDrive"
	["segacd"]="Genesis Plus GX"
	["sg-1000"]="Genesis Plus GX"
	["snes"]="Snes9x 2010"
	["vecx"]="VecX"
	["vic20"]="VICE xvic"
	["videopac"]="O2EM"
	["wonderswan"]="Beetle WonderSwan"
	["wonderswancolor"]="Beetle WonderSwan"
	["x68000"]="PX68K"
	["zxspectrum"]="fuse"
)
declare corename
declare cfg_dir
declare core_opts_cfg_source
declare machine
declare machine_cfg_dir
declare retroarch_dir
declare system
declare system_no_under

# include
source "${SCRIPT_DIR}/lib/cfg.sh" > /dev/null 2>&1 || ( echo "Missing ./lib/cfg.sh" && exit 1 )
source "${SCRIPT_DIR}/lib/utils.sh"

# usage
if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    echo "Usage: ${SCRIPT_NAME} cfg_dir machine"
	echo "./lib/cfg.sh needs to be present (see ./lib/cfg.sample.sh)"
    exit
fi

# functions
all_cfg_cp() {
	local new_c
	local new_r

	local c
	for c in "${SCRIPT_DIR}/etc/retroarch/config/"*/; do
		[[ "$machine" = "retrotg16" ]] && [[ "$system" != "pcengine" ]] && [[ "$system" != "pce-cd" ]] && continue

		c=$(basename "$c")
		[[ "$c" = "remaps" ]] && continue

		new_c=$(machine_cfg_dir_get "$c")

		echo "${SCRIPT_NAME}: ${machine} - copying cfgs - ${new_c}"
		mkdir -p "${machine_cfg_dir}/${new_c}"
		cp "${SCRIPT_DIR}/etc/retroarch/config/${c}/"* "${machine_cfg_dir}/${new_c}"
	done

	local r
	for r in "${SCRIPT_DIR}/etc/retroarch/config/remaps/"*/; do
		[[ "$machine" = "retrotg16" ]] && [[ "$system" != "pcengine" ]] && [[ "$system" != "pce-cd" ]] && continue

		r=$(basename "$r")
		new_r=$(machine_remaps_dir_get "$r")

		echo "${SCRIPT_NAME}: ${machine} - copying remaps - ${new_r}"
		mkdir -p "${machine_cfg_dir}/remaps/${new_r}"
		cp "${SCRIPT_DIR}/etc/retroarch/config/remaps/${r}/"* "${machine_cfg_dir}/remaps/${new_r}"
	done
}

check_new_clean() {
	local md5sum_check_cfg_echo
	local md5sum_check_config_echo
	local md5sum_check_retroarch_cfg_echo
	local md5sum_check_retroarch_core_opts_echo

	if [[ "$machine" = "retro"* ]]; then
		core_opts_cfg_source="${SCRIPT_DIR}/etc/retroarch/retroarch-core-options-sbc.cfg"
	else
		core_opts_cfg_source="${SCRIPT_DIR}/etc/retroarch/retroarch-core-options-miniclassics.cfg"
	fi

	md5sum_check_cfg_echo=$(md5sum_check "${SCRIPT_DIR}/lib/cfg.sh" "$machine")
	md5sum_check_retroarch_cfg_echo="0"

	# only perform md5sum check in this script for retro* machines
	[[ "$machine" = "retro"* ]] && md5sum_check_retroarch_cfg_echo=$(md5sum_check "${SCRIPT_DIR}/etc/retroarch/retroarch-${machine}.cfg")

	md5sum_check_retroarch_core_opts_echo=$(md5sum_check "$core_opts_cfg_source" "$machine")
	md5sum_check_config_echo=$(md5sum_check "${SCRIPT_DIR}/etc/retroarch/config" "$machine")

	if [[ "$md5sum_check_cfg_echo" = "0" ]] && [[ "$md5sum_check_retroarch_cfg_echo" = "0" ]] && [[ "$md5sum_check_retroarch_core_opts_echo" = "0" ]] \
		&& [[ "$md5sum_check_config_echo" = "0" ]]; then
		echo "${SCRIPT_NAME}: ${machine} nothing new"
		exit 0
	fi

	# set machine_cfg_dirs
	if [[ "$machine" = "retropad" ]]; then
		machine_cfg_dir="${cfg_dir}/mirror/${machine}/home/ark/.config/retroarch/config"
	elif [[ "$machine" = "retro"* ]]; then
		machine_cfg_dir="${cfg_dir}/mirror/${machine}/opt/retropie/configs/all/retroarch/config"
	elif [[ "$machine" = "a500" ]]; then
		machine_cfg_dir="${cfg_dir}/mirror/${machine}/Pandory/.user/.config/retroarch/config"
	elif [[ "$machine" = "psclassic" ]]; then
		machine_cfg_dir="${cfg_dir}/mirror/${machine}/retroarch/config"
	elif [[ "$machine" = "segamini" ]]; then
		machine_cfg_dir="${cfg_dir}/mirror/${machine}/hakchi/libretro/config"
	fi

	# set retroarch_dirs
	if [[ "$machine" = "retropad" ]]; then
		retroarch_dir="~\/\.config\/retroarch"
	elif [[ "$machine" = "retro"* ]]; then
		retroarch_dir="\/opt\/retropie\/configs\/all\/retroarch"
	elif [[ "$machine" = "a500" ]]; then
		retroarch_dir="~\/\.config\/retroarch"
	elif [[ "$machine" = "psclassic" ]]; then
		retroarch_dir=":"
	elif [[ "$machine" = "segamini" ]]; then
		retroarch_dir="~"
	fi

	echo "${SCRIPT_NAME}: ${machine} - cleaning machine cfgs"
	rm -rf "${machine_cfg_dir:?}/"*
}

core_options_gen() {
	local corename_orig
	local opt_file

	echo "${SCRIPT_NAME}: ${machine} - core options generate - ${corename}"

	if [[ "$machine" = "retro"* ]]; then
		opt_file="${machine_cfg_dir}/${corename}/${system_no_under}.opt"
	else
		opt_file="${machine_cfg_dir}/${corename}/${corename}.opt"
	fi

	corename_orig="${SYSTEM_RETRO_CORENAMES[$system]}"

	if printf '%s\0' "${!CORENAME_CORE_OPTIONS[@]}" | grep -Fxqz "$corename_orig"; then
		grep "${CORENAME_CORE_OPTIONS[$corename_orig]}" "$core_opts_cfg_source" > "$opt_file"
	else
		# Create an empty core options file. This is to prevent the global core options from being erroneously populated.
		true > "$opt_file"
	fi

	if [[ "$machine" = "retrotg16" ]] && [[ "$system" = "pcengine" ]]; then
		cp "$opt_file" "${machine_cfg_dir}/${corename}/supergrafx.opt"
		cp "$opt_file" "${machine_cfg_dir}/${corename}/tg-cd.opt"
		cp "$opt_file" "${machine_cfg_dir}/${corename}/tg16.opt"
	fi
}

machine_cfg_dir_get() {
	local dir="$2"

	if [[ "$machine" = "a500" ]] && printf '%s\0' "${!A500_CFG_DIRS[@]}" | grep -Fxqz "$dir"; then
		echo "${A500_CFG_DIRS[$dir]}"
	elif [[ "$machine" = "psclassic" ]] && printf '%s\0' "${!PSCLASSIC_CFG_DIRS[@]}" | grep -Fxqz "$dir"; then
		echo "${PSCLASSIC_CFG_DIRS[$dir]}"
	elif [[ "$machine" = "retropad" ]] && printf '%s\0' "${!RETROPAD_CFG_DIRS[@]}" | grep -Fxqz "$dir"; then
		echo "${RETROPAD_CFG_DIRS[$dir]}"
	elif [[ "$machine" = "segamini" ]] && printf '%s\0' "${!SEGAMINI_CFG_DIRS[@]}" | grep -Fxqz "$dir"; then
		echo "${SEGAMINI_CFG_DIRS[$dir]}"
	else
		echo "$dir"
	fi
}

machine_remaps_dir_get() {
	local dir="$2"

	if [[ "$machine" = "a500" ]] && printf '%s\0' "${!A500_CFG_DIRS[@]}" | grep -Fxqz "$dir"; then
		echo "${A500_CFG_DIRS[$dir]}"
	elif [[ "$machine" = "psclassic" ]] && printf '%s\0' "${!PSCLASSIC_CFG_DIRS[@]}" | grep -Fxqz "$dir"; then
		echo "${PSCLASSIC_CFG_DIRS[$dir]}"
	elif [[ "$machine" = "retropad" ]] && printf '%s\0' "${!RETROPAD_CFG_DIRS[@]}" | grep -Fxqz "$dir"; then
		echo "${RETROPAD_CFG_DIRS[$dir]}"
	elif [[ "$machine" = "segamini" ]] && printf '%s\0' "${!SEGAMINI_CFG_DIRS[@]}" | grep -Fxqz "$dir"; then
		echo "${SEGAMINI_CFG_DIRS[$dir]}"
	else
		echo "$dir"
	fi
}

retroarch_dir_replace() {
	echo "${SCRIPT_NAME}: ${machine} - retroarch dir replace"
	sed -i "s/\$RETROARCH_DIR/${retroarch_dir}/g" "${machine_cfg_dir}"/*/*.cfg
}

turbo_button_replace() {
	echo "${SCRIPT_NAME}: ${machine} - turbo button replace - a"
	sed -i "s/_turbo_btn = \"a\"/_turbo_btn = \"${INPUT_TURBO_BTN_VALUES[${machine};a]}\"/g" "${machine_cfg_dir}"/*/*.cfg
	echo "${SCRIPT_NAME}: ${machine} - turbo button replace - b"
	sed -i "s/_turbo_btn = \"b\"/_turbo_btn = \"${INPUT_TURBO_BTN_VALUES[${machine};b]}\"/g" "${machine_cfg_dir}"/*/*.cfg
	echo "${SCRIPT_NAME}: ${machine} - turbo button replace - x"
	sed -i "s/_turbo_btn = \"x\"/_turbo_btn = \"${INPUT_TURBO_BTN_VALUES[${machine};x]}\"/g" "${machine_cfg_dir}"/*/*.cfg
	echo "${SCRIPT_NAME}: ${machine} - turbo button replace - y"
	sed -i "s/_turbo_btn = \"y\"/_turbo_btn = \"${INPUT_TURBO_BTN_VALUES[${machine};y]}\"/g" "${machine_cfg_dir}"/*/*.cfg
	echo "${SCRIPT_NAME}: ${machine} - turbo button replace - m"
	sed -i "s/_turbo_btn = \"m\"/_turbo_btn = \"${INPUT_TURBO_BTN_VALUES[${machine};m]}\"/g" "${machine_cfg_dir}"/*/*.cfg
}

# main function
main() {
	local md5sum_check_echo

	# check inputs
	cfg_dir="$1"
	[[ "$cfg_dir" = "" ]] && echo "Missing cfg_dir" && exit 1

	machine="$2"
	[[ "$machine" = "" ]] && echo "Missing machine" && exit 1

	check_new_clean
	all_cfg_cp
	[[ "$machine" != "retrotg16" ]] && turbo_button_replace
	[[ "$machine" != "retrotg16" ]] && retroarch_dir_replace

	for system in "${!SYSTEM_RETRO_CORENAMES[@]}"; do
		[[ "$machine" = "retrotg16" ]] && [[ "$system" != "pcengine" ]] && [[ "$system" != "pce-cd" ]] && continue

		corename=$(machine_cfg_dir_get "${SYSTEM_RETRO_CORENAMES[$system]}")
		system_no_under="${system%_*}"

		mkdir -p "${machine_cfg_dir}/${corename}"
		[[ "$machine" = "retro"* ]] && cp "${SCRIPT_DIR}/etc/retroarch/retroarch-${machine}.cfg" "${machine_cfg_dir}/${corename}/${corename}.cfg"
		core_options_gen
	done

	# create new md5sum
	md5sum_check_echo=$(md5sum_check "${SCRIPT_DIR}/${SCRIPT_NAME}" "$machine")
}

main "${@}"
