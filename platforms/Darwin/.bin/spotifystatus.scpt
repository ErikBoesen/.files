#!/usr/bin/env osascript
tell application "Spotify"
    if it is running then
        if player state is playing
            set status_icon to "▶"
        else
            set status_icon to "||"
        end if
        set track_name to name of current track
        set AppleScript's text item delimiters to " ("
        set track_name to text item 1 of track_name
        if the length of track_name is greater than 35 then
            # Arrays start at zero, you sick sick people
            set track_name to characters 1 thru 30 of track_name & "..."
        end if

        set artist_name to artist of current track

        status_icon & " " & artist_name & " - " & track_name
    end if
end tell

