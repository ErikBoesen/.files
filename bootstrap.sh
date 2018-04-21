#!/usr/bin/env bash

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
            ln -si $dir/${f#./} $HOME/${f#./}
        fi
    done
}

install files
install files_$(hostname)
