#!/bin/bash

# settings
set -o pipefail
[[ "${TRACE-0}" = "1" ]] && set -o xtrace

# variables
declare script_name
script_name="$(basename "${0}")"
declare script_dir
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

declare cfg_dir
declare core_opts_cfg_source
declare dir_cfg
declare machine
declare machine_cfg_dir

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
	echo "${script_name}: ${machine} - copying all cfgs"
	cp -r "${script_dir}/sync/mirror/all/retroarch/config/"* "$machine_cfg_dir"
}

check_new_clean() {
	if [[ "$machine" = "retro"* ]]; then
		core_opts_cfg_source="${script_dir}/etc/retroarch/retroarch-core-options-retropie.cfg"
	else
		core_opts_cfg_source="${script_dir}/etc/retroarch/retroarch-core-options-miniclassics.cfg"
	fi

	local md5sum_check_cfg_echo
	md5sum_check_cfg_echo=$(md5sum_check "${script_dir}/lib/cfg.sh" "$machine")
	local md5sum_check_retroarch_cfg_echo
	md5sum_check_retroarch_cfg_echo=$(md5sum_check "${script_dir}/etc/retroarch/retroarch-${machine}.cfg")
	local md5sum_check_retroarch_core_opts_echo
	md5sum_check_retroarch_core_opts_echo=$(md5sum_check "$core_opts_cfg_source" "$machine")

	if [[ "$md5sum_check_cfg_echo" = "0" ]] && [[ "$md5sum_check_retroarch_cfg_echo" = "0" ]] && [[ "$md5sum_check_retroarch_core_opts_echo" = "0" ]]; then
		echo "${script_name}: ${machine} nothing new"
		exit 0
	fi

	if [[ "$machine" = "retro"* ]]; then
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
	mkdir -p "${machine_cfg_dir}/${system_retro_corenames[${system//_/-}]}"
	dir_cfg="${machine_cfg_dir}/${system_retro_corenames[${system//_/-}]}/${system//_/-}.cfg"
}

core_cfg_gen() {
	local core_cfg
	core_cfg="${machine_cfg_dir}/${system_retro_corenames[${system//_/-}]}/${system_retro_corenames[${system//_/-}]}.cfg"
	cp "${script_dir}/etc/retroarch/retroarch-${machine}.cfg" "$core_cfg"
}

core_options_gen() {
	cp "$core_opts_cfg_source" "${machine_cfg_dir}/${system_retro_corenames[${system//_/-}]}/${system_retro_corenames[${system//_/-}]}.opt"
}

dir_cfg_y_turbo() {
	if printf '%s\0' "${y_turbo_systems[@]}" | grep -Fxqz "${system//_/-}"; then
		echo "${script_name}: ${machine} - dir cfg y turbo - ${system}"

		value="${input_btn_values[${machine};y]}"
		echo "input_player1_turbo_btn = \"${value}\"" >> "$dir_cfg"
		echo "input_player2_turbo_btn = \"${value}\"" >> "$dir_cfg"

		if [[ "$system" = "scv" ]]; then
			echo "${script_name}: ${machine} - duty cycle, period - ${system}"
			echo "input_duty_cycle = \"6\"" >> "$dir_cfg"
			echo "input_turbo_period = \"12\"" >> "$dir_cfg"
		fi
	fi
}

dir_cfg_gen() {
	local cfg_value

	local cfg_type
	for cfg_type in "${cfg_types[@]}"; do
		eval button_value="( \${${machine}_${system}_${cfg_type}} )"

		[[ -z "${button_value}" ]] && continue

		echo "${script_name}: ${machine} - dir cfg - ${system}"

		if [[ "${cfg_type}" = "input_turbo_default_button" ]]; then
			cfg_value="${input_turbo_default_values[${button_value}]}"
		else
			cfg_value="${input_btn_values[${machine};${button_value}]}"
		fi

		echo "${cfg_type} = \"${cfg_value}\"" >> "$dir_cfg"

		if [[ "${cfg_type}" = "input_player1_turbo_btn" ]]; then
			echo "input_player2_turbo_btn = \"${cfg_value}\"" >> "$dir_cfg"
		fi
	done
}

rom_cfg_y_turbo() {
	local c
	for c in "${y_turbo_rom_cfgs[@]}"; do
		IFS=';' read -ra y_turbo_rom_cfg <<< "$c"
		local system="${y_turbo_rom_cfg[0]}"
		local rom="${y_turbo_rom_cfg[1]}"
		local value="${input_btn_values[${machine};y]}"
		local cfg

		echo "${script_name}: ${machine} - rom y turbo - ${rom}"		

		mkdir -p "${machine_cfg_dir}/${system_retro_corenames[$system]}"
		cfg="${machine_cfg_dir}/${system_retro_corenames[$system]}/${rom}.cfg"

		echo "input_player1_turbo_btn = \"${value}\"" >> "$cfg"
		echo "input_player2_turbo_btn = \"${value}\"" >> "$cfg"
	done
}

rom_cfg() {
	local i
	for i in "${!rom_cfgs[@]}"; do
		IFS=';' read -ra rom_cfg <<< "$i"
		local system="${rom_cfg[0]}"
		local rom="${rom_cfg[1]}"
		local cfg="${rom_cfg[2]}"
		local value
		local cfg_file

		echo "${script_name}: ${machine} - ${cfg} - ${rom}"

		if [[ "${cfg}" = "input_turbo_default_button" ]]; then
			value="${input_turbo_default_values[${rom_cfgs[$i]}]}"
		else
			value="${input_btn_values[${machine};${rom_cfgs[$i]}]}"
		fi

		mkdir -p "${machine_cfg_dir}/${system_retro_corenames[$system]}"
		cfg_file="${machine_cfg_dir}/${system_retro_corenames[$system]}/${rom}.cfg"

		echo "${cfg} = \"${value}\"" >> "$cfg_file"

		if [[ "${cfg}" = "input_player1_turbo_btn" ]]; then
			echo "input_player2_turbo_btn = \"${value}\"" >> "$cfg_file"
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

	for system in "${!system_retro_corenames[@]}"; do
		# since these can become variable names using reflection, replace dashes with underscores
		system=${system//-/_}
		cfg_init
		core_cfg_gen
		dir_cfg_y_turbo
		dir_cfg_gen
		core_options_gen
	done

	rom_cfg_y_turbo
	rom_cfg
	all_cfg_cp

	# create new md5sum
	local md5sum_check_echo
	md5sum_check_echo=$(md5sum_check "${script_dir}/${script_name}" "$machine")
}

main "${@}"
