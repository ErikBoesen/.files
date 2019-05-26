#!/bin/bash

# Exit if any command fails.
set -e

if [[ $# -lt 1 ]]; then
    echo "usage: $0 source [destination]"
    exit 1
fi

if ! type realpath &>/dev/null; then
    function realpath { python -c "from os.path import realpath; print(realpath('$1'))"; }
fi

source="$1"
dest="$2"
script_dir="$(dirname "$(realpath "$0")")"
if [[ -z "$dest" ]]; then
    dest="$script_dir/global"
fi

echo "Source: $source"
echo "Destination: $dest"
echo "Script directory: $script_dir"

mv "$source" "$dest/${source#"$HOME"}"
ln -s "$dest/${source#"$HOME"}" "$source"

echo "Success!"
