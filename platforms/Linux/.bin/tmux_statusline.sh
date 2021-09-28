#!/bin/bash

python3 <<'EOF'
animal_emotes = {
    'viper': '🐍',
    'hornet': '🐝',
    'cricket': '🪳',
    'newt': '🦎',
    'termite': '🐜',
    'python': '🐍',
    'cicada': '🪰',
    'bumblebee': '🐝',
    'cobra': '🐍',
    'frog': '🐸',
    'tick': '🪳',
    'turtle': '🐢',
    'aphid': '🪲',
    'ladybug': '🐞',
    'chameleon': '🦎',
    'rattlesnake': '🐍',
    'scorpion': '🦂',
    'perch': '🐟',
    'dolphin': '🐬',
    'kangaroo': '🦘',
    'hippo': '🦛',
    'swan': '🦢',
    'gator': '🐊',
    'jaguar': '🐆',
    'rhino': '🦏',
    'grizzly': '🐻',
    'macaw': '🐦',
    'monkey': '🐵',
    'cardinal': '🦩',
    'peacock': '🦚',
    'lion': '🦁',
    'giraffee': '🦒',
    'hare': '🐇',
    'raven': '🐧',
    'tiger': '🐅',
    'hawk': '🦅',
    'woodpecker': '🦤',
    'zebra': '🦓',
}
import socket
host = socket.gethostname().split('.')[0]
emoji = animal_emotes.get(host, '☾')
print('#[fg=yellow]' + emoji + ' ' + host)
EOF

#status=""
#div=" #[fg=colour240]// "

#spotify="$(spotify.py)"
#if ! [[ -z $spotify ]]; then
#    status+="#[fg=colour2]${spotify}${div}"
#fi
#
#status+="#[fg=blue]$(internet.sh)${div}"
#status+="$(temp.py)${div}"
## TODO: Use real analog clock
#status+="#[fg=red]◶"

#echo "$status"
