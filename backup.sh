#!/bin/bash

function quit {
    exit
}

function backup {
    rsync -avrlptg --delete /home/skipper/ /media/passport/backup --exclude-from=/home/skipper/.rsync/exclude
}

volume="/media/passport"
if mount | grep "on ${volume} type" > /dev/null
then
    backup
else
    echo "not mounted"
    mount $volume
    if ! mount | grep "on ${volume} type" > /dev/null
    then
        echo "Could not mount passport for backup"
        quit
    else
        backup
    fi
fi
