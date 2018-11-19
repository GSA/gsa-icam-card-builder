#!/bin/sh
#
# Create the command to populate the certsIssuedToICAMTestCardBridgeCA.p7c file like this:
#

echo "rm -f Intermediate_Bridge_Certs.p7b" >/tmp/t.$$.sh
ls [0-3]*.crt ICAM_Test_Card_Bridge_CA.crt | awk 'BEGIN { printf ("openssl crl2pkcs7 -nocrl -outform der -out ../aia/certsIssuedToICAMTestCardBridgeCA.p7c ") } { printf("-certfile %s ", $1) }' >>/tmp/t.$$.sh
echo >>/tmp/t.$$.sh

echo "ln -s ../aia/certsIssuedToICAMTestCardBridgeCA.p7c Intermediate_Bridge_Certs.p7b" >>/tmp/t.$$.sh

#
# Create the command to populate the certsIssuedToICAMTestCardRootCA.p7c file like this:
#

echo "openssl crl2pkcs7 -nocrl -outform der -out ../aia/certsIssuedToICAMTestCardRootCA.p7c -certfile 99_ICAM_Test_Card_Bridge_CA_to_ICAM_Test_Card_Root_CA.crt" >>/tmp/t.$$.sh

sh /tmp/t.$$.sh
rm -f /tmp/t.$$.sh
