#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Adjust mic volume
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🎤
# @raycast.packageName Mic
# @raycast.argument1 { "type": "text", "placeholder": "volume" }

on run argv
    set micVolume to (item 1 of argv)
    adjustVolume(micVolume)
    display notification ("Set mic volume to " & micVolume) with title "Mic"
    return micVolume
end run

on adjustVolume(vol)
    set volume input volume vol
end adjustVolume
