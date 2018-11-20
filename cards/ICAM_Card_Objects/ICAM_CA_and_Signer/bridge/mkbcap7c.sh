#!/bin/sh
#
# Create the command to populate the certsIssuedToICAMTestCardBridgeCA.p7c file like this:
#

# Make separate .p7c files

for F in $(ls *.crt); do
  AIA=$(openssl x509 -in $F -text -noout | grep /aia/ | sed s'!^.*aia/!!g')
  if [ z$AIA != "z" ]; then
    openssl crl2pkcs7 -certfile $F -nocrl -outform der -out ../aia/$AIA
  fi
done

echo "rm -f Intermediate_Bridge_Certs.p7b" >/tmp/t.$$.sh
ls [0-3]*.crt ICAM_Test_Card_Bridge_CA.crt | awk 'BEGIN { printf ("openssl crl2pkcs7 -nocrl -outform der -out ../aia/certsIssuedToICAMTestCardBridgeCA.p7c ") } { printf("-certfile %s ", $1) }' >>/tmp/t.$$.sh
echo >>/tmp/t.$$.sh

echo "ln -s ../aia/certsIssuedToICAMTestCardBridgeCA.p7c Intermediate_Bridge_Certs.p7b" >>/tmp/t.$$.sh

#
# Create the command to populate the certsIssuedToICAMTestCardRootCA.p7c file like this:
#

echo "openssl crl2pkcs7 -nocrl -outform der -out ../aia/certsIssuedToICAMTestCardRootCA.p7c -certfile 99_ICAM_Test_Card_Bridge_CA_to_ICAM_Test_Card_Root_CA.crt -certfile ../roots/00_ICAM_Test_Card_Root_CA.crt" >>/tmp/t.$$.sh

sh /tmp/t.$$.sh
rm -f /tmp/t.$$.sh
