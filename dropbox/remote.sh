#!/bin/bash

REMOTEFOLD="${HOME}/Dropbox/remote"
COMFOLD="${REMOTEFOLD}/commands"
OUTFOLD="${REMOTEFOLD}/output"
OLDFOLD="${REMOTEFOLD}/old"

cd "$COMFOLD"
for i in *
do
    if [ -f "$i" ]
    then
        chmod +x "$i"
        echo "==== Start: `date` ====" >> "${OUTFOLD}/${i}.log"
        "./${i}" >> "${OUTFOLD}/${i}.log" 2>&1
        echo "===== End: `date` =====" >> "${OUTFOLD}/${i}.log"
        echo >> "${OUTFOLD}/${i}.log"
        mv -t "${OLDFOLD}" "$i"
    fi
done
