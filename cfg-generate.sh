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
declare dir_cfg
declare machine
declare machine_cfg_dir
declare system
declare system_no_under

readonly -A input_turbo_default_values=(
	["a"]="2"
	["b"]="0"
	["x"]="3"
	["y"]="1"
)

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

	echo "${script_name}: ${machine} - cleaning machine cfgs"
	rm -rf "${machine_cfg_dir:?}/"*
}

cfg_init() {
	mkdir -p "${machine_cfg_dir}/${corename}"
	dir_cfg="${machine_cfg_dir}/${corename}/${system}.cfg"
}

core_cfg_gen() {
	cp "${script_dir}/etc/retroarch/retroarch-${machine}.cfg" "${machine_cfg_dir}/${corename}/${corename}.cfg"
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

dir_cfg_y_turbo() {
	if printf '%s\0' "${y_turbo_systems[@]}" | grep -Fxqz "${system}"; then
		echo "${script_name}: ${machine} - dir cfg y turbo - ${system}"

		local cfg_value="${input_btn_values[${machine};y]}"
		echo "input_player1_turbo_btn = \"${cfg_value}\"" >> "$dir_cfg"
		echo "input_player2_turbo_btn = \"${cfg_value}\"" >> "$dir_cfg"
	fi
}

machine_cfg_dir_get() {
	local dir="$1"

	if [[ "$machine" != "retro"* ]] && printf '%s\0' "${!miniclassics_cfg_dirs[@]}" | grep -Fxqz "$dir"; then
		echo "${miniclassics_cfg_dirs[$dir]}"
	else
		echo "$dir"
	fi
}

machine_remaps_dir_get() {
	local dir="$1"

	if [[ "$machine" != "retro"* ]] && printf '%s\0' "${!miniclassics_remaps_dirs[@]}" | grep -Fxqz "$dir"; then
		echo "${miniclassics_remaps_dirs[$dir]}"
	else
		echo "$dir"
	fi
}

machine_cfg_gen() {
	local m
	for m in "${machine_cfgs[@]}"; do
		IFS=';' read -ra machine_cfg <<< "$m"
		local cfg_machine="${machine_cfg[0]}"
		local cfg_system="${machine_cfg[1]}"
		local cfg_name="${machine_cfg[2]}"
		local cfg_button="${machine_cfg[3]}"
		local cfg_value

		[[ "$cfg_machine" = "$machine" ]] || continue
		echo "${script_name}: ${cfg_machine} - machine cfg - ${cfg_system}"

		if [[ "${cfg_name}" = "input_turbo_default_button" ]]; then
			cfg_value="${input_turbo_default_values[$cfg_button]}"
		else
			cfg_value="${input_btn_values[${cfg_machine};${cfg_button}]}"
		fi

		corename=$(machine_cfg_dir_get "${system_retro_corenames[$cfg_system]}")
		mkdir -p "${machine_cfg_dir}/${corename}"
		local cfg_file="${machine_cfg_dir}/${corename}/${cfg_system}.cfg"

		echo "${cfg_name} = \"${cfg_value}\"" >> "$cfg_file"

		if [[ "${cfg_name}" = "input_player1_turbo_btn" ]]; then
			echo "input_player2_turbo_btn = \"${cfg_value}\"" >> "$cfg_file"
		fi
	done
}

rom_cfg_y_turbo() {
	local c
	for c in "${y_turbo_rom_cfgs[@]}"; do
		IFS=';' read -ra y_turbo_rom_cfg <<< "$c"
		local cfg_y_system="${y_turbo_rom_cfg[0]}"
		local cfg_rom="${y_turbo_rom_cfg[1]}"
		local cfg_value="${input_btn_values[${machine};y]}"

		echo "${script_name}: ${machine} - rom y turbo - ${cfg_rom}"

		corename=$(machine_cfg_dir_get "${system_retro_corenames[$cfg_y_system]}")
		mkdir -p "${machine_cfg_dir}/${corename}"
		local cfg_file="${machine_cfg_dir}/${corename}/${cfg_rom}.cfg"

		echo "input_player1_turbo_btn = \"${cfg_value}\"" >> "$cfg_file"
		echo "input_player2_turbo_btn = \"${cfg_value}\"" >> "$cfg_file"
	done
}

rom_cfg() {
	local i
	for i in "${!rom_cfgs[@]}"; do
		IFS=';' read -ra rom_cfg <<< "$i"
		local cfg_system="${rom_cfg[0]}"
		local cfg_rom="${rom_cfg[1]}"
		local cfg_name="${rom_cfg[2]}"
		local cfg_value

		echo "${script_name}: ${machine} - ${cfg_name} - ${cfg_rom}"

		if [[ "${cfg_name}" = "input_turbo_default_button" ]]; then
			cfg_value="${input_turbo_default_values[${rom_cfgs[$i]}]}"
		else
			cfg_value="${input_btn_values[${machine};${rom_cfgs[$i]}]}"
		fi

		corename=$(machine_cfg_dir_get "${system_retro_corenames[$cfg_system]}")
		mkdir -p "${machine_cfg_dir}/${corename}"
		local cfg_file="${machine_cfg_dir}/${corename}/${cfg_rom}.cfg"

		echo "${cfg_name} = \"${cfg_value}\"" >> "$cfg_file"

		if [[ "${cfg_name}" = "input_player1_turbo_btn" ]]; then
			echo "input_player2_turbo_btn = \"${cfg_value}\"" >> "$cfg_file"
		fi
	done
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

	for system in "${!system_retro_corenames[@]}"; do
		corename=$(machine_cfg_dir_get "${system_retro_corenames[$system]}")
		system_no_under="${system%_*}"

		cfg_init
		[[ "$machine" = "retro"* ]] && core_cfg_gen
		dir_cfg_y_turbo
		core_options_gen
	done

	machine_cfg_gen
	rom_cfg_y_turbo
	rom_cfg

	# create new md5sum
	local md5sum_check_echo
	md5sum_check_echo=$(md5sum_check "${script_dir}/${script_name}" "$machine")
}

main "${@}"
