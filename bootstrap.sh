#!/usr/bin/env bash

CYAN="\e[36m"
GREEN="\e[32m"
RESET="\e[0m"

function install {
    dir="$1"
    for f in $(cd $dir; find . -type f); do
        bn=$(basename "$f")
        if [[ "$bn" == ".example"* ]]; then
            if ! [[ -e $HOME/$(dirname "$f")/${bn#.example} ]]; then
                cp "$dir/$f" $HOME/$(dirname "$f")/${bn#.example}
                vim $HOME/${bn#.example}
                chmod 600 $HOME/${bn#.example}
            else
                echo "Ya existe archivo privado ${bn#.example}."
            fi
        else
            echo "$(realpath $dir/$f) -> $HOME/${f#./}"
            ln -sf $(realpath $dir/$f) $HOME/${f#./}
        fi
    done
}

dfroot="$(dirname $(realpath $0))"
install files
install $dfroot/files_$(hostname)
