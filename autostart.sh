#! /bin/bash

#######################
## Utility Functions ##
#######################

function is_running {
    (pidof $1) > /dev/null && return 0
    return 1
}

function internet_up {
    # check for if you have a working internet connection
    ((ping -w5 -c3 8.8.8.8 || ping -w5 -c3 4.2.2.1) > /dev/null 2>&1) && return 0
    return 1
}

# Sleep to make sure compiz starts first, internet is up, etc.
sleep 10

######################
##      Conky       ##
######################

function emulate_background {
    # for background transparency emulation. uncomment if using a wallpaper
    # add m 1 because it was picking up [virus] containment
    local fname=~/.kde/share/config/plasma-desktop-appletsrc
    local wallapper=/contents/images/1920x1200.png
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

#################
##   Dropbox   ##
#################
# run dropbox only if you have a working internet connection
if internet_up
then
    /home/skipper/src/.dropbox-dist/dropboxd &
fi

#################
##   Choqok    ##
#################
if internet_up
then
    choqok &
fi
