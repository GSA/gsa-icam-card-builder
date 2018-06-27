## Tampered Security Object ##

After signing the all of the objects on card, run the script, "alterso.sh" which  will change four bytes in in the security object signature so that the security objects's signature is invalid.

```
#!/bin/sh
cp -p '2 - Security Object' so.bin
SIZE=$(stat --format="%s" so.bin)
OFFSET1=$(expr $SIZE - 16)
OFFSET2=$(expr $OFFSET1 + 4)
dd if=so.bin bs=1 count=$OFFSET1 of=p1 2>/dev/null
echo -e -n "\\xff\\xff\\xff\\xff" >p2
dd if=so.bin bs=1 skip=$OFFSET2 of=p3 2>/dev/null
cat p1 p2 p3 >p4
mv p4 '2 - Security Object'
rm -f p* so.bin

```
