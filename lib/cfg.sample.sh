#!/bin/bash

# copy this file to ./lib/cfg.sh and make changes

# machine-specific configs
readonly -a machine_cfgs=(
	"a500;amstradcpc;input_player1_turbo_btn;x"
	"a500;amstradcpc;input_turbo_default_button;a"
	"a500;atari5200;input_player1_turbo_btn;x"
	"a500;moto;input_player1_turbo_btn;x"
	"a500;msx;input_turbo_default_button;a"
	"a500;sg-1000;input_turbo_default_button;a"
	"a500;videopac;input_player1_turbo_btn;x"
	"psclassic;amstradcpc;input_player1_turbo_btn;x"
	"psclassic;amstradcpc;input_turbo_default_button;a"
	"psclassic;atari5200;input_player1_turbo_btn;x"
	"psclassic;moto;input_player1_turbo_btn;x"
	"psclassic;msx;input_turbo_default_button;a"
	"psclassic;sg-1000;input_turbo_default_button;a"
	"psclassic;videopac;input_player1_turbo_btn;x"
	"retrobar;amstradcpc;input_player1_turbo_btn;x"
	"retrobar;amstradcpc;input_turbo_default_button;a"
	"retrobar;atari5200;input_player1_turbo_btn;x"
	"retrobar;moto;input_player1_turbo_btn;x"
	"retrobar;msx;input_turbo_default_button;a"
	"retrobar;sg-1000;input_turbo_default_button;a"
	"retrobar;videopac;input_player1_turbo_btn;x"
	"retrobed;amstradcpc;input_player1_turbo_btn;x"
	"retrobed;amstradcpc;input_turbo_default_button;a"
	"retrobed;atari5200;input_player1_turbo_btn;x"
	"retrobed;moto;input_player1_turbo_btn;x"
	"retrobed;msx;input_turbo_default_button;a"
	"retrobed;sg-1000;input_turbo_default_button;a"
	"retrobed;videopac;input_player1_turbo_btn;x"
	"retroboy;amstradcpc;input_player1_turbo_btn;x"
	"retroboy;amstradcpc;input_turbo_default_button;a"
	"retroboy;atari5200;input_player1_turbo_btn;x"
	"retroboy;moto;input_player1_turbo_btn;x"
	"retroboy;msx;input_turbo_default_button;a"
	"retroboy;sg-1000;input_turbo_default_button;a"
	"retroboy;videopac;input_player1_turbo_btn;x"
	"segamini;amstradcpc;input_player1_turbo_btn;x"
	"segamini;amstradcpc;input_turbo_default_button;a"
	"segamini;atari5200;input_player1_turbo_btn;x"
	"segamini;moto;input_player1_turbo_btn;x"
	"segamini;msx;input_turbo_default_button;a"
	"segamini;sg-1000;input_turbo_default_button;a"
	"segamini;videopac;input_player1_turbo_btn;x"
)

# systmes that will have input_player1_turbo_btn and input_player2_turbo_btn both set to y
readonly -a y_turbo_systems=(
	"amiga"
	"atari2600"
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

# roms that will have input_player1_turbo_btn and input_player2_turbo_btn both set to y
readonly -a y_turbo_rom_cfgs=(
	"arcade-pre90s;1942"
	"arcade-pre90s;1943"
	"arcade-pre90s;aliensyn"
	"arcade-pre90s;blktiger"
	"arcade-pre90s;contra"
	"arcade-pre90s;darius"
	"arcade-pre90s;ddux"
	"arcade-pre90s;digdug"
	"arcade-pre90s;esb"
	"arcade-pre90s;galaga"
	"arcade-pre90s;galagamf"
	"arcade-pre90s;galaxian"
	"arcade-pre90s;gaplus"
	"arcade-pre90s;imgfight"
	"arcade-pre90s;invaders"
	"arcade-pre90s;junofrst"
	"arcade-pre90s;mooncrst"
	"arcade-pre90s;mpatrol"
	"arcade-pre90s;p47"
	"arcade-pre90s;pooyan"
	"arcade-pre90s;rampage"
	"arcade-pre90s;robocop"
	"arcade-pre90s;rtype"
	"arcade-pre90s;rygar"
	"arcade-pre90s;scontra"
	"arcade-pre90s;shollow"
	"arcade-pre90s;skykid"
	"arcade-pre90s;spacefb"
	"arcade-pre90s;stargate"
	"arcade-pre90s;starwars"
	"arcade-pre90s;tempest"
	"arcade-pre90s;terracre"
	"arcade-pre90s;timeplt"
	"arcade-pre90s;toki"
	"arcade-pre90s;twincobr"
	"arcade-pre90s;vsduckhunt"
	"arcade-pre90s;wb3"
	"arcade-pre90s;zerowing"
	"arcade-pre90s_2;astrof"
	"arcade-pre90s_2;bublbobr"
	"arcade-pst90s;1941"
	"arcade-pst90s;1944"
	"arcade-pst90s;19xx"
	"arcade-pst90s;batsugun"
	"arcade-pst90s;ddonpach"
	"arcade-pst90s;dogyuun"
	"arcade-pst90s;donpachi"
	"arcade-pst90s;fantzn2x"
	"arcade-pst90s;feversos"
	"arcade-pst90s;fireshrk"
	"arcade-pst90s;gigawing"
	"arcade-pst90s;gijoe"
	"arcade-pst90s;gunbird"
	"arcade-pst90s;gunbird2"
	"arcade-pst90s;guwange"
	"arcade-pst90s;kingdmgp"
	"arcade-pst90s;nbbatman"
	"arcade-pst90s;progear"
	"arcade-pst90s;raiden"
	"arcade-pst90s;rtypeleo"
	"arcade-pst90s;s1945"
	"arcade-pst90s;s1945ii"
	"arcade-pst90s;salmndr2"
	"arcade-pst90s;samuraia"
	"arcade-pst90s;simpsons2pj"
	"arcade-pst90s;ssridersubc"
	"arcade-pst90s;sstriker"
	"arcade-pst90s;tmnt22pu"
	"arcade-pst90s;tmnt2pj"
	"arcade-pst90s;vimana"
	"arcade-pst90s;xexex"
	"arcade-pst90s_2;shienryu"
	"arcade-pst90s_3;ncv1"
	"arcade-pst90s_3;ncv2"
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
	"snes;U.N. Squadron (USA)"
)

# rom-specific cfgs
readonly -A rom_cfgs=(
	["amiga;Battle Squadron : The Destruction of the Barrax Em (v1.7 0941);input_turbo_default_button"]="a"
	["arcade-pre90s;shollow;input_turbo_default_button"]="a"
	["arcade-pre90s_2;asteroid;input_player1_turbo_btn"]="x"
	["arcade-pre90s_2;p47;input_turbo_default_button"]="a"
	["arcade-pre90s_2;seganinj;input_player1_turbo_btn"]="x"
	["arcade-pst90s;astorm;input_player1_turbo_btn"]="x"
	["arcade-pst90s;dmnfrnt;input_player1_turbo_btn"]="x"
	["arcade-pst90s;esprade;input_player1_turbo_btn"]="x"
	["arcade-pst90s;mmatrix;input_player1_turbo_btn"]="x"
	["arcade-pst90s_2;bucky;input_player1_turbo_btn"]="x"
	["arcade-pst90s_3;ncv1;input_turbo_default_button"]="a"
	["arcade-pst90s_3;ncv2;input_turbo_default_button"]="a"
	["atari5200;Choplifter! (USA);input_turbo_default_button"]="a"
	["atari7800;Astro Blaster (20230627) (FB86A5A0);input_turbo_default_button"]="a"
	["atari7800;Bentley Bear - Crystal Quest by Bob DeCrescenzo (V20130718RC5);input_turbo_default_button"]="a"
	["intellivision;d2k;input_turbo_default_button"]="a"
	["intellivision;Princess Quest;input_turbo_default_button"]="a"
	["intellivision;Space Patrol - Full Cartridge Release - 2007;input_turbo_default_button"]="a"
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
	["snes;U.N. Squadron (USA);input_player1_turbo_btn"]="a"
	["x68000;Chourensha 68K v1.01 (1995)(Famibe No Yosshin);input_turbo_default_button"]="a"
	["x68000;Flame Wing v1.02 (1994)(Itasenpara);input_turbo_default_button"]="a"
	["x68000;Nemesis '90 Kai (1993)(SPS);input_turbo_default_button"]="a"
	["x68000;Nemesis '94 Gradius 2 (1994)(Gra2 Project Team);input_turbo_default_button"]="a"
	["zxspectrum;Flying Shark 128K (1987)(Firebird);input_turbo_default_button"]="a"
)
