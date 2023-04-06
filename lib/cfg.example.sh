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
readonly a500_amstradcpc_input_player1_turbo_btn="x"
readonly a500_amstradcpc_input_turbo_default_button="a"
readonly a500_atari5200_input_turbo_default_button="a"
readonly a500_msx_input_turbo_default_button="a"
readonly a500_sg_1000_input_turbo_default_button="a"
readonly a500_videopac_input_player1_turbo_btn="x"

readonly psclassic_amstradcpc_input_player1_turbo_btn="x"
readonly psclassic_amstradcpc_input_turbo_default_button="a"
readonly psclassic_atari5200_input_turbo_default_button="a"
readonly psclassic_msx_input_turbo_default_button="a"
readonly psclassic_sg_1000_input_turbo_default_button="a"
readonly psclassic_videopac_input_player1_turbo_btn="x"

readonly retrobar_amstradcpc_input_player1_turbo_btn="x"
readonly retrobar_amstradcpc_input_turbo_default_button="a"
readonly retrobar_atari5200_input_turbo_default_button="a"
readonly retrobar_msx_input_turbo_default_button="a"
readonly retrobar_sg_1000_input_turbo_default_button="a"
readonly retrobar_videopac_input_player1_turbo_btn="x"

readonly retrobed_amstradcpc_input_player1_turbo_btn="x"
readonly retrobed_amstradcpc_input_turbo_default_button="a"
readonly retrobed_atari5200_input_turbo_default_button="a"
readonly retrobed_msx_input_turbo_default_button="a"
readonly retrobed_sg_1000_input_turbo_default_button="a"
readonly retrobed_videopac_input_player1_turbo_btn="x"

readonly retroboy_amstradcpc_input_player1_turbo_btn="x"
readonly retroboy_amstradcpc_input_turbo_default_button="a"
readonly retroboy_atari5200_input_turbo_default_button="a"
readonly retroboy_msx_input_turbo_default_button="a"
readonly retroboy_sg_1000_input_turbo_default_button="a"
readonly retroboy_videopac_input_player1_turbo_btn="x"

readonly segamdmini_amstradcpc_input_player1_turbo_btn="x"
readonly segamdmini_amstradcpc_input_turbo_default_button="a"
readonly segamdmini_atari5200_input_turbo_default_button="a"
readonly segamdmini_gx4000_input_player1_turbo_btn="x"
readonly segamdmini_gx4000_input_turbo_default_button="a"
readonly segamdmini_msx_input_turbo_default_button="a"
readonly segamdmini_sg_1000_input_turbo_default_button="a"
readonly segamdmini_videopac_input_player1_turbo_btn="x"

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
	"sg-1000"
	"vic20"
	"x1"
	"x68000"
	"zxspectrum"
)

# input values per system and button
readonly -A input_btn_values=(
	["a500;a"]="1"
	["a500;b"]="2"
	["a500;x"]="0"
	["a500;y"]="3"

	["psclassic;a"]="1"
	["psclassic;b"]="2"
	["psclassic;x"]="0"
	["psclassic;y"]="3"

	["retrobar;a"]="5"
	["retrobar;b"]="4"
	["retrobar;x"]="1"
	["retrobar;y"]="3"

	["retrobed;a"]="4"
	["retrobed;b"]="2"
	["retrobed;x"]="3"
	["retrobed;y"]="1"

	["retroboy;a"]="0"
	["retroboy;b"]="1"
	["retroboy;x"]="2"
	["retroboy;y"]="3"

	["segamdmini;a"]="4"
	["segamdmini;b"]="2"
	["segamdmini;x"]="3"
	["segamdmini;y"]="1"
)

# roms that will have input_player1_turbo_btn and input_player2_turbo_btn both set to y
readonly -a y_turbo_rom_cfgs=(
	"amiga;Deluxe Galaga (v1.2 AGA)"
	"fba;1943"
	"fba;ddux"
	"fba;digdug"
	"fba;esb"
	"fba;fantzn2x"
	"fba;galaga"
	"fba;galaxian"
	"fba;invaders"
	"fba;mpatrol"
	"fba;raiden"
	"fba;rampage"
	"fba;rygar"
	"fba;shollow"
	"fba;stargate"
	"fba;starwars"
	"fba;tempest"
	"fba;vsduckhunt"
	"mame2003-plus;aliensyn"
	"mame2003-plus;astrof"
	"mame2003-plus;blktiger"
	"mame2003-plus;bublbobr"
	"mame2003-plus;darius"
	"mame2003-plus;gigawing"
	"mame2003-plus;nbbatman"
	"mame2003-plus;robocop"
	"mame2003-plus;rtype"
	"mame2003-plus;rtypeleop"
	"mame2003-plus;salmndr2"
	"mame2003-plus;shienryu"
	"mame2003-plus;simps2pj"
	"mame2003-plus;ssrdrubc"
	"mame2003-plus;tmnt22p"
	"mame2003-plus;tmnt2pj"
	"mame2003-plus;wb3"
	"mame2003-plus;xexex"
	"mame2010;ncv1"
	"mame2010;ncv2"
	"neogeo;blazstar"
	"neogeo;maglord"
	"neogeo;pulstar"
	"neogeo;s1945p"
	"neogeo;sonicwi2"
	"pc;JAZZ"
	"shmups;batsugun"
	"shmups;ddonpach"
	"shmups;dogyuun"
	"shmups;donpachi"
	"shmups;esprade"
	"shmups;feversos"
	"shmups;fireshrk"
	"shmups;gunbird"
	"shmups;gunbird2"
	"shmups;guwange"
	"shmups;kingdmgp"
	"shmups;progear"
	"shmups;s1945"
	"shmups;s1945ii"
	"shmups;samuraia"
	"shmups;sstriker"
	"shmups;twincobr"
	"shmups;vimana"
	"shmups;zerowing"
)

# rom-specific cfgs
readonly -A rom_cfgs=(
	["atari7800;Astro Blaster (20140201);input_turbo_default_button"]="a"
	["atari7800;Bentley Bear - Crystal Quest by Bob DeCrescenzo (V20130718RC5);input_turbo_default_button"]="a"
	["dreamcast;dolphin;input_player1_turbo_btn"]="x"
	["fba;asteroid;input_player1_turbo_btn"]="x"
	["fba;astorm;input_player1_turbo_btn"]="x"
	["fba;dmnfrnt;input_player1_turbo_btn"]="x"
	["fba;seganinj;input_player1_turbo_btn"]="x"
	["fba;seganinj;input_turbo_default_button"]="a"
	["fba;shollow;input_turbo_default_button"]="a"
	["intellivision;d2k;input_turbo_default_button"]="a"
	["intellivision;Princess Quest;input_turbo_default_button"]="a"
	["intellivision;Space Patrol - Full Cartridge Release - 2007;input_turbo_default_button"]="a"
	["mame2003-plus;bucky;input_player1_turbo_btn"]="x"
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
	["pc;JAZZ"]="a"
	["pc88;Gradius;input_player1_turbo_btn"]="y"
	["pc88;Gradius;input_turbo_default_button"]="a"
	["pc88;Melt Down;input_player1_turbo_btn"]="x"
	["pc88;Melt Down;input_turbo_default_button"]="y"
	["sg-1000;Knightmare (Taiwan) (Unl);input_turbo_default_button"]="b"
	["shmups;esprade;input_player1_turbo_btn"]="x"
	["x68000;Chourensha 68K v1.01 (1995)(Famibe No Yosshin);input_turbo_default_button"]="a"
	["x68000;Nemesis '94 Gradius 2 (1994)(Gra2 Project Team);input_turbo_default_button"]="a"
	["zxspectrum;Flying Shark 128K (1987)(Firebird);input_turbo_default_button"]="a"
)
