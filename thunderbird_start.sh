#! /bin/bash

. /home/skipper/src/scripts/utilities.sh

##################
##  Thunderbid  ##
##################
# run dropbox only if you have a working internet connection
if internet_up
then
    thunderbird &
fi
