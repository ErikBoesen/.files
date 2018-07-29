#!/bin/bash

# Exit if any command fails.
set -e

if ! type realpath &>/dev/null; then
    function realpath { python -c "from os.path import realpath; print(realpath('$1'))"; }
fi

source="$1"
dest="$2"
script_dir="$(realpath "$0")"

echo "Source: $source"
echo "Destination: $dest"
echo "Script directory: $script_dir"

echo "Sanity checking file type..."
if [[ ! -f "$source" ]]; then
    echo "$source is not a regular file! Terminating." >&2
    exit 1
fi

mv "$source" "$dest"
ln -s "$dest" "$source"

echo "Success!"
