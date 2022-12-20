#!/bin/bash

# copy this file to ./bin/_cfg-lib.sh and make changes

# types of cfgs you wish to generate
# used along with system_cfgs below
readonly -a cfg_types=(
	"input_player1_turbo_btn"
	"input_player2_turbo_btn"
	"input_turbo_default_button"
)

# system_cfgs: the system cfgs you wish to generate
# of the form <machine>_<system>_<cfg_type>="value"
# used along with cfg_types above
readonly bartop_amstradcpc_input_player1_turbo_btn="x"
readonly retroflag_atari5200_input_turbo_default_button="a"
readonly retroflag_gx4000_input_player1_turbo_btn="x"

# systems that will have input_player1_turbo_btn and input_player2_turbo_btn both set to y
readonly -a y_turbo_systems=(
	"amiga"
	"coleco"
	"zxspectrum"
)

# input values per system and button
readonly -A input_btn_values=(
	["bartop;a"]="5"
	["bartop;b"]="4"
	["bartop;x"]="1"
	["bartop;y"]="3"

	["retroflag;a"]="0"
	["retroflag;b"]="1"
	["retroflag;x"]="2"
	["retroflag;y"]="3"
)

# roms that will have input_player1_turbo_btn and input_player2_turbo_btn both set to y
readonly -a y_turbo_rom_cfgs=(
	"fba;digdug"
	"mame2003-plus;blktiger"
	"neogeo;maglord"
)

# rom-specific cfgs
readonly -A rom_cfgs=(
	["dreamcast;dolphin;input_player1_turbo_btn"]="x"
	["mame2003-plus;bucky;input_player1_turbo_btn"]="x"
	["sg-1000;Knightmare (Taiwan) (Unl);input_turbo_default_button"]="b"
)
