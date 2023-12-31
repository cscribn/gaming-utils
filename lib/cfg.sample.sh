#!/bin/bash

# copy this file to ./lib/cfg.sh and make changes

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
readonly retrobar_amstradcpc_input_player1_turbo_btn="x"
readonly retrobar_amstradcpc_input_turbo_default_button="a"
readonly retrobar_atari5200_input_turbo_default_button="a"
readonly retrobar_atarijaguar_input_player1_turbo_btn="x"
readonly retrobar_moto_input_player1_turbo_btn="x"
readonly retrobar_msx_input_turbo_default_button="a"
readonly retrobar_sg_1000_input_turbo_default_button="a"
readonly retrobar_videopac_input_player1_turbo_btn="x"

readonly retrobed_amstradcpc_input_player1_turbo_btn="x"
readonly retrobed_amstradcpc_input_turbo_default_button="a"
readonly retrobed_atari5200_input_turbo_default_button="a"
readonly retrobed_atarijaguar_input_player1_turbo_btn="x"
readonly retrobed_moto_input_player1_turbo_btn="x"
readonly retrobed_msx_input_turbo_default_button="a"
readonly retrobed_sg_1000_input_turbo_default_button="a"
readonly retrobed_videopac_input_player1_turbo_btn="x"

readonly retroboy_amstradcpc_input_player1_turbo_btn="x"
readonly retroboy_amstradcpc_input_turbo_default_button="a"
readonly retroboy_atari5200_input_turbo_default_button="a"
readonly retroboy_atarijaguar_input_player1_turbo_btn="x"
readonly retroboy_moto_input_player1_turbo_btn="x"
readonly retroboy_msx_input_turbo_default_button="a"
readonly retroboy_sg_1000_input_turbo_default_button="a"
readonly retroboy_videopac_input_player1_turbo_btn="x"

# systmes that will have input_player1_turbo_btn and input_player2_turbo_btn both set to y
readonly -a y_turbo_systems=(
	"amiga"
	"atari2600"
	"atari5200"
	"atari7800"
	"atarilynx"
	"c64"
	"coleco"
	"gamegear"
	"gb"
	"gbc"
	"intellivision"
	"mastersystem"
	"msx"
	"ngpc"
	"pcfx"
	"scv"
	"sg-1000"
	"vic20"
	"x1"
	"x68000"
	"zxspectrum"
)

# input values per system and button
readonly -A input_btn_values=(
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

	["retrovlieg;a"]="1"
	["retrovlieg;b"]="2"
	["retrovlieg;x"]="7"
	["retrovlieg;y"]="6"
	["retrovlieg;m"]="99"
)

# roms that will have input_player1_turbo_btn and input_player2_turbo_btn both set to y
readonly -a y_turbo_rom_cfgs=(
	"fba;1941"
	"fba;1942"
	"fba;1943"
	"fba;1944"
	"fba;19xx"
	"fba;aliensyn"
	"fba;batsugun"
	"fba;blktiger"
	"fba;contra"
	"fba;darius"
	"fba;ddonpach"
	"fba;ddux"
	"fba;digdug"
	"fba;dogyuun"
	"fba;donpachi"
	"fba;esb"
	"fba;fantzn2x"
	"fba;feversos"
	"fba;fireshrk"
	"fba;galaga"
	"fba;galagamf"
	"fba;galaxian"
	"fba;gaplus"
	"fba;gigawing"
	"fba;gunbird"
	"fba;gunbird2"
	"fba;guwange"
	"fba;imgfight"
	"fba;invaders"
	"fba;junofrst"
	"fba;kingdmgp"
	"fba;mooncrst"
	"fba;mpatrol"
	"fba;nbbatman"
	"fba;p47"
	"fba;pooyan"
	"fba;progear"
	"fba;raiden"
	"fba;rampage"
	"fba;robocop"
	"fba;rtype"
	"fba;rtypeleo"
	"fba;rygar"
	"fba;s1945"
	"fba;s1945ii"
	"fba;salmndr2"
	"fba;samuraia"
	"fba;scontra"
	"fba;shollow"
	"fba;simpsons2pj"
	"fba;skykid"
	"fba;spacefb"
	"fba;ssridersubc"
	"fba;sstriker"
	"fba;stargate"
	"fba;starwars"
	"fba;tempest"
	"fba;terracre"
	"fba;timeplt"
	"fba;tmnt22pu"
	"fba;tmnt2pj"
	"fba;twincobr"
	"fba;vimana"
	"fba;vsduckhunt"
	"fba;wb3"
	"fba;xexex"
	"fba;zerowing"
	"mame2003-plus;astrof"
	"mame2003-plus;bublbobr"
	"mame2003-plus;shienryu"
	"mame2010;ncv1"
	"mame2010;ncv2"
	"neogeo;androdun"
	"neogeo;blazstar"
	"neogeo;lresort"
	"neogeo;maglord"
	"neogeo;preisle2"
	"neogeo;pulstar"
	"neogeo;s1945p"
	"neogeo;sonicwi2"
	"neogeo;sonicwi3"
	"pc;JAZZ"
	"pc;NUKEM2"
	"pc88;Gradius"
	"pc88;Melt Down"
	"snes-msu1;Contra (USA) (MSU1)"
	"snes;U.N. Squadron (USA)"
)

# rom-specific cfgs
readonly -A rom_cfgs=(
	["amiga;Battle Squadron : The Destruction of the Barrax Em (v1.7 0941);input_turbo_default_button"]="a"
	["fba;astorm;input_player1_turbo_btn"]="x"
	["fba;dmnfrnt;input_player1_turbo_btn"]="x"
	["fba;esprade;input_player1_turbo_btn"]="x"
	["fba;mmatrix;input_player1_turbo_btn"]="x"
	["fba;shollow;input_turbo_default_button"]="a"
	["atari7800;Astro Blaster (20230627) (FB86A5A0);input_turbo_default_button"]="a"
	["atari7800;Bentley Bear - Crystal Quest by Bob DeCrescenzo (V20130718RC5);input_turbo_default_button"]="a"
	["intellivision;d2k;input_turbo_default_button"]="a"
	["intellivision;Princess Quest;input_turbo_default_button"]="a"
	["intellivision;Space Patrol - Full Cartridge Release - 2007;input_turbo_default_button"]="a"
	["mame2003-plus;asteroid;input_player1_turbo_btn"]="x"
	["mame2003-plus;bucky;input_player1_turbo_btn"]="x"
	["mame2003-plus;p47;input_turbo_default_button"]="a"
	["mame2003-plus;seganinj;input_player1_turbo_btn"]="x"
	["mame2010;ncv1;input_turbo_default_button"]="a"
	["mame2010;ncv2;input_turbo_default_button"]="a"
	["megadrive;Space Harrier II (World);input_player1_turbo_btn"]="x"
	["neogeo;lasthope;input_player1_turbo_btn"]="x"
	["neogeo;mslug;input_player1_turbo_btn"]="x"
	["neogeo;mslug3;input_player1_turbo_btn"]="x"
	["neogeo;mslug4;input_player1_turbo_btn"]="x"
	["neogeo;mslug5;input_player1_turbo_btn"]="x"
	["neogeo;mslugx;input_player1_turbo_btn"]="x"
	["neogeo;shocktr2;input_player1_turbo_btn"]="x"
	["neogeo;spinmast;input_player1_turbo_btn"]="x"
	["pc;HOCUS;input_player1_turbo_btn"]="x"
	["pc;HOCUS;input_turbo_default_button"]="a"
	["pc;JAZZ;input_turbo_default_button"]="a"
	["pc88;Gradius;input_turbo_default_button"]="a"
	["pc88;Melt Down;input_player1_turbo_btn"]="x"
	["quake;dopa;input_player1_turbo_btn"]="m"
	["quake;hipnotic;input_player1_turbo_btn"]="m"
	["quake;id1;input_player1_turbo_btn"]="m"
	["quake;rogue;input_player1_turbo_btn"]="m"
	["sg-1000;Knightmare (Taiwan) (Unl);input_turbo_default_button"]="b"
	["snes-msu1;Contra (USA) (MSU1);input_turbo_default_button"]="y"
	["snes;U.N. Squadron (USA);input_player1_turbo_btn"]="a"
	["x68000;Chourensha 68K v1.01 (1995)(Famibe No Yosshin);input_turbo_default_button"]="a"
	["x68000;Flame Wing v1.02 (1994)(Itasenpara);input_turbo_default_button"]="a"
	["x68000;Nemesis '90 Kai (1993)(SPS);input_turbo_default_button"]="a"
	["x68000;Nemesis '94 Gradius 2 (1994)(Gra2 Project Team);input_turbo_default_button"]="a"
	["zxspectrum;Flying Shark 128K (1987)(Firebird);input_turbo_default_button"]="a"
)
