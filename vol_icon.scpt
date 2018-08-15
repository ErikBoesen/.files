#!/usr/bin/env osascript

set volume_settings to (get volume settings)
set output to (get output volume of volume_settings)
set muted  to (get output muted  of volume_settings)

set icon to "<"
if muted then
    set icon to icon & "-"
else if output is 100 then
    set icon to icon & "))))"
else if output > 75 then
    set icon to icon & ")))"
else if output > 50 then
    set icon to icon & "))"
else if output > 25 then
    set icon to icon & ")"
end if

log icon
