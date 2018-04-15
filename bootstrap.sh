#!/usr/bin/env bash

for f in $(cd $HOME/.files/files; find . -type f); do
    bn=$(basename "$f")
    if [[ "$bn" == ".example"* ]]; then
        cp "$HOME/.files/files/$f" $HOME/${bn#.example}
        vim $HOME/${bn#.example}
        chmod 600 $HOME/${bn#.example}
    else
        ln -si $HOME/.files/files/$f $HOME/$f
    fi
done
