# RetroPie-Utils

All scripts are tested using Git Bash on Windows.

Getting help

```sh
<script_name> -h
```

## cfg-specific-generate.sh

Generate folder-, core-, or rom-specific retroarch configurations. Useful for turbo and other settings that tend to differ per machine. See ./lib/cfg.example.sh for an example library file. This script is for advanced users.

## cfg-replace.sh

Replace/add values to retroarch cfgs like retroarch.cfg and retroarch-core-options.cfg.

## favorites-update.sh

Create favorites for each of your gamelists by inserting a space in front of rom names, so they sort to the top. This script assumes you used SkraperUI to generate your gamelist and thumbnails, and that you've run skraper-fix.sh for the given system.

## game2playlist.sh

Convert an EmulationStation gamelist to a Retroarch playlist.
