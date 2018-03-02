#!/usr/bin/env bash

for f in $(cd $HOME/.files/files; find . -type f); do
    ln -si $HOME/.files/files/$f $HOME/$f
done
