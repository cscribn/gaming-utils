#!/bin/bash

# copy this file to ./lib/special.sh and make changes

readonly -A special_items=(
	["Aleste 2 - Compile (1989) [ROM Version] [v8 by Ricbit] [3275].rom"]="Microsoft - MSX;Aleste 2 - Compile (1989) [ROM Version] [v8 by Ricbit] [3275].rom;km_fmsx_libretro.so"
	["astdelux.zip"]="Arcade - 80s and Before;astdelux.zip;km_mame2003_plus_libretro.so"
	["astinvad.zip"]="Arcade - 80s and Before;astinvad.zip;km_mame2003_plus_libretro.so"
	["astrob.zip"]="Arcade - 80s and Before;astrob.zip;km_mame2003_plus_libretro.so"
	["astrof.zip"]="Arcade - 80s and Before;astrof.zip;km_mame2003_plus_libretro.so"
	["bigfight.zip"]="Arcade - 90s and After;bigfight.zip;km_mame2010_libretro.so"
	["bigkong.zip"]="Arcade - 80s and Before;bigkong.zip;km_mame_xtreme_low_profile_libretro.so"
	["BMENACE1.PC"]="Microsoft - DOS;BMENACE1.PC/BMENACE1.EXE;km_dosbox_pure_libretro.so"
	["bublbobr.zip"]="Arcade - 80s and Before;bublbobr.zip;km_mame2003_plus_libretro.so"
	["COSMO1"]="Microsoft - DOS;COSMO1/COSMO1.EXE;km_dosbox_pure_libretro.so"
	["crysking.zip"]="Arcade - 90s and After;crysking.zip;km_mame2010_libretro.so"
	["ddragon.zip"]="Arcade - 80s and Before;ddragon.zip;km_mame2003_plus_libretro.so"
	["DOOM2.DOOM"]="Microsoft - DOS - DOOM;doom/DOOM2/DOOM2.WAD;km_prboom_xtreme_libretro.so"
	["dopa"]="Microsoft - DOS - Quake;quake/dopa/pak0.pak;km_tyrquake_libretro.so"
	["foodf.zip"]="Arcade - 80s and Before;foodf.zip;km_mame2003_plus_libretro.so"
	["Galaxian (Japan).nes"]="Nintendo - Nintendo Entertainment System;Galaxian (Japan).nes;km_fceumm_libretro.so"
	["gorf.zip"]="Arcade - 80s and Before;gorf.zip;km_mame2003_plus_libretro.so"
	["HARRY.PC"]="Microsoft - DOS;HARRY/HARRY.EXE;km_dosbox_pure_libretro.so"
	["hipnotic"]="Microsoft - DOS - Quake;quake/hypnotic/pak0.pak;km_tyrquake_libretro.so"
	["HOCUS.PC"]="Microsoft - DOS;HOCUS/HOCUS.EXE;km_dosbox_pure_libretro.so"
	["HTP.DOOM"]="Microsoft - DOS - DOOM;doom/HTP.DOOM/HTP.WAD;km_prboom_xtreme_libretro.so"
	["id1"]="Microsoft - DOS - Quake;quake/id1/pak0.pak;km_tyrquake_libretro.so"
	["JAZZ.PC"]="Microsoft - DOS;Jazz JAZZ/JAZZ.EXE;km_dosbox_pure_libretro.so"
	["KEEN4E.PC"]="Microsoft - DOS;KEEN4E/KEEN4E.EXE;km_dosbox_pure_libretro.so"
	["LOST.DOOM"]="Microsoft - DOS - DOOM;doom/LOST.DOOM/LOST.WAD;km_prboom_xtreme_libretro.so"
	["marble.zip"]="Arcade - 80s and Before;marble.zip;km_mame2003_plus_libretro.so"
	["moonwlkb.zip"]="Arcade - 90s and After;moonwlkb.zip;km_mame2003_plus_libretro.so"
	["ncv1.zip"]="Arcade - 90s and After;ncv1.zip;km_mame2010_libretro.so"
	["ncv2.zip"]="Arcade - 90s and After;ncv2.zip;km_mame2010_libretro.so"
	["Ninja Ryuuken Den III - Yomi no Hakobune (Japan).nes"]="Nintendo - Nintendo Entertainment System;Ninja Ryuuken Den III - Yomi no Hakobune (Japan).nes;km_fceumm_libretro.so"
	["NM.PC"]="Microsoft - DOS;NM/NM.EXE;km_dosbox_pure_libretro.so"
	["NOREST.DOOM"]="Microsoft - DOS - DOOM;doom/NOREST.DOOM/NOREST.WAD;km_prboom_xtreme_libretro.so"
	["NUKEM2.PC"]="Microsoft - DOS;NUKEM2/NUKEM2.EXE;km_dosbox_pure_libretro.so"
	["OREGON.PC"]="Microsoft - DOS;OREGON/OREGON.EXE;km_dosbox_pure_libretro.so"
	["outrun.zip"]="Arcade - 80s and Before;outrun.zip;km_mame2003_plus_libretro.so"
	["PG.DOOM"]="Microsoft - DOS - DOOM;doom/PG.DOOM/PG.WAD;km_prboom_xtreme_libretro.so"
	["PLUTONIA.DOOM"]="Microsoft - DOS - DOOM;doom/PLUTONIA.DOOM/PLUTONIA.WAD;km_prboom_xtreme_libretro.so"
	["Pokemon Puzzle League (USA).z64"]="Nintendo - Nintendo 64;Pokemon Puzzle League (USA).z64;km_mupen64_xtreme_libretro.so"
	["polepos.zip"]="Arcade - 80s and Before;polepos.zip;km_mame2010_libretro.so"
	["polepos2.zip"]="Arcade - 80s and Before;polepos2.zip;km_mame_xtreme_low_profile_libretro.so"
	["Robotron 64 (USA).z64"]="Nintendo - Nintendo 64;Robotron 64 (USA).z64;km_mupen64_xtreme_libretro.so"
	["rogue"]="Microsoft - DOS - Quake;quake/rogue/pak0.pak;km_tyrquake_libretro.so"
	["salmndr2.zip"]="Arcade - 90s and After;salmndr2.zip;km_mame2003_plus_libretro.so"
	["Space Invaders (USA).z64"]="Nintendo - Nintendo 64;Space Invaders (USA).z64;km_mupen64_xtreme_libretro.so"
	["SIGIL.DOOM"]="Microsoft - DOS - DOOM;doom/SIGIL.DOOM/SIGIL.WAD;km_prboom_xtreme_libretro.so"
	["spiders.zip"]="Arcade - 80s and Before;spiders.zip;km_mame2003_plus_libretro.so"
	["TNT.DOOM"]="Microsoft - DOS - DOOM;doom/TNT.DOOM/TNT.WAD;km_prboom_xtreme_libretro.so"
	["Tyrian 2000 (1999)(XSIV Games) [Action].sh"]="Microsoft - DOS;Tyrian 2000 (1999)(XSIV Games) [Action]/Tyrian2k.exe;km_dosbox_pure_libretro.so"
	["Ultimate Doom.sh"]="Microsoft - DOS - DOOM;doom/ultimate-doom/DOOM.WAD;km_prboom_xtreme_libretro.so"
)
