#!/bin/bash

# copy this file to ./lib/special.sh and make changes

readonly -A special_items=(
	["Aleste 2 - Compile (1989) [ROM Version] [v8 by Ricbit] [3275].rom"]="Microsoft - MSX;Aleste 2 - Compile (1989) [ROM Version] [v8 by Ricbit] [3275].rom;km_fmsx_libretro.so"
	["astdelux.zip"]="Arcade - 80s and Before;astdelux.zip;km_mame2003_plus_libretro.so"
	["astinvad.zip"]="Arcade - 80s and Before;astinvad.zip;km_mame2003_plus_libretro.so"
	["astrob.zip"]="Arcade - 80s and Before;astrob.zip;km_mame2003_plus_libretro.so"
	["astrof.zip"]="Arcade - 80s and Before;astrof.zip;km_mame2003_plus_libretro.so"
	["bigfight.zip"]="Arcade - 90s and After;bigfight.zip;km_mame2010_libretro.so"
	["bigkong.zip"]="Arcade - 80s and Before;bigkong.zip;km_mame2010_libretro.so"
	["Bio Menace- Episode One- Dr. Mangle's Lab v1.1 [SWR] (1993)(Apogee Software, Ltd.) [Action].sh"]="Microsoft - DOS;Bio Menace- Episode One- Dr. Mangle's Lab v1.1 [SWR] (1993)(Apogee Software, Ltd.) [Action]/BMENACE1.EXE;km_dosbox_pure_libretro.so"
	["bublbobr.zip"]="Arcade - 80s and Before;bublbobr.zip;km_mame2003_plus_libretro.so"
	["Commander Keen in Goodbye, Galaxy!- Episode IV- Secret of the Oracle v1.2 EGA (1991)(Apogee Software, Ltd.) [Action].sh"]="Microsoft - DOS;Commander Keen in Goodbye, Galaxy!- Episode IV- Secret of the Oracle v1.2 EGA (1991)(Apogee Software, Ltd.) [Action]/KEEN4E.EXE;km_dosbox_pure_libretro.so"
	["Cosmo's Cosmic Adventure- Forbidden Planet- Adventure 1 of 3 v1.20 [SW] (1992)(Apogee Software, Ltd.) [Action].sh"]="Microsoft - DOS;Cosmo's Cosmic Adventure- Forbidden Planet- Adventure 1 of 3 v1.20 [SW] (1992)(Apogee Software, Ltd.) [Action]/COSMO1.EXE;km_dosbox_pure_libretro.so"
	["crysking.zip"]="Arcade - 90s and After;crysking.zip;km_mame2010_libretro.so"
	["ddragon.zip"]="Arcade - 80s and Before;ddragon.zip;km_mame2003_plus_libretro.so"
	["Doom - Sigil.sh"]="Microsoft - DOS - DOOM;doom/sigil/DOOM.WAD;km_prboom_xtreme_libretro.so"
	["Doom 2.sh"]="Microsoft - DOS - DOOM;doom/doom2/DOOM2.WAD;km_prboom_xtreme_libretro.so"
	["Doom 2 - No Rest for the Living.sh"]="Microsoft - DOS - DOOM;doom/no-rest-for-the-living/DOOM2.WAD;km_prboom_xtreme_libretro.so"
	["Duke Nukem II [SWR] (1993)(Apogee Software, Ltd.) [Action].sh"]="Microsoft - DOS;Duke Nukem II [SWR] (1993)(Apogee Software, Ltd.) [Action]/NUKEM2.EXE;km_dosbox_pure_libretro.so"
	["Final Doom - The Plutonia Experiment.sh"]="Microsoft - DOS - DOOM;doom/final-doom-plutonia-experiment/PLUTONIA.WAD;km_prboom_xtreme_libretro.so"
	["Final Doom - TNT - Evilution.sh"]="Microsoft - DOS - DOOM;doom/final-doom-tnt-evilution/TNT.WAD;km_prboom_xtreme_libretro.so"
	["foodf.zip"]="Arcade - 80s and Before;foodf.zip;km_mame2003_plus_libretro.so"
	["Galaxian (Japan).nes"]="Nintendo - Nintendo Entertainment System;Galaxian (Japan).nes;km_fceumm_libretro.so"
	["gorf.zip"]="Arcade - 80s and Before;gorf.zip;km_mame2003_plus_libretro.so"
	["Halloween Harry v1.1 [SWR] (1993)(Apogee Software, Ltd.) [Action].sh"]="Microsoft - DOS;Halloween Harry v1.1 [SWR] (1993)(Apogee Software, Ltd.) [Action]/HARRY.EXE;km_dosbox_pure_libretro.so"
	["Hell to Pay.sh"]="Microsoft - DOS - DOOM;doom/hell-to-pay/DOOM2.WAD;km_prboom_xtreme_libretro.so"
	["Hocus Pocus v1.1 [SWR] (1994)(Apogee Software, Ltd.) [Action].sh"]="Microsoft - DOS;Hocus Pocus v1.1 [SWR] (1994)(Apogee Software, Ltd.) [Action]/HOCUS.EXE;km_dosbox_pure_libretro.so"
	["Jazz Jackrabbit (1992)(Epic Megagames).sh"]="Microsoft - DOS;Jazz Jackrabbit (1992)(Epic Megagames)/JAZZ.EXE;km_dosbox_pure_libretro.so"
	["Lost Episodes of Doom.sh"]="Microsoft - DOS - DOOM;doom/lost-episodes-of-doom/DOOM.WAD;km_prboom_xtreme_libretro.so"
	["marble.zip"]="Arcade - 80s and Before;marble.zip;km_mame2003_plus_libretro.so"
	["moonwlkb.zip"]="Arcade - 90s and After;moonwlkb.zip;km_mame2003_plus_libretro.so"
	["ncv1.zip"]="Arcade - 90s and After;ncv1.zip;km_mame2010_libretro.so"
	["ncv2.zip"]="Arcade - 90s and After;ncv2.zip;km_mame2010_libretro.so"
	["Ninja Ryuuken Den III - Yomi no Hakobune (Japan).nes"]="Nintendo - Nintendo Entertainment System;Ninja Ryuuken Den III - Yomi no Hakobune (Japan).nes;km_fceumm_libretro.so"
	["Number Munchers (1990)(MECC) [Action, Educational][!].sh"]="Microsoft - DOS;Number Munchers (1990)(MECC) [Action, Educational][!]/NM.EXE;km_dosbox_pure_libretro.so"
	["Oregon Trail, The v2.0 (1990)(MECC) [Adventure, Educational, Role-Playing (RPG), Simulation, Strategy].sh"]="Microsoft - DOS;Oregon Trail, The v2.0 (1990)(MECC) [Adventure, Educational, Role-Playing (RPG), Simulation, Strategy]/OREGON.EXE;km_dosbox_pure_libretro.so"
	["outrun.zip"]="Arcade - 80s and Before;outrun.zip;km_mame2003_plus_libretro.so"
	["Perdition's Gate.sh"]="Microsoft - DOS - DOOM;doom/perditions-gate/DOOM2.WAD;km_prboom_xtreme_libretro.so"
	["polepos.zip"]="Arcade - 80s and Before;polepos.zip;km_mame2010_libretro.so"
	["polepos2.zip"]="Arcade - 80s and Before;polepos2.zip;km_mame2010_libretro.so"
	["Quake Episode 5 (dopa).sh"]="Microsoft - DOS - Quake;quake/dopa/pak0.pak;km_tyrquake_libretro.so"
	["Quake Mission Pack 1 (hipnotic).sh"]="Microsoft - DOS - Quake;quake/hypnotic/pak0.pak;km_tyrquake_libretro.so"
	["Quake Mission Pack 2 (rogue).sh"]="Microsoft - DOS - Quake;quake/rogue/pak0.pak;km_tyrquake_libretro.so"
	["Quake.sh"]="Microsoft - DOS - Quake;quake/id1/pak0.pak;km_tyrquake_libretro.so"
	["salmndr2.zip"]="Arcade - 90s and After;salmndr2.zip;km_mame2003_plus_libretro.so"
	["spiders.zip"]="Arcade - 80s and Before;spiders.zip;km_mame2003_plus_libretro.so"
	["Tyrian 2000 (1999)(XSIV Games) [Action].sh"]="Microsoft - DOS;Tyrian 2000 (1999)(XSIV Games) [Action]/Tyrian2k.exe;km_dosbox_pure_libretro.so"
	["Ultimate Doom.sh"]="Microsoft - DOS - DOOM;doom/ultimate-doom/DOOM.WAD;km_prboom_xtreme_libretro.so"
)
