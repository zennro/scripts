#! /bin/bash

if [[ $1 == "test" ]]; then
    mkdir ~/test_backup
    BACKUP_DIR=~/test_backup/
else
    /usr/bin/s3fs skipper-lenovo-laptop-backup /mnt/backup/s3 -ouse_cache=/tmp
    BACKUP_DIR=/mnt/backup/s3/
fi
export DISPLAY=:0
export XAUTHORITY=/home/skipper/.Xauthority
kdialog --passivepopup "Your S3 backup job has started" 5
/usr/bin/rsync -avrz --delete --inplace --stats -h --partial --log-file=log.file --exclude-from=/home/skipper/src/scripts/exclude --files-from=/home/skipper/src/scripts/backup.files /home/skipper/ $BACKUP_DIR
mv log.file backup.log.`date +"%Y%m%d%H%M%S"`
if [[ $1 != "test" ]]; then
    /bin/fusermount -u /mnt/backup/s3
fi
kdialog --passivepopup "Your S3 backup job has completed" 5
