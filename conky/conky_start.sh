#! /bin/bash

if [[ "$(pidof conky)" ]]
then
# Sleep to make sure compiz starts first (not sure I need the other sleeps
# other than on todo and time
    killall conky
    sleep 10 &&
# add m 1 because it was picking up [virus] containment
    feh --bg-scale "`grep -m 1 'wallpaper=' ~/.kde/share/config/plasma-desktop-appletsrc | tail --bytes=+11`/contents/images/1920x1200.png"
# Stats Bar
    conky -d -c /home/skipper/conkyfiles/sysstats
# To Do
#    sleep 1 && conky -d -c /home/skipper/conkyfiles/todolist &
# Events
#sleep 1 && conky -d -c /home/skipper/conkyfiles/events &
# Time
#    sleep 1 && conky -d -c /home/skipper/conkyfiles/time &
# Date and Calendar
#    sleep 1 && conky -d -c /home/skipper/conkyfiles/calendar &
else
    sleep 10 &&
    feh --bg-scale "`grep -m 1 'wallpaper=' ~/.kde/share/config/plasma-desktop-appletsrc | tail --bytes=+11`/contents/images/1920x1200.png"
#    exec awn &
# Stats Bar
    conky -d -c /home/skipper/conkyfiles/sysstats
# To Do
#    sleep 1 && conky -d -c /home/skipper/conkyfiles/todolist &
# Events
#sleep 1 && conky -d -c /home/skipper/conkyfiles/events &
# Time
#    sleep 1 && conky -d -c /home/skipper/conkyfiles/time &
# Date and Calendar
#    sleep 1 && conky -d -c /home/skipper/conkyfiles/calendar &
    exit
fi
