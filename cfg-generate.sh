#!/bin/bash

# settings
set -o pipefail
[[ "${TRACE-0}" = "1" ]] && set -o xtrace

# variables
declare script_name
script_name="$(basename "${0}")"
declare script_dir
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

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

# helper functions
all_cfg_cp() {
	local c
	for c in "${script_dir}/etc/retroarch/config/"*/; do
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

	if [[ "$md5sum_check_cfg_echo" = "0" ]] && [[ "$md5sum_check_retroarch_cfg_echo" = "0" ]] && [[ "$md5sum_check_retroarch_core_opts_echo" = "0" ]]; then
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
}

machine_cfg_dir_get() {
	local dir="$1"

	if [[ "$machine" = "retropad" ]] && printf '%s\0' "${!retropad_cfg_dirs[@]}" | grep -Fxqz "$dir"; then
		echo "${retropad_cfg_dirs[$dir]}"
	elif [[ "$machine" = "segamini" ]] && printf '%s\0' "${!segamini_cfg_dirs[@]}" | grep -Fxqz "$dir"; then
		echo "${segamini_cfg_dirs[$dir]}"
	elif [[ "$machine" != "retro"* ]] && printf '%s\0' "${!miniclassics_cfg_dirs[@]}" | grep -Fxqz "$dir"; then
		echo "${miniclassics_cfg_dirs[$dir]}"
	else
		echo "$dir"
	fi
}

machine_remaps_dir_get() {
	local dir="$1"

	if [[ "$machine" = "retropad" ]] && printf '%s\0' "${!retropad_cfg_dirs[@]}" | grep -Fxqz "$dir"; then
		echo "${retropad_cfg_dirs[$dir]}"
	if [[ "$machine" = "segamini" ]] && printf '%s\0' "${!segamini_cfg_dirs[@]}" | grep -Fxqz "$dir"; then
		echo "${segamini_cfg_dirs[$dir]}"
	elif [[ "$machine" != "retro"* ]] && printf '%s\0' "${!miniclassics_cfg_dirs[@]}" | grep -Fxqz "$dir"; then
		echo "${miniclassics_cfg_dirs[$dir]}"
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
	sed -i "s/_turbo_btn = \"a\"/_turbo_btn = \"${input_turbo_btn_values[${machine};a]}\"/g" "${machine_cfg_dir}"/*/*.cfg
	echo "${script_name}: ${machine} - turbo button replace - b"
	sed -i "s/_turbo_btn = \"b\"/_turbo_btn = \"${input_turbo_btn_values[${machine};b]}\"/g" "${machine_cfg_dir}"/*/*.cfg
	echo "${script_name}: ${machine} - turbo button replace - x"
	sed -i "s/_turbo_btn = \"x\"/_turbo_btn = \"${input_turbo_btn_values[${machine};x]}\"/g" "${machine_cfg_dir}"/*/*.cfg
	echo "${script_name}: ${machine} - turbo button replace - y"
	sed -i "s/_turbo_btn = \"y\"/_turbo_btn = \"${input_turbo_btn_values[${machine};y]}\"/g" "${machine_cfg_dir}"/*/*.cfg
	echo "${script_name}: ${machine} - turbo button replace - m"
	sed -i "s/_turbo_btn = \"m\"/_turbo_btn = \"${input_turbo_btn_values[${machine};m]}\"/g" "${machine_cfg_dir}"/*/*.cfg
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
	turbo_button_replace
	retroarch_dir_replace

	for system in "${!system_retro_corenames[@]}"; do
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
