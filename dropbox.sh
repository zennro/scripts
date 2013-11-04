#! /bin/bash

# allow some setup time
sleep 10 
# run dropbox only if you have a working internet connection
((ping -w5 -c3 8.8.8.8 || ping -w5 -c3 4.2.2.1) > /dev/null 2>&1) && (/home/skipper/src/.dropbox-dist/dropboxd &) || (exit 1)
