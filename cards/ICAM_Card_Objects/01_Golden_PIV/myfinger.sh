#!/bin/sh

echo "This utility allows you to personalize an ICAM test card with
your own fingerprint for biometric testing purposes.  The basic steps
are:

  1. Use a PACS or validation tool to capture the text logs of the
     fingerprint TLVs from a card previously personalized with your
     fingerprint such as your (PIV, TWIC, PIV-I).
  2. Copy and paste the TLV text into the terminal window when prompted.
  3. Allow the script to merge your biometric data with the ICAM test card
     signature block, creating a new '9 - Fingerprints' file.
  4. At this point the signature of the CBEFF is invalid because the data
     is inconsistent. The FASC-N is the FASC-N from your own card, and
     other CBEFF fields are inconsistent with the signature.
  5. Use the signing tool to sign the '9 - Fingerprints' file.  This will
     change the FASC-N to the appropriate ICAM test card FASC-N for the
     ICAM Test Card you are working with.
"

echo -n "Before going any further, copy the TLV data from your own card
into the clipboard buffer.  IMPORTANT: It should consist of one line of
text.

"

echo -n "Press <ENTER> and paste fingerprint TLV hex dump, press <ENTER> and <CTL-D>: "

# Capture log data
cat >finger.txt.tmp
tail -1 finger.txt.tmp >finger.txt

# Convert to binary
text2bin.pl finger.txt >/dev/null

# Parse out header and FMR
finger.pl finger.bin >/dev/null

# Parse out the header, FMR, and signature from the ICAM Test Card CBEFF
cp 9\ -\ Fingerprints finger1.bin
finger.pl finger1.bin >/dev/null

# Compute the total size of the object and re-create the tag and length
SIZE=0
for S in $(stat -c "%s" finger.cbeffhdr finger.fmr finger1.cms); do
	SIZE=$(expr $SIZE + $S)
done
HSIZE=$(printf "%04x" $SIZE)

SBSIZE=$(stat -c "%s" finger1.cms)
SBHSIZE=$(printf "%04x" $SBSIZE)

B1=$(echo $HSIZE | cut -b 1-2)
B2=$(echo $HSIZE | cut -b 3-4)
echo -n -e "\\xbc\\x82\\x$B1\\x$B2" >finger2.bc

# Update the SB field in the CBEFF heaader
B1=$(echo $SBHSIZE | cut -b 1-2)
B2=$(echo $SBHSIZE | cut -b 3-4)

dd if=finger.cbeffhdr bs=1 count=6 of=p1 >/dev/null 2>&1
echo -n -e "\\x$B1\\x$B2" >p2
dd if=finger.cbeffhdr bs=1 skip=8 of=p3 >/dev/null 2>&1
cat p1 p2 p3 >finger.cbeffhdr

echo -n -e "\\xfe\\x00" >finger2.fe

# Back up original and splice the various pieces together
cp -p 9\ -\ Fingerprints 9\ -\ Fingerprints.$$
cat finger2.bc finger.cbeffhdr finger.fmr finger1.cms finger2.fe >9\ -\ Fingerprints

rm -f finger.* finger1.* finger2.*

cp -p 9\ -\ Fingerprints finger.bin

finger.pl finger.bin

echo -n "Press <ENTER> to use the Java Card Builder tool to sign \"9 - Fingerprints\".: "
read ans

pushd ../../src
sh start-signer.sh &

exit
