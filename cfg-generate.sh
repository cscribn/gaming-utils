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
declare CORE_OPTS_CFG_SOURCE
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
declare MACHINE_CFG_DIR
readonly -A PSCLASSIC_CFG_DIRS=(
	["Mupen64Plus GLES3"]="Mupen64Plus GLES2"
	["Mupen64Plus-Next"]="Mupen64Plus-Next GLES3"
	["Opera"]="Opera Xtreme"
	["PrBoom"]="PrBoom Xtreme"
	["PUAE 2021"]="P-UAE Xtreme"
	["VICE x64"]="VICE Xtreme x64"
)
declare RETROARCH_DIR
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
	["amstradcpc"]="cap32"
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
	["sega32x"]="PicoDrive"
	["segacd"]="Genesis Plus GX"
	["sg-1000"]="Genesis Plus GX"
	["snes"]="Snes9x 2010"
	["vecx"]="VecX"
	["vic20"]="VICE xvic"
	["videopac"]="O2EM"
	["wonderswan"]="Beetle WonderSwan"
	["x68000"]="PX68K"
	["zxspectrum"]="fuse"
)

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
	local etc_retroarch_config_dir="$1"
	local machine="$2"
	local system="$3"
	local new_c
	local new_r

	local c
	for c in "${etc_retroarch_config_dir}/"*/; do
		[[ ! -d "$c" ]] && continue

		c=$(basename "$c")
		[[ "$c" = "remaps" ]] && continue

		new_c=$(machine_cfg_dir_get "$c" "$machine")

		echo "${SCRIPT_NAME}: ${machine} - copying cfgs - ${new_c}"
		mkdir -p "${MACHINE_CFG_DIR}/${new_c}"
		cp "${etc_retroarch_config_dir}/${c}/"* "${MACHINE_CFG_DIR}/${new_c}"
	done

	local r
	for r in "${etc_retroarch_config_dir}/remaps/"*/; do
		[[ ! -d "$r" ]] && continue

		r=$(basename "$r")
		new_r=$(machine_remaps_dir_get "$r" "$machine")

		echo "${SCRIPT_NAME}: ${machine} - copying remaps - ${new_r}"
		mkdir -p "${MACHINE_CFG_DIR}/remaps/${new_r}"
		cp "${etc_retroarch_config_dir}/remaps/${r}/"* "${MACHINE_CFG_DIR}/remaps/${new_r}"
	done
}

check_new_clean() {
	local cfg_dir="$1"
	local etc_retroarch_config_dir="$2"
	local machine="$3"
	local md5sum_check_cfg_echo
	local md5sum_check_config_echo
	local md5sum_check_retroarch_cfg_echo
	local md5sum_check_retroarch_core_opts_echo

	if [[ "$machine" = "retro"* ]]; then
		CORE_OPTS_CFG_SOURCE="${SCRIPT_DIR}/etc/retroarch/retroarch-core-options-sbc.cfg"
	else
		CORE_OPTS_CFG_SOURCE="${SCRIPT_DIR}/etc/retroarch/retroarch-core-options-miniclassics.cfg"
	fi

	md5sum_check_cfg_echo=$(md5sum_check "${SCRIPT_DIR}/lib/cfg.sh" "$machine")
	md5sum_check_retroarch_cfg_echo="0"

	# only perform md5sum check in this script for retro* machines
	[[ "$machine" = "retro"* ]] && md5sum_check_retroarch_cfg_echo=$(md5sum_check "${SCRIPT_DIR}/etc/retroarch/retroarch-${machine}.cfg")

	md5sum_check_retroarch_core_opts_echo=$(md5sum_check "$CORE_OPTS_CFG_SOURCE" "$machine")
	md5sum_check_config_echo=$(md5sum_check "$etc_retroarch_config_dir" "$machine")

	if [[ "$md5sum_check_cfg_echo" = "0" ]] && [[ "$md5sum_check_retroarch_cfg_echo" = "0" ]] && [[ "$md5sum_check_retroarch_core_opts_echo" = "0" ]] \
		&& [[ "$md5sum_check_config_echo" = "0" ]]; then
		exit_zero "${SCRIPT_NAME}: ${machine} nothing new"
	fi

	# set MACHINE_CFG_DIRs
	if [[ "$machine" = "retropad" ]]; then
		MACHINE_CFG_DIR="${cfg_dir}/mirror/${machine}/home/ark/.config/retroarch/config"
	elif [[ "$machine" = "retro"* ]]; then
		MACHINE_CFG_DIR="${cfg_dir}/mirror/${machine}/opt/retropie/configs/all/retroarch/config"
	elif [[ "$machine" = "a500" ]]; then
		MACHINE_CFG_DIR="${cfg_dir}/mirror/${machine}/Pandory/.user/.config/retroarch/config"
	elif [[ "$machine" = "psclassic" ]]; then
		MACHINE_CFG_DIR="${cfg_dir}/mirror/${machine}/retroarch/config"
	elif [[ "$machine" = "segamini" ]]; then
		MACHINE_CFG_DIR="${cfg_dir}/mirror/${machine}/hakchi/libretro/config"
	fi

	# set RETROARCH_DIRs
	if [[ "$machine" = "retropad" ]]; then
		RETROARCH_DIR="~\/\.config\/retroarch"
	elif [[ "$machine" = "retro"* ]]; then
		RETROARCH_DIR="\/opt\/retropie\/configs\/all\/retroarch"
	elif [[ "$machine" = "a500" ]]; then
		RETROARCH_DIR="~\/\.config\/retroarch"
	elif [[ "$machine" = "psclassic" ]]; then
		RETROARCH_DIR=":"
	elif [[ "$machine" = "segamini" ]]; then
		RETROARCH_DIR="~"
	fi

	echo "${SCRIPT_NAME}: ${machine} - cleaning machine cfgs"
	rm -rf "${MACHINE_CFG_DIR:?}/"*
}

check_retrotg16_systems() {
	local machine="$1"
	local system="$2"

	[[ "$machine" = "retrotg16" ]] && [[ "$system" != "mastersystem" ]] && [[ "$system" != "nes" ]] && [[ "$system" != "pcengine" ]] && [[ "$system" != "pce-cd" ]] && echo "0" || echo "1"
}

core_options_gen() {
	local corename="$1"
	local corename_orig
	local machine="$2"
	local opt_file
	local system="$3"
	local system_no_under="$4"

	echo "${SCRIPT_NAME}: ${machine} - core options generate - ${corename}"

	if [[ "$machine" = "retro"* ]]; then
		opt_file="${MACHINE_CFG_DIR}/${corename}/${system_no_under}.opt"
	else
		opt_file="${MACHINE_CFG_DIR}/${corename}/${corename}.opt"
	fi

	corename_orig="${SYSTEM_RETRO_CORENAMES[$system]}"

	if printf '%s\0' "${!CORENAME_CORE_OPTIONS[@]}" | grep -Fxqz "$corename_orig"; then
		grep "${CORENAME_CORE_OPTIONS[$corename_orig]}" "$CORE_OPTS_CFG_SOURCE" > "$opt_file"
	else
		# Create an empty core options file. This is to prevent the global core options from being erroneously populated.
		true > "$opt_file"
	fi

	if [[ "$machine" = "retrotg16" ]] && [[ "$system" = "pcengine" ]]; then
		cp "$opt_file" "${MACHINE_CFG_DIR}/${corename}/supergrafx.opt"
		cp "$opt_file" "${MACHINE_CFG_DIR}/${corename}/tg-cd.opt"
		cp "$opt_file" "${MACHINE_CFG_DIR}/${corename}/tg16.opt"
	fi
}

exit_zero() {
	echo "$1"
	exit 0
}

machine_cfg_dir_get() {
	local dir="$1"
	local machine="$2"

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
	local dir="$1"
	local machine="$2"

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
	local machine="$1"

	echo "${SCRIPT_NAME}: ${machine} - retroarch dir replace"
	sed -i "s/\$RETROARCH_DIR/${RETROARCH_DIR}/g" "${MACHINE_CFG_DIR}"/*/*.cfg
}

turbo_button_replace() {
	local machine="$1"

	echo "${SCRIPT_NAME}: ${machine} - turbo button replace - a"
	sed -i "s/_turbo_btn = \"a\"/_turbo_btn = \"${INPUT_TURBO_BTN_VALUES[${machine};a]}\"/g" "${MACHINE_CFG_DIR}"/*/*.cfg
	echo "${SCRIPT_NAME}: ${machine} - turbo button replace - b"
	sed -i "s/_turbo_btn = \"b\"/_turbo_btn = \"${INPUT_TURBO_BTN_VALUES[${machine};b]}\"/g" "${MACHINE_CFG_DIR}"/*/*.cfg
	echo "${SCRIPT_NAME}: ${machine} - turbo button replace - x"
	sed -i "s/_turbo_btn = \"x\"/_turbo_btn = \"${INPUT_TURBO_BTN_VALUES[${machine};x]}\"/g" "${MACHINE_CFG_DIR}"/*/*.cfg
	echo "${SCRIPT_NAME}: ${machine} - turbo button replace - y"
	sed -i "s/_turbo_btn = \"y\"/_turbo_btn = \"${INPUT_TURBO_BTN_VALUES[${machine};y]}\"/g" "${MACHINE_CFG_DIR}"/*/*.cfg
	echo "${SCRIPT_NAME}: ${machine} - turbo button replace - m"
	sed -i "s/_turbo_btn = \"m\"/_turbo_btn = \"${INPUT_TURBO_BTN_VALUES[${machine};m]}\"/g" "${MACHINE_CFG_DIR}"/*/*.cfg
}

# main function
main() {
	local cfg_dir="$1"
	local check_retrotg16_systems_echo
	local corename
	local etc_retroarch_config_dir
	local machine="$2"
	local md5sum_check_echo
	local system
	local system_no_under

	# check inputs
	[[ "$cfg_dir" = "" ]] && echo "Missing cfg_dir" && exit 1
	[[ "$machine" = "" ]] && echo "Missing machine" && exit 1

	if [[ -d "${SCRIPT_DIR}/etc/retroarch/${machine}" ]]; then
		etc_retroarch_config_dir="${SCRIPT_DIR}/etc/retroarch/${machine}/config"
	else
		etc_retroarch_config_dir="${SCRIPT_DIR}/etc/retroarch/config"
	fi

	check_new_clean "$cfg_dir" "$etc_retroarch_config_dir" "$machine"
	all_cfg_cp "$etc_retroarch_config_dir" "$machine" "$system"

	if [[ "$machine" != "retrotg16" ]]; then
		turbo_button_replace "$machine"
		retroarch_dir_replace "$machine"
	fi

	for system in "${!SYSTEM_RETRO_CORENAMES[@]}"; do
		check_retrotg16_systems_echo=$(check_retrotg16_systems "$machine" "$system")
		[[ "$check_retrotg16_systems_echo" = "0" ]] && continue

		corename=$(machine_cfg_dir_get "${SYSTEM_RETRO_CORENAMES[$system]}" "$machine")
		system_no_under="${system%_*}"

		mkdir -p "${MACHINE_CFG_DIR}/${corename}"
		[[ "$machine" = "retro"* ]] && cp "${SCRIPT_DIR}/etc/retroarch/retroarch-${machine}.cfg" "${MACHINE_CFG_DIR}/${corename}/${corename}.cfg"
		core_options_gen "$corename" "$machine" "$system" "$system_no_under"
	done

	# create new md5sum
	md5sum_check_echo=$(md5sum_check "${SCRIPT_DIR}/${SCRIPT_NAME}" "$machine")
}

main "${@}"
