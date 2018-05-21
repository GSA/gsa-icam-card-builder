#!/bin/sh
cp -p '10 - Face Object' face.bin
SIZE=$(stat --format="%s" face.bin)
dd if=face.bin bs=1 count=430 of=p1 2>/dev/null
echo -e -n "\\xff" >p2
dd if=face.bin bs=1 skip=431 of=p3 2>/dev/null
cat p1 p2 p3 >p4
mv p4 '10 - Face Object'
rm -f p* face.bin
