#!/usr/bin/osascript

tell application "System Events" to tell process "SystemUIServer"
    value of attribute "AXDescription" of menu bar items of menu bar 1
end tell
