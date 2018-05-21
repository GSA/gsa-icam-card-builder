#!/bin/sh
cp -p '8 - CHUID Object' chuid.bin
SIZE=$(stat --format="%s" chuid.bin)
dd if=chuid.bin bs=1 count=2 of=p1 2>/dev/null
echo -e -n "\\xd1\\x37\\x14\\x22\\x28\\xab\\x6c\\x10\\xc3\\x39\\xe5\\xa1\\x68\\x5a\\x08\\xc9\\x2a\\xde\\x0a\\x61\\x84\\xe7\\x39\\xc3\\xe7" >p2
dd if=chuid.bin bs=1 skip=27 of=p3 2>/dev/null
cat p1 p2 p3 >p4
mv p4 '8 - CHUID Object'
rm -f p* chuid.bin
