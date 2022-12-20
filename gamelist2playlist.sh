#!/bin/bash

# settings
set -o errexit
set -o nounset
set -o pipefail
[[ "${TRACE-0}" == "1" ]] && set -o xtrace

# include
source ./_utils-lib.sh

# variables
declare script_name
script_name=$(basename "${0}")
declare playlist
declare playlists_dir
declare system_db

# usage
if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    echo "Usage: ./${script_name} gamelist system_db playlists_dir rom_path core_path core_name"
    exit
fi

# helper functions
intro_gen() {
    {
        echo "{"
        echo "  \"version\": \"1.0\","
        echo "  \"items\": ["
    }
}

path_gen() {
    local line="$1"
    # Strip off beginning ./
    local path_map
    mapfile -t path_map < <(echo "$line" | grep -Pio 'path>\.\/\K[^<]*')
    local path="${path_map[0]}"
    local json_path=${path//&amp;/&}

    {
        echo "    {"
        echo "      \"path\": \"${rom_path}/${json_path}\","
    }

    if [ "$system_db" = "coleco" ]; then
        {
            echo "      \"subsystem_roms\": ["
            echo "        \"${rom_path}/${system_db}/${json_path}\""
            echo "      ],"
            echo "      \"subsystem_ident\": \"cv\","
            echo "      \"subsystem_name\": \"ColecoVision\","
        }
    fi
}

label_gen() {
    local line="$1"
    local name_map
    mapfile -t name_map < <(echo "$line" | grep -Pio 'name>\K[^<]*')
    local name="${name_map[0]}"
    name=$(sed 's/^ /!!!/' <<< $name)
    local json_name=${name//&amp;/&}

    {
        echo "      \"label\": \"${json_name}\","
    }
}

body_gen() {
    # todo add support for specific cores via array you pull in optionally from file

    {
        echo "      \"core_path\": \"${core_path}/${core_name}\","
        echo "      \"core_name\": \"${core_name}\","
        echo "      \"crc32\": \"DETECT\","
        echo "      \"dbname\": \"${system_db}.lpl\""
        echo -n "    }"
    }
}

outro_gen() {
    {
        echo ""
        echo "  ]"
        echo "}"
    }
}

# main function
main() {
    # check_inputs
    gamelist="$1"
    [[ "$gamelist" = "" ]] && echo "Missing gamelist" && exit 1

    system_db="$2"
    [[ "$system_db" = "" ]] && echo "Missing system_db" && exit 1

    playlists_dir="$3"
    [[ "$playlists_dir" = "" ]] && echo "Missing playlists_dir" && exit 1

    rom_path="$4"
    [[ "$rom_path" = "" ]] && echo "Missing rom_path" && exit 1

    core_path="$5"
    [[ "$core_path" = "" ]] && echo "Missing core_path" && exit 1

    core_name="$6"
    [[ "$core_name" = "" ]] && echo "Missing core_name" && exit 1

    playlist="${playlists_dir}/${system_db}.lpl"
    intro_gen

    local first_time="true"
    local line
    grep -e \<path\> -e \<name\> "$gamelist" | while read -r line ; do
        if [[ "$line" == *"<path"* ]]; then
            if [ "$first_time" = "false" ]; then
                {
                    echo ","
                }
            fi

            first_time="false"
            path_gen "$line"
        elif [[ "$line" == *"<name"* ]]; then
            label_gen "$line"
            body_gen
        fi
    done

    outro_gen
}

main "${@}"
