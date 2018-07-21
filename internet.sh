#!/bin/bash
wifi_network="$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep " SSID" | sed 's/.*SSID: //')"
ip="$(ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}')"

if [[ -z $ip ]]; then
    printf "Ø"
else
    printf "☰ $ip"
fi

if ! [[ -z $wifi_network ]]; then
    printf " - $wifi_network"
fi
