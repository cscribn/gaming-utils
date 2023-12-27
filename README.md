# RetroPie-Utils

All scripts are tested using Git Bash on Windows.

Getting help

```sh
<script_name> -h
```

## 7z2zip.sh

Convert 7-zip files to zip files.

## cfg-replace.sh

Replace/add values to retroarch cfgs like `retroarch.cfg` and `retroarch-core-options.cfg`.

## cfg-specific-generate.sh

Generate folder-, core-, or rom-specific retroarch configurations. Useful for turbo and other settings that tend to differ per machine. See `./lib/cfg.sample.sh` for a sample library file. This script is for advanced users.

## emulators-name-clean.sh

Return the EmulationStation "clean" names for roms. For use in `emulators.cfg` when assigning specific emulators to specific roms.

## favorites-update.sh

Create favorites for each of your gamelists by inserting a space in front of rom names, so they sort to the top. This script assumes you used SkraperUI to generate your gamelist and thumbnails, and that you've run skraper-fix.sh for the given system.

## rom2m3u.sh

Create an m3u playlist file for your roms. "Disk" parts of rom name will be stripped off for comparison.
