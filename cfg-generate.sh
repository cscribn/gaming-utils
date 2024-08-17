#!/bin/bash

# settings
set -o pipefail
[[ "${TRACE-0}" = "1" ]] && set -o xtrace

# global variables
declare script_name
script_name="$(basename "${0}")"
declare script_dir
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

readonly -A a500_cfg_dirs=(
	["Mupen64Plus GLES3"]="Mupen64Plus GLES2"
	["Mupen64Plus-Next"]="Mupen64 Xtreme Amped"
	["Opera"]="Opera Xtreme"
	["PrBoom"]="PrBoom Xtreme"
	["PUAE 2021"]="P-UAE Xtreme"
	["Stella"]="Stella 2014"
	["VICE x64"]="VICE Xtreme x64"
)
readonly -A corename_core_options=(
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
readonly -A psclassic_cfg_dirs=(
	["Mupen64Plus GLES3"]="Mupen64Plus GLES2"
	["Mupen64Plus-Next"]="Mupen64Plus-Next GLES3"
	["Opera"]="Opera Xtreme"
	["PrBoom"]="PrBoom Xtreme"
	["PUAE 2021"]="P-UAE Xtreme"
	["VICE x64"]="VICE Xtreme x64"
)
readonly -A segamini_cfg_dirs=(
	["Mupen64Plus GLES3"]="Mupen64Plus GLES2"
	["Mupen64Plus-Next"]="Mupen64Plus-Next GLES2"
	["Opera"]="Opera Xtreme"
	["PrBoom"]="PrBoom Xtreme"
	["PUAE 2021"]="P-UAE Xtreme"
	["Stella"]="Stella 2014"
	["VICE x64"]="VICE Xtreme x64"
)
readonly -A retropad_cfg_dirs=(
	["Mupen64Plus GLES3"]="Mupen64Plus GLES2"
)
readonly -A system_retro_corenames=(
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
source "${script_dir}/lib/cfg.sh" > /dev/null 2>&1 || ( echo "Missing ./lib/cfg.sh" && exit 1 )
source "${script_dir}/lib/utils.sh"

# usage
if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    echo "Usage: ${script_name} cfg_dir machine"
	echo "./lib/cfg.sh needs to be present (see ./lib/cfg.sample.sh)"
    exit
fi

# functions
all_cfg_cp() {
	local c
	for c in "${script_dir}/etc/retroarch/config/"*/; do
		[[ "$machine" = "retrotg16" ]] && [[ "$system" != "pcengine" ]] && [[ "$system" != "pce-cd" ]] && continue

		c=$(basename "$c")
		[[ "$c" = "remaps" ]] && continue

		local new_c
		new_c=$(machine_cfg_dir_get "$c")

		echo "${script_name}: ${machine} - copying cfgs - ${new_c}"
		mkdir -p "${machine_cfg_dir}/${new_c}"
		cp "${script_dir}/etc/retroarch/config/${c}/"* "${machine_cfg_dir}/${new_c}"
	done

	local r
	for r in "${script_dir}/etc/retroarch/config/remaps/"*/; do
		[[ "$machine" = "retrotg16" ]] && [[ "$system" != "pcengine" ]] && [[ "$system" != "pce-cd" ]] && continue

		r=$(basename "$r")
		local new_r
		new_r=$(machine_remaps_dir_get "$r")

		echo "${script_name}: ${machine} - copying remaps - ${new_r}"
		mkdir -p "${machine_cfg_dir}/remaps/${new_r}"
		cp "${script_dir}/etc/retroarch/config/remaps/${r}/"* "${machine_cfg_dir}/remaps/${new_r}"
	done
}

check_new_clean() {
	if [[ "$machine" = "retro"* ]]; then
		core_opts_cfg_source="${script_dir}/etc/retroarch/retroarch-core-options-sbc.cfg"
	else
		core_opts_cfg_source="${script_dir}/etc/retroarch/retroarch-core-options-miniclassics.cfg"
	fi

	local md5sum_check_cfg_echo
	md5sum_check_cfg_echo=$(md5sum_check "${script_dir}/lib/cfg.sh" "$machine")
	local md5sum_check_retroarch_cfg_echo="0"

	# only perform md5sum check in this script for retro* machines
	[[ "$machine" = "retro"* ]] && md5sum_check_retroarch_cfg_echo=$(md5sum_check "${script_dir}/etc/retroarch/retroarch-${machine}.cfg")

	local md5sum_check_retroarch_core_opts_echo
	md5sum_check_retroarch_core_opts_echo=$(md5sum_check "$core_opts_cfg_source" "$machine")

	local md5sum_check_config_echo
	md5sum_check_config_echo=$(md5sum_check "${script_dir}/etc/retroarch/config" "$machine")

	if [[ "$md5sum_check_cfg_echo" = "0" ]] && [[ "$md5sum_check_retroarch_cfg_echo" = "0" ]] && [[ "$md5sum_check_retroarch_core_opts_echo" = "0" ]] \
		&& [[ "$md5sum_check_config_echo" = "0" ]]; then
		echo "${script_name}: ${machine} nothing new"
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

	echo "${script_name}: ${machine} - cleaning machine cfgs"
	rm -rf "${machine_cfg_dir:?}/"*
}

core_options_gen() {
	echo "${script_name}: ${machine} - core options generate - ${corename}"

	local opt_file
	if [[ "$machine" = "retro"* ]]; then
		opt_file="${machine_cfg_dir}/${corename}/${system_no_under}.opt"
	else
		opt_file="${machine_cfg_dir}/${corename}/${corename}.opt"
	fi

	local corename_orig="${system_retro_corenames[$system]}"

	if printf '%s\0' "${!corename_core_options[@]}" | grep -Fxqz "$corename_orig"; then
		grep "${corename_core_options[$corename_orig]}" "$core_opts_cfg_source" > "$opt_file"
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
	local dir="$1"

	if [[ "$machine" = "a500" ]] && printf '%s\0' "${!a500_cfg_dirs[@]}" | grep -Fxqz "$dir"; then
		echo "${a500_cfg_dirs[$dir]}"
	elif [[ "$machine" = "psclassic" ]] && printf '%s\0' "${!psclassic_cfg_dirs[@]}" | grep -Fxqz "$dir"; then
		echo "${psclassic_cfg_dirs[$dir]}"
	elif [[ "$machine" = "retropad" ]] && printf '%s\0' "${!retropad_cfg_dirs[@]}" | grep -Fxqz "$dir"; then
		echo "${retropad_cfg_dirs[$dir]}"
	elif [[ "$machine" = "segamini" ]] && printf '%s\0' "${!segamini_cfg_dirs[@]}" | grep -Fxqz "$dir"; then
		echo "${segamini_cfg_dirs[$dir]}"
	else
		echo "$dir"
	fi
}

machine_remaps_dir_get() {
	local dir="$1"

	if [[ "$machine" = "a500" ]] && printf '%s\0' "${!a500_cfg_dirs[@]}" | grep -Fxqz "$dir"; then
		echo "${a500_cfg_dirs[$dir]}"
	elif [[ "$machine" = "psclassic" ]] && printf '%s\0' "${!psclassic_cfg_dirs[@]}" | grep -Fxqz "$dir"; then
		echo "${psclassic_cfg_dirs[$dir]}"
	elif [[ "$machine" = "retropad" ]] && printf '%s\0' "${!retropad_cfg_dirs[@]}" | grep -Fxqz "$dir"; then
		echo "${retropad_cfg_dirs[$dir]}"
	elif [[ "$machine" = "segamini" ]] && printf '%s\0' "${!segamini_cfg_dirs[@]}" | grep -Fxqz "$dir"; then
		echo "${segamini_cfg_dirs[$dir]}"
	else
		echo "$dir"
	fi
}

retroarch_dir_replace() {
	echo "${script_name}: ${machine} - retroarch dir replace"
	sed -i "s/\$RETROARCH_DIR/${retroarch_dir}/g" "${machine_cfg_dir}"/*/*.cfg
}

turbo_button_replace() {
	echo "${script_name}: ${machine} - turbo button replace - a"
	sed -i "s/_turbo_btn = \"a\"/_turbo_btn = \"${INPUT_TURBO_BTN_VALUES[${machine};a]}\"/g" "${machine_cfg_dir}"/*/*.cfg
	echo "${script_name}: ${machine} - turbo button replace - b"
	sed -i "s/_turbo_btn = \"b\"/_turbo_btn = \"${INPUT_TURBO_BTN_VALUES[${machine};b]}\"/g" "${machine_cfg_dir}"/*/*.cfg
	echo "${script_name}: ${machine} - turbo button replace - x"
	sed -i "s/_turbo_btn = \"x\"/_turbo_btn = \"${INPUT_TURBO_BTN_VALUES[${machine};x]}\"/g" "${machine_cfg_dir}"/*/*.cfg
	echo "${script_name}: ${machine} - turbo button replace - y"
	sed -i "s/_turbo_btn = \"y\"/_turbo_btn = \"${INPUT_TURBO_BTN_VALUES[${machine};y]}\"/g" "${machine_cfg_dir}"/*/*.cfg
	echo "${script_name}: ${machine} - turbo button replace - m"
	sed -i "s/_turbo_btn = \"m\"/_turbo_btn = \"${INPUT_TURBO_BTN_VALUES[${machine};m]}\"/g" "${machine_cfg_dir}"/*/*.cfg
}

# main function
main() {
	# check inputs
	cfg_dir="$1"
	[[ "$cfg_dir" = "" ]] && echo "Missing cfg_dir" && exit 1

	machine="$2"
	[[ "$machine" = "" ]] && echo "Missing machine" && exit 1

	check_new_clean
	all_cfg_cp
	[[ "$machine" != "retrotg16" ]] && turbo_button_replace
	[[ "$machine" != "retrotg16" ]] && retroarch_dir_replace

	for system in "${!system_retro_corenames[@]}"; do
		[[ "$machine" = "retrotg16" ]] && [[ "$system" != "pcengine" ]] && [[ "$system" != "pce-cd" ]] && continue

		corename=$(machine_cfg_dir_get "${system_retro_corenames[$system]}")
		system_no_under="${system%_*}"

		mkdir -p "${machine_cfg_dir}/${corename}"
		[[ "$machine" = "retro"* ]] && cp "${script_dir}/etc/retroarch/retroarch-${machine}.cfg" "${machine_cfg_dir}/${corename}/${corename}.cfg"
		core_options_gen
	done

	# create new md5sum
	local md5sum_check_echo
	md5sum_check_echo=$(md5sum_check "${script_dir}/${script_name}" "$machine")
}

main "${@}"
