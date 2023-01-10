# RetroPie-Utils

All scripts are tested using Git Bash on Windows.

Getting help

```sh
<script_name> -h
```

## 7z2zip.sh

Convert 7-zip files to zip files.

## catver-unique.sh

Get all the unique values from a catver ini file.

## cfg-specific-generate.sh

Generate folder-, core-, or rom-specific retroarch configurations. Useful for turbo and other settings that tend to differ per machine. See `./lib/cfg.example.sh` for an example library file. This script is for advanced users.

## cfg-replace.sh

Replace/add values to retroarch cfgs like `retroarch.cfg` and `retroarch-core-options.cfg`.

## emulators-name-clean.sh

Return the EmulationStation "clean" names for roms. For use in `emulators.cfg` when assigning specific emulators to specific roms.

## favorites-update.sh

Create favorites for each of your gamelists by inserting a space in front of rom names, so they sort to the top. This script assumes you used SkraperUI to generate your gamelist and thumbnails, and that you've run skraper-fix.sh for the given system.

## game2playlist.sh

Convert an EmulationStation gamelist to a Retroarch playlist. See `./lib/special.example.sh` for an optional example of how to handle special paths or cores for specific games.

## miniclassics-cores-wget.sh

Download the latest nightly psclassic and segamini cores from modmyclassiccloud. Assumes wget is installed and in your path.
