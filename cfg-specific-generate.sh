#!/bin/bash

# settings
set -o pipefail
[[ "${TRACE-0}" = "1" ]] && set -o xtrace

# variables
declare script_name
script_name="$(basename "${0}")"
declare script_dir
script_dir="$(dirname "$0")"

declare cfg_dir
declare dir_cfg
declare machine
declare machine_cfg_dir
declare -a rom_cfgs_done=()
declare system_cfg_dir

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
check_new() {
	local md5sum_check_echo
	md5sum_check_echo=$(md5sum_check "${script_dir}/lib/cfg.sh" "$machine")

	[[ "$md5sum_check_echo" = "0" ]] && echo "${script_name}: ${machine} nothing new" && exit 0

	if [[ "$machine" = "retro"* ]]; then
		machine_cfg_dir="${cfg_dir}/${machine}/opt/retropie/configs/all/retroarch/config"

		echo "${script_name}: ${machine} - cleaning system cfgs"
		system_cfg_dir="${cfg_dir}/${machine}/opt/retropie/configs"

		find "${system_cfg_dir:?}/"* -maxdepth 1 -type d ! -wholename "${system_cfg_dir}/all/emulationstation" ! -wholename "${system_cfg_dir}/all" ! -wholename "${system_cfg_dir}/daphne" ! -wholename "${system_cfg_dir}/ports/openbor" ! -wholename "${system_cfg_dir}/ports" -exec rm -rf {} +
	elif [[ "$machine" = "a500" ]]; then
		machine_cfg_dir="${cfg_dir}/${machine}/Pandory/.user/.config/retroarch/config"
	elif [[ "$machine" = "psclassic" ]]; then
		machine_cfg_dir="${cfg_dir}/${machine}/retroarch/config"
	elif [[ "$machine" = "segamdmini" ]]; then
		machine_cfg_dir="${cfg_dir}/${machine}/hakchi/libretro/config"
	fi

	echo "${script_name}: ${machine} - cleaning machine cfgs"
	rm -rf "${machine_cfg_dir:?}/"*
}

dir_cfg_init() {
	mkdir -p "${machine_cfg_dir}/${system_retro_corenames[${system/_/-}]}"
	dir_cfg="${machine_cfg_dir}/${system_retro_corenames[${system/_/-}]}/${system/_/-}.cfg"
}

dir_cfg_y_turbo() {
	if printf '%s\0' "${y_turbo_systems[@]}" | grep -Fxqz "${system/_/-}"; then
		echo "${script_name}: ${machine} - dir cfg y turbo- ${system}"

		value="${input_btn_values[${machine};y]}"
		echo "input_player1_turbo_btn = \"${value}\"" >> "$dir_cfg"
		echo "input_player2_turbo_btn = \"${value}\"" >> "$dir_cfg"
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
		echo "${script_name}: ${machine} - rom y turbo - ${rom}"

		IFS=';' read -ra y_turbo_rom_cfg <<< "$c"
		local system="${y_turbo_rom_cfg[0]}"
		local rom="${y_turbo_rom_cfg[1]}"
		local value="${input_btn_values[${machine};y]}"
		local cfg

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

		if [[ -f "${HOME}/Gaming/bin/roms-cfg/${system}/${rom}.cfg" ]] && ! printf '%s\0' "${rom_cfgs[@]}" | grep -Fxqz "${machine};${system};${rom}"; then
			cat "${HOME}/Gaming/bin/roms-cfg/${system}/${rom}.cfg" >> "$cfg"
			rom_cfgs_done+=("${machine};${system};${rom}")
		fi

		echo "${cfg} = \"${value}\"" >> "$cfg_file"

		if [[ "${cfg}" = "input_player1_turbo_btn" ]]; then
			echo "input_player2_turbo_btn = \"${value}\"" >> "$cfg_file"
		fi
	done
}

system_cfg() {
	[[ "$machine" != "retro"* ]] && return 0

	echo "${script_name}: ${machine} - system - ${system}"

	local ports=""

	if [[ "$system" = "doom" ]] || [[ "$system" = "quake" ]]; then
		ports="ports/"
	fi

	local cfg_path="${system_cfg_dir}/${ports}${system/_/-}"
	mkdir -p "${cfg_path}"
	system_cfg="${cfg_path}/retroarch.cfg"

	{
		echo "# Settings made here will only override settings in the global retroarch.cfg if placed above the #include line"
		echo ""
		echo "#include \"/opt/retropie/configs/all/retroarch.cfg\""
	} >> "$system_cfg"
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
		system_cfg
		dir_cfg_init
		dir_cfg_y_turbo
		dir_cfg_gen
	done

	rom_cfg_y_turbo
	rom_cfg

	# create new md5sum
	local md5sum_check_echo
	md5sum_check_echo=$(md5sum_check "${script_dir}/${script_name}" "$machine")
}

main "${@}"
