#!/usr/bin/env osascript

set volume_settings to (get volume settings)
set output to get output volume of volume_settings
set muted  to get output muted  of volume_settings

log "Output: " & output & "%"
log "Muted: " & muted
