#!/bin/bash

status=""
div=" #[fg=colour240]// "

spotify="$(~/.bin/spotify.py)"
if ! [[ -z $spotify ]]; then
    status+="#[fg=colour2]${spotify}${div}"
fi

status+="#[fg=blue]$(internet.sh)${div}"
status+="$(temperature.py)${div}"
status+="#[fg=red]⧖"

echo "$status"
