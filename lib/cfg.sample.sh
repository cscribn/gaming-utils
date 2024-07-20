#!/bin/bash

# copy this file to ./lib/cfg.sh and make changes

# input values per system and button
readonly -A input_turbo_btn_values=(
	["a500;a"]="1"
	["a500;b"]="2"
	["a500;x"]="0"
	["a500;y"]="3"
	["a500;m"]="99"

	["psclassic;a"]="1"
	["psclassic;b"]="2"
	["psclassic;x"]="0"
	["psclassic;y"]="3"
	["psclassic;m"]="99"

	["retrobar;a"]="5"
	["retrobar;b"]="4"
	["retrobar;x"]="1"
	["retrobar;y"]="3"
	["retrobar;m"]="99"

	["retrobed;a"]="2"
	["retrobed;b"]="1"
	["retrobed;x"]="3"
	["retrobed;y"]="0"
	["retrobed;m"]="99"

	["retroboy;a"]="0"
	["retroboy;b"]="1"
	["retroboy;x"]="2"
	["retroboy;y"]="3"
	["retroboy;m"]="99"

	["retropad;a"]="1"
	["retropad;b"]="0"
	["retropad;x"]="2"
	["retropad;y"]="3"
	["retropad;m"]="99"

	["retrotg16;a"]="0"
	["retrotg16;b"]="1"
	["retrotg16;x"]="99"
	["retrotg16;y"]="99"
	["retrotg16;m"]="99"

	["retrovlieg;a"]="1"
	["retrovlieg;b"]="2"
	["retrovlieg;x"]="7"
	["retrovlieg;y"]="6"
	["retrovlieg;m"]="99"

	["segamini;a"]="4"
	["segamini;b"]="2"
	["segamini;x"]="3"
	["segamini;y"]="1"
	["segamini;m"]="99"
)
