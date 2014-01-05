#! /bin/bash

. /home/skipper/src/scripts/utilities.sh

######################
##      Conky       ##
######################

function emulate_background {
    # for background transparency emulation. uncomment if using a wallpaper
    # add m 1 because it was picking up [virus] containment
    local fname=~/.kde/share/config/plasma-desktop-appletsrc
    local wallpaper=/contents/images/1920x1200.png
    feh --bg-scale "`grep -m 1 'wallpaper=' $fname | tail --bytes=+11`$wallpaper"
}

function conky_start {
    # these are expected to live in the below directory
    local conkyfile=$1
    conky -d -c /home/skipper/src/scripts/conky/$conkyfile
}

if is_running conky
then
    killall conky
fi
emulate_background
conky_start laptopstats
conky_start clock
