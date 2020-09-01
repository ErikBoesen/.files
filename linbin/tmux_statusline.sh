#!/bin/bash

status=""
div=" #[fg=colour240]// "

spotify="$(spotify.py)"
if ! [[ -z $spotify ]]; then
    status+="#[fg=colour2]${spotify}${div}"
fi

status+="#[fg=blue]$(internet.sh)${div}"
status+="$(temp.py)${div}"
# TODO: Use real analog clock
status+="#[fg=red]◶"

echo "$status"
