#! /bin/bash

. /home/skipper/src/scripts/utilities.sh

#################
##   Dropbox   ##
#################
# run dropbox only if you have a working internet connection
if internet_up
then
    /home/skipper/src/.dropbox-dist/dropboxd &
fi
