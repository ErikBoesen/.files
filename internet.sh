#!/bin/bash
wifi_status="$(networksetup -getairportpower en0 | awk '{print $4}')"
ip="$(ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}')"

# TODO: Differentiate between ethernet and WiFi connection
# TODO: Differentiate between actual internet connection and WiFi just being on
if [[ $wifi_status == "On" ]]; then
    printf "☰ $ip"
else
    printf "Ø"
fi
