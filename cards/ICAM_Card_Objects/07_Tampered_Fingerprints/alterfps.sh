#!/bin/sh
cp -p '9 - Fingerprints' finger.bin
SIZE=$(stat --format="%s" finger.bin)
dd if=finger.bin bs=1 count=500 of=p1 2>/dev/null
echo -e -n "\\xff\\xff\\xff\\xff" >p2
dd if=finger.bin bs=1 skip=504 of=p3 2>/dev/null
cat p1 p2 p3 >p4
mv p4 '9 - Fingerprints'
rm -f p* finger.bin
