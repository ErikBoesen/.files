#!/usr/bin/env bash

for f in $(cd $HOME/.files/files; find . -type f); do
    bn=$(basename "$f")
    if [[ "$bn" == ".example"* ]]; then
        vim $HOME/${bn#.example}
    else
        ln -si $HOME/.files/files/$f $HOME/$f
    fi
done
