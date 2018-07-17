#!/bin/bash

battery="$(ioreg -l | awk '$3~/Capacity/{c[$3]=$5}END{OFMT="%.0f";max=c["\"MaxCapacity\""];print(max>0?100*c["\"CurrentCapacity\""]/max:"?")}')"
# Returns "Yes" or "No"
charging="$(ioreg -l | grep "IsCharging" | awk '{print $5}')"
if [[ $charging == "Yes" ]]; then
    printf "#[fg=blue]"
    #printf "\e[34m"
elif [[ "$battery" -gt 75 ]]; then
    printf "#[fg=green]"
    #printf "\e[32m"
elif [[ "$battery" -gt 50 ]]; then
    printf "#[fg=yellow]"
    #printf "\e[33m"
elif [[ "$battery" -gt 25 ]]; then
    printf "#[fg=colour202]"
    #printf "\e[1;38;5;202m"
else
    printf "#[fg=red]"
    #printf "\e[31m"
fi
#printf "${battery}%%\e[0m"
printf "${battery}%%#[fg=white]"
