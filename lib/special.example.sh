#!/bin/bash

# copy this file to ./lib/special.sh and make changes

readonly -A special_items=(
	["Aleste 2 - Compile (1989) [ROM Version] [v8 by Ricbit] [3275].rom"]="Microsoft - MSX;Aleste 2 - Compile (1989) [ROM Version] [v8 by Ricbit] [3275].rom;km_fmsx_libretro.so"
	["Battlezone [DC] (1983)(Atarisoft) [Action, Simulation].sh"]="DOS;Battlezone [DC] (1983)(Atarisoft) [Action, Simulation]/ZONE.EXE;km_dosbox_pure_libretro.so"
	["CHAMP Centiped-em (1997)(CHAMProgramming).sh"]="DOS;CHAMP Centiped-em (1997)(CHAMProgramming)/CHAMP/CENTIPED/CENTIPED.EXE;km_dosbox_pure_libretro.so"
	["CHAMP Galagon (1997)(CHAMProgramming).sh"]="DOS;CHAMP Galagon (1997)(CHAMProgramming)/CHGalag/CHAMP/GALAGON/GALAGON.EXE;km_dosbox_pure_libretro.so"
	["CHAMP Galaxia (1996)(CHAMProgramming).sh"]="DOS;CHAMP Galaxia (1996)(CHAMProgramming)/CHGalax/CHAMP/GALAXIA/GALAXIA.EXE;km_dosbox_pure_libretro.so"
	["CHAMP Invaders (1997)(CHAMProgramming).sh"]="DOS;CHAMP Invaders (1997)(CHAMProgramming)/CHAMP/INVADERS/INVADERS.EXE;km_dosbox_pure_libretro.so"
	["CHAMP Kong (1996)(CHAMProgramming).sh"]="DOS;CHAMP Kong (1996)(CHAMProgramming)/KONG.EXE;km_dosbox_pure_libretro.so"
	["CHAMP Ms. Pac-em (1997)(CHAMProgramming).sh"]="DOS;CHAMP Ms. Pac-em (1997)(CHAMProgramming)/CHAMP/MSPACEM/MSPACEM.EXE;km_dosbox_pure_libretro.so"
	["CHAMP Pac-em (1997)(CHAMProgramming).sh"]="DOS;CHAMP Pac-em (1997)(CHAMProgramming)/CHAMP/PACEM/PACEM.EXE;km_dosbox_pure_libretro.so"
	["Doom - Sigil.sh"]="Doom;doom/sigil/DOOM.WAD;km_prboom_xtreme_libretro.so"
	["Doom 2.sh"]="Doom;doom/doom2/DOOM2.WAD;km_prboom_xtreme_libretro.so"
	["Final Doom - The Plutonia Experiment.sh"]="Doom;doom/final-doom-plutonia-experiment/PLUTONIA.WAD;km_prboom_xtreme_libretro.so"
	["Final Doom - The Plutonia Experiment.sh"]="Doom;doom/PLUTONIA/PLUTONIA.WAD;km_prboom_xtreme_libretro.so"
	["Final Doom - TNT - Evilution.sh"]="Doom;doom/final-doom-tnt-evilution/TNT.WAD;km_prboom_xtreme_libretro.so"
	["Jazz Jackrabbit (1992)(Epic Megagames).sh"]="DOS;Jazz Jackrabbit (1992)(Epic Megagames)/JAZZ.EXE;km_dosbox_pure_libretro.so"
	["Ninja Ryuuken Den III - Yomi no Hakobune (Japan).nes"]="Nintendo - Nintendo Entertainment System;Ninja Ryuuken Den III - Yomi no Hakobune (Japan).nes;km_fceumm_libretro.so"
	["Quake Episode 5 (dopa).sh"]="Quake;quake/dopa/pak0.pak;km_tyrquake_libretro.so"
	["Quake Mission Pack 1 (hipnotic).sh"]="Quake;quake/hypnotic/pak0.pak;km_tyrquake_libretro.so"
	["Quake Mission Pack 2 (rogue).sh"]="Quake;quake/rogue/pak0.pak;km_tyrquake_libretro.so"
	["Quake.sh"]="Quake;quake/id1/pak0.pak;km_tyrquake_libretro.so"
	["Rastan (1990)(Taito Corporation).sh"]="DOS;Rastan (1990)(Taito Corporation)/RASTAN.EXE;km_dosbox_pure_libretro.so"
	["Tyrian 2000 (1999)(XSIV Games) [Action].sh"]="DOS;Tyrian 2000 (1999)(XSIV Games) [Action]/Tyrian2k.exe;km_dosbox_pure_libretro.so"
	["Ultimate Doom.sh"]="Doom;doom/ultimate-doom/DOOM.WAD;km_prboom_xtreme_libretro.so"
)
