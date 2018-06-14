#!/bin/sh
#
# Create the command to populate the certsIssuedToICAMTestCardRootCA.p7c file like this:
#
openssl crl2pkcs7 -nocrl -outform der -out ../aia/certsIssuedToICAMTestCardRootCA.p7c -certfile 99_ICAM_Test_Card_Bridge_CA_to_ICAM_Test_Card_Root_CA.crt
