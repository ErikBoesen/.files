#!/usr/bin/env bash

for f in $(ls -A1 files); do
    echo $f...
    ln -si $HOME/.files/files/$f $HOME/$f
done
