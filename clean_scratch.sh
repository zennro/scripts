#! /usr/bin

kdialog "The ~/scratch/ directory will be emptied in 1 minute." 5
sleep 60
rm -rf /home/skipper/scratch/* 
