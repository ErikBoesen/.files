#!/usr/bin/env bash

for f in $(ls -A files); do
    echo $f...
    ln -si $HOME/.files/files/$f $HOME/$f
done
