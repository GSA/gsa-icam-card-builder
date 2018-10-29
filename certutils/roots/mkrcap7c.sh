#!/bin/sh
#
# Create the command to populate the certsIssuedToICAMTestCardBridgeCA.p7c file like this:
#

echo "rm -f Trust_Anchors.p7b" >/tmp/t.$$.sh
ls [0-3]*.crt | awk 'BEGIN { printf ("openssl crl2pkcs7 -nocrl -outform der -out Trust_Anchors.p7b ") } { printf("-certfile %s ", $1) }' >>/tmp/t.$$.sh
echo >>/tmp/t.$$.sh
sh /tmp/t.$$.sh
rm -f /tmp/t.$$.sh