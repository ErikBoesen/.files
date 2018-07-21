#!/bin/bash
wifi_network="$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | sed 's/.*SSID: //'
ip="$(ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}')"

# TODO: Differentiate between ethernet and WiFi connection
if [[ -z $wifi_network ]]; then
    printf "Ø"
else
    printf "☰ $ip - $wifi_network"
fi
