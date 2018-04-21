#!/usr/bin/env bash

CYAN="\e[36m"
GREEN="\e[32m"
RESET="\e[0m"

function install {
    dir="$1"
    for f in $(cd $dir; find . -type f); do
        bn=$(basename "$f")
        mkdir -p $HOME/$(dirname "$f")
        if [[ "$bn" == ".example"* ]]; then
            if ! [[ -e $HOME/$(dirname "$f")/${bn#.example} ]]; then
                cp "$dir/$f" $HOME/$(dirname "$f")/${bn#.example}
                vim $HOME/${bn#.example}
                chmod 600 $HOME/${bn#.example}
            else
                printf "Ya existe archivo privado ${bn#.example}.\n"
            fi
        else
            printf "${CYAN}$(realpath $dir/$f)${RESET} -> ${GREEN}~/${f#./}${RESET}\n"
            ln -sf $(realpath $dir/$f) $HOME/${f#./}
        fi
    done
}

dfroot="$(dirname $(realpath $0))"
install $dfroot/files
install $dfroot/files_$(hostname)
