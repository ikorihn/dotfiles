#!/usr/bin/osascript

on run argv
    set micVolume to (item 1 of argv)
    adjustVolume(micVolume)
    display notification ("Set mic volume to " & micVolume) with title "Mic"
    return micVolume
end run

on adjustVolume(vol)
    set volume input volume vol
end adjustVolume
