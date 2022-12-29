#!/bin/bash

# settings
set -o errexit
set -o pipefail
[[ "${TRACE-0}" = "1" ]] && set -o xtrace

# include
source ./bin/_lib-cfg.sh > /dev/null 2>&1 || ( echo "Missing _lib-cfg.sh" && exit 1 )
source ./_lib-utils.sh

# variables
declare script_name
script_name=$(basename "${0}")
declare script_real
script_real=$(realpath "${0}")
declare cfg_dir
declare machine

readonly -A input_turbo_default_values=(
	["a"]="2"
	["b"]="0"
	["x"]="3"
	["y"]="1"
)

readonly retroarch_cfg_dir="opt/retropie/configs/all/retroarch/config"
declare -a rom_cfgs_done=()
declare system_cfg

# usage
if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    echo "Usage: ${script_name} cfg_dir machine"
	echo "./bin/_lib-cfg.sh needs to be present (see ./_lib-cfg.example.sh)"
    exit
fi

# helper functions
check_new() {
	local md5sum_check_echo=$(md5sum_check "$script_real" "$machine")

	if [[ "$md5sum_check_echo" = "0" ]]; then
		echo "${script_name}: ${machine} nothing new" && exit 0
	else
		echo "${script_name}: ${machine} - cleaning cfgs"
		rm -rf "${cfg_dir:?}/${machine}/opt/retropie/configs/"*
	fi
}

init() {
	local ports=""

	if [[ "$system" = "doom" ]] || [[ "$system" = "quake" ]]; then
		ports="ports/"
	fi

	local cfg_path="${cfg_dir}/${machine}/opt/retropie/configs/${ports}${system/_/-}"
	mkdir -p "${cfg_path}"
	system_cfg="${cfg_path}/retroarch.cfg"
}

system_cfg_header() {
	{
		echo "# Settings made here will only override settings in the global retroarch.cfg if placed above the #include line"
		echo ""
	} >> "$system_cfg"
}

system_cfg_y_turbo() {
	if printf '%s\0' "${y_turbo_systems[@]}" | grep -Fxqz "${system/_/-}"; then
		value="${input_btn_values[${machine};y]}"
		echo "input_player1_turbo_btn = \"${value}\"" >> "$system_cfg"
		echo "input_player2_turbo_btn = \"${value}\"" >> "$system_cfg"
	fi
}

system_cfg() {
	local cfg_value

	local cfg_type
	for cfg_type in "${cfg_types[@]}"; do
		eval button_value="( \${${machine}_${system}_${cfg_type}} )"

		if [[ -z "${button_value}" ]]; then
			continue
		fi

		if [[ "${cfg_type}" = "input_turbo_default_button" ]]; then
			cfg_value="${input_turbo_default_values[${button_value}]}"
		else
			cfg_value="${input_btn_values[${machine};${button_value}]}"
		fi

		echo "${cfg_type} = \"${cfg_value}\"" >> "$system_cfg"

		if [[ "${cfg_type}" = "input_player1_turbo_btn" ]]; then
			echo "input_player2_turbo_btn = \"${cfg_value}\"" >> "$system_cfg"
		fi
	done
}

system_cfg_footer() {
	{
		echo ""
		echo "#include \"/opt/retropie/configs/all/retroarch.cfg\""
	} >> "$system_cfg"

	echo "${script_name}: ${machine} - system - ${system}"
}

rom_cfg_y_turbo() {
	local c
	for c in "${y_turbo_rom_cfgs[@]}"; do
		IFS=';' read -ra y_turbo_rom_cfg <<< "$c"
		local system="${y_turbo_rom_cfg[0]}"
		local rom="${y_turbo_rom_cfg[1]}"
		local value="${input_btn_values[${machine};y]}"
		local cfg

		mkdir -p "${cfg_dir}/${machine}/${retroarch_cfg_dir}/${system_retro_corenames[$system]}"
		cfg="${cfg_dir}/${machine}/${retroarch_cfg_dir}/${system_retro_corenames[$system]}/${rom}.cfg"

		echo "input_player1_turbo_btn = \"${value}\"" >> "$cfg"
		echo "input_player2_turbo_btn = \"${value}\"" >> "$cfg"

		echo "${script_name}: ${machine} - rom y turbo - ${rom}"
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

		if [[ "${cfg}" = "input_turbo_default_button" ]]; then
			value="${input_turbo_default_values[${rom_cfgs[$i]}]}"
		else
			value="${input_btn_values[${machine};${rom_cfgs[$i]}]}"
		fi

		mkdir -p "${cfg_dir}/${machine}/${retroarch_cfg_dir}/${system_retro_corenames[$system]}"
		cfg_file="${cfg_dir}/${machine}/${retroarch_cfg_dir}/${system_retro_corenames[$system]}/${rom}.cfg"

		if [[ -f "/c/Users/Chad/Gaming/bin/roms-cfg/${system}/${rom}.cfg" ]] && ! printf '%s\0' "${rom_cfgs[@]}" | grep -Fxqz "${machine};${system};${rom}"; then
			cat "/c/Users/Chad/Gaming/bin/roms-cfg/${system}/${rom}.cfg" >> "$cfg"
			rom_cfgs_done+=("${machine};${system};${rom}")
		fi

		echo "${cfg} = \"${value}\"" >> "$cfg_file"

		if [[ "${cfg}" = "input_player1_turbo_btn" ]]; then
			echo "input_player2_turbo_btn = \"${value}\"" >> "$cfg_file"
		fi

		echo "${script_name}: ${machine} - ${cfg} - ${rom}"
	done
}

# main function
main() {
	# check inputs
	cfg_dir="$1"
	[[ "$cfg_dir" = "" ]] && echo "Missing cfg_dir" && exit 1

	machine="$2"
	[[ "$machine" = "" ]] && echo "Missing machine" && exit 1

	check_new

	local system_underscores
	for system_underscores in "${systems_underscores[@]}"; do
		system="$system_underscores"
		init
		system_cfg_header
		system_cfg_y_turbo
		system_cfg
		system_cfg_footer
	done

	rom_cfg_y_turbo
	rom_cfg

	# create new md5sum
	local md5sum_check_echo=$(md5sum_check "$script_real" "$machine")
}

main "${@}"
