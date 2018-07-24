#!/bin/sh
cp -p '10 - Face Object Untampered' face.bin
SIZE=$(stat --format="%s" face.bin)
dd if=face.bin bs=1 count=2430 of=p1 2>/dev/null
echo -e -n "\\xff\\xfe\\xfd\\xfb" >p2
dd if=face.bin bs=1 skip=2434 of=p3 2>/dev/null
cat p1 p2 p3 >p4
mv p4 '10 - Face Object' # Tampered
rm -f p* face.bin
cp -p ../05_Tampered_Certificates/'10 - Face Object' '10 - Face Object Untampered'
