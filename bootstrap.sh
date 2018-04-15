#!/usr/bin/env bash

dfroot="$(dirname $(realpath $0))/files"

for f in $(cd $dfroot; find . -type f); do
    bn=$(basename "$f")
    if [[ "$bn" == ".example"* ]] && ! [[ -e $HOME/${bn#.example} ]]; then
        cp "$HOME/.files/files/$f" $HOME/${bn#.example}
        vim $HOME/${bn#.example}
        chmod 600 $HOME/${bn#.example}
    else
        ln -si $dfroot/${f#./} $HOME/${f#./}
    fi
done
