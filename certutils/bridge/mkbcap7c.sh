#!/bin/sh
#
# Create the command to populate the certsIssuedToICAMTestCardBridgeCA.p7c file like this:
#
ls [0-3]*.crt ../ICAM_Test_Card_PIV_Root_CA_-_gold_gen1-3.crt ICAM_Test_Card_Bridge_CA.crt | awk 'BEGIN { printf ("openssl crl2pkcs7 -nocrl -outform der -out ../aia/certsIssuedToICAMTestCardBridgeCA.p7c ") } { printf("-certfile %s ", $1) }' >/tmp/t.sh
sh /tmp/t.sh
