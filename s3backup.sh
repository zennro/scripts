#! /bin/bash

if [[ $1 == "test" ]]; then
    mkdir ~/test_backup
    BACKUP_DIR=~/test_backup/
else
    /usr/bin/s3fs skipper-lenovo-laptop-backup /mnt/backup/s3 -ouse_cache=/tmp
    BACKUP_DIR=/mnt/backup/s3/
fi
/usr/bin/rsync -avrz --delete --inplace --stats --log-file=log.file --exclude-from=/home/skipper/src/scripts/exclude --files-from=/home/skipper/src/scripts/backup.files /home/skipper/ $BACKUP_DIR
mv log.file backup.log.`date +"%Y%m%d%H%M%S"`
if [[ $1 != "test" ]]; then
    /bin/umount /mnt/backup/s3
fi
