#!/bin/bash

if ! type realpath &>/dev/null; then
    function realpath { python -c "from os.path import realpath; print(realpath('$1'))"; }
fi

source="$1"
dest="$2"
script_dir="$(realpath "$0")"

echo "Source: $source"
echo "Destination: $dest"
echo "Script directory: $script_dir"

mv "$source" "$dest"
ln -s "$dest" "$source"

echo "Success!"
