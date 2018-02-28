#!/usr/bin/env bash

for f in $(ls -A files); do
    echo $f...
    ln -si $f ~
done
