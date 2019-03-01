#!/bin/sh
#
# This makes the certs for all of the cards in the FIPS 201-2 card set.
# Note that if using the "CertiPath Load Tool" for certain types of high speed
# cards, all certs must use the names that Card 46 uses.  In fact, all data
# objects must be named the same.  To use the tool for cards other than Card 46,
# we need to rename the certs to conform with Card 46. 
#
. ./rename.sh

## Gen1-2 OCSP valid signer using RSA 2048 (RSA 2048 CA)
SUBJ=ICAM_Test_Card_PIV_OCSP_Valid_Signer_gen1-2
sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -t piv-ocsp-valid-gen1-2 -r 2048 --cakey rsa2048 || exit $?
DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
cp -p data/$SUBJ.p12 "$DEST"
cp -p data/pem/$SUBJ.crt "$DEST"

## Gen3 Secure Messaging Key Establishment using ECC P-256 with intermediate CVC (RSA 2048 CA)
SUBJ=ICAM_Test_Card_PIV_RSA_Issued_Intermediate_CVC_Signer
sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_RSA_2048_Signing_CA_-_gold_gen3 -t piv-content-signer-rsa-2048 -e prime256v1 --cakey rsa2048 || exit $?
DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
cp -p data/$SUBJ.p12 "$DEST"
cp -p data/pem/$SUBJ.crt "$DEST"

## Gen3 Revoked Content Signer
SUBJ=ICAM_Test_Card_PIV_Revoked_Content_Signer_gen3
sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -t piv-content-signer-gen3-rsa -r 2048 --cakey rsa2048 || exit $?
DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
cp -p data/$SUBJ.p12 "$DEST"
cp -p data/pem/$SUBJ.crt "$DEST"

## Gen3 Early expiring PIV Content signer using RSA 2048 (RSA 2048 CA) not a permanent ICAM test card
SUBJ=ICAM_Test_Card_PIV_Content_Signer_Expiring_-_gold_gen3 
sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -t piv-content-signer-gen3-rsa -r 2048 --cakey rsa2048 -x 201202000000Z || exit $?
DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
cp -p data/$SUBJ.p12 "$DEST"
cp -p data/pem/$SUBJ.crt "$DEST"

## Gen3 PIV-I Content signer using RSA 2048 (PIV-I Signing CA)
SUBJ=ICAM_Test_Card_PIV-I_Content_Signer_-_gold_gen3 
sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -t pivi-content-signer-gen3 -r 2048 --cakey rsa2048 || exit $?
DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
cp -p data/$SUBJ.p12 "$DEST"
cp -p data/pem/$SUBJ.crt "$DEST"

## Gen3 Secure Messaging Key Establishment using ECC P-256 with intermediate CVC (RSA 2048 CA)
SUBJ=ICAM_Test_Card_PIV_RSA_Issued_Intermediate_CVC_Signer
sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_RSA_2048_Signing_CA_-_gold_gen3 -t piv-content-signer-rsa-2048 -e prime256v1 --cakey rsa2048 || exit $?
DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
cp -p data/$SUBJ.p12 "$DEST"
cp -p data/pem/$SUBJ.crt "$DEST"

## Gen3 OCSP valid signer using RSA 2048 (RSA 2048 CA)
SUBJ=ICAM_Test_Card_OCSP_PIV_RSA_2048_Valid_Signer_gen3
sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_RSA_2048_Signing_CA_-_gold_gen3 -t piv-ocsp-valid-rsa-2048 -r rsa2048 --cakey rsa2048 || exit $?
DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
cp -p data/$SUBJ.p12 "$DEST"
cp -p data/pem/$SUBJ.crt "$DEST"

## Gen3 Secure Messaging Key Establishment using ECC P-256 (ECC P-384 CA)
SUBJ=ICAM_Test_Card_PIV_ECC_Issued_P-256_SM_Certificate_Signer_2
sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_P-384_Signing_CA_gold_gen3 -t piv-content-signer-gen3-p384 -e prime256v1 --cakey secp384r1 || exit $?
DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
cp -p data/$SUBJ.p12 "$DEST"
cp -p data/pem/$SUBJ.crt "$DEST"

## Gen3 Secure Messaging Key Establishment using ECC P-384 (ECC P-384 CA)
SUBJ=ICAM_Test_Card_PIV_ECC_Issued_P-384_SM_Certificate_Signer_3
sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_P-384_Signing_CA_gold_gen3 -t piv-content-signer-gen3-p384 -e secp384r1 --cakey secp384r1 || exit $?
DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
cp -p data/$SUBJ.p12 "$DEST"
cp -p data/pem/$SUBJ.crt "$DEST"

## OCSP Gen3 valid signer using (Gen 3 Signing CA)
SUBJ=ICAM_Test_Card_PIV_OCSP_Valid_Signer_gen3 
sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -t piv-ocsp-valid-gen3-rsa -r 2048 --cakey rsa2048 || exit $?
DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
cp -p data/$SUBJ.p12 "$DEST"
cp -p data/pem/$SUBJ.crt "$DEST"

## OCSP Gen3 valid signer using ECC P-384 (ECC P-384 Signing CA)
SUBJ=ICAM_Test_Card_PIV_OCSP_Valid_Signer_P384_gen3 
sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_P-384_Signing_CA_gold_gen3 -t piv-ocsp-valid-gen3-p384 -e secp384r1 --cakey secp384r1 || exit $?
DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
cp -p data/$SUBJ.p12 "$DEST"
cp -p data/pem/$SUBJ.crt "$DEST"

## Gen3 OCSP expired signer using RSA 2048 (Gen 3 PIV Signing CA)
SUBJ=ICAM_Test_Card_PIV_OCSP_Expired_Signer_gen3 
sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -t piv-ocsp-expired -r 2048 --cakey rsa2048 -x 171202000000Z || exit $?
DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
cp -p data/$SUBJ.p12 "$DEST"
cp -p data/pem/$SUBJ.crt "$DEST"

## Gen3 OCSP revoked signer with id-pkix-ocsp-nocheck present using RSA 2048 (Gen 3 PIV Signing CA)
SUBJ=ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Present_gen3 
sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -t piv-ocsp-revoked-nocheck-present -r 2048 --cakey rsa2048 || exit $?
DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
cp -p data/$SUBJ.p12 "$DEST"
cp -p data/pem/$SUBJ.crt "$DEST"

## Gen3 OCSP revoked signer with id-pkix-ocsp-nocheck NOT present using RSA 2048 (Gen 3 PIV Signing CA)
SUBJ=ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Not_Present_gen3 
sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -t piv-ocsp-revoked-nocheck-not-present -r 2048 --cakey rsa2048 || exit $?
DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
cp -p data/$SUBJ.p12 "$DEST"
cp -p data/pem/$SUBJ.crt "$DEST"

## Gen3 OCSP invalid signature using RSA 2048 (Gen 3 PIV Signing CA)
SUBJ=ICAM_Test_Card_PIV_OCSP_Invalid_Sig_Signer_gen3
NAME=$(echo $SUBJ | sed 's/[&_]/ /g')
sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -t piv-ocsp-invalid-sig -r 2048 --cakey rsa2048 || exit $?

# Extract private/publilc keys from the .p12
openssl pkcs12 -in data/$SUBJ.p12 -nocerts -nodes -passin pass: -passout pass: -out data/pem/$SUBJ.private.pem 
openssl pkcs12 -in data/$SUBJ.p12 -clcerts -passin pass: -nokeys -out data/pem/$SUBJ.crt

# Manipulate the cert
SIZE=$(du -b data/pem/$SUBJ.crt | awk '{ print $1 }')
P1=$(expr $SIZE - 36)
P3=$(expr $P1 + 4)
dd if=data/pem/$SUBJ.crt bs=1 count=$P1 >/tmp/p1
echo -n -e "\x41\x42\x43\x44" >/tmp/p2
dd if=data/pem/$SUBJ.crt bs=1 skip=$P3 >/tmp/p3
cat /tmp/p1 /tmp/p2 /tmp/p3 >data/pem/$SUBJ.crt
cat data/pem/$SUBJ.private.pem data/pem/$SUBJ.crt >data/pem/$SUBJ.combined.pem

# Put the .p12 back together
openssl pkcs12 -export -name "$NAME" -passout pass: -in data/pem/$SUBJ.combined.pem -macalg sha256 -out data/$SUBJ.p12
DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
cp -p data/$SUBJ.p12 "$DEST"
cp -p data/pem/$SUBJ.crt "$DEST"
rm -f data/pem/$SUBJ.combined.pem
rm -f data/pem/$SUBJ.private.pem

## Gen3 OCSP PIV-I valid signer using RSA 2048 (PIV-I Signing CA)
SUBJ=ICAM_Test_Card_PIV-I_OCSP_Valid_Signer_gen3 
sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -t pivi-ocsp-valid-gen3-rsa -r 2048 --cakey rsa2048 || exit $?
DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
cp -p data/$SUBJ.p12 "$DEST"
cp -p data/pem/$SUBJ.crt "$DEST"

## Gen3 Content Signer issued by RSA 2040 Signing CA
SUBJ=ICAM_Test_Card_PIV_RSA_2048_Content_Signer_-_gold_gen3 
sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_RSA_2048_Signing_CA_-_gold_gen3 -t piv-content-signer-rsa-2048 -r 2048 --cakey rsa2048 || exit $?
DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
cp -p data/$SUBJ.p12 "$DEST"
cp -p data/pem/$SUBJ.crt "$DEST"

# Cards 1-24 have immutable PIV Auth and Card Auth certs, so we don't create them.

## Card 01
T=Golden_PIV
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 01 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 01 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/01_$T"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 02
T=Golden_PIV-I
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 02 -t pivi-dig-sig || exit $?
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 02 -t pivi-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/02_$T"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 03
T=SKID_Mismatch
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 03 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 03 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/03_$T"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 04
T=Tampered_CHUID
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 04 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 04 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/04_$T"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 05
T=Tampered_Certificates
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 05 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 05 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/05_$T"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 06
T=Tampered_PHOTO
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 06 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 06 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/06_$T"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 07
T=Tampered_Fingerprints
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 07 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 07 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/07_$T"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 08
T=Tampered_Security_Object
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 08 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 08 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/08_$T"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 09
T=Expired_CHUID_Signer
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 09 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 09 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/09_$T"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 10
T=Expired_Cert_Signer
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 10 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 10 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/10_$T"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 11
T=Certs_Expire_after_CHUID
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 11 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 11 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/11_$T"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 12
T=Certs_not_yet_valid
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 12 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 12 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/12_$T"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 13
T=Certs_are_expired
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 13 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 13 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/13_$T"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 14
T=Expired_CHUID
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 14 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 14 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/14_$T"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 15
T=CHUID_FASCN_mismatch
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 15 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 15 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/15_$T"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 16
T=Card_Authentication_FASCN_mismatch
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 16 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 16 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/16_$T"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 17
T=PHOTO_FASCN_mismatch
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 17 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 17 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/17_$T"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 18
T=Fingerprints_FASCN_mismatch
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 18 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 18 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/18_$T"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 19
T=CHUID_UUID_mismatch
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 19 -t pivi-dig-sig || exit $?
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 19 -t pivi-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/19_$T"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 20
T=Card_Authent_UUID_mismatch
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 20 -t pivi-dig-sig || exit $?
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 20 -t pivi-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/20_$T"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 21
T=PHOTO_UUID_mismatch
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 21 -t pivi-dig-sig || exit $?
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 21 -t pivi-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/21_$T"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 22
T=Fingerprints_UUID_mismatch
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 22 -t pivi-dig-sig || exit $?
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 22 -t pivi-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/22_$T"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 23
# Note: The certs for this card can't be done using OpenSSL since it will 
# not create a .p12 file whose keys don't match
#T=Public_Private_Key_mismatch
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 23 -t piv-auth || exit $?
#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 23 -t piv-dig-sig || exit $?
#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 23 -t piv-key-mgmt || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 23 -t piv-card-auth || exit $?
#DEST="../cards/ICAM_Card_Objects/23_$T"
#cp -p data/ICAM_*_$T.p12 "$DEST"
#cp -p data/pem/ICAM_*_$T.crt "$DEST"
#renameIn "$DEST" 1 1

# Card 24
T=Revoked_Certificates
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 24 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 24 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/24_$T"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 25
T="Missing_DO"
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Auth_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 25 -t piv-auth || exit $?
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 25 -t piv-card-auth || exit $?
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 25 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_Auth_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 25 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/25_Disco_Object_Not_Present"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 26
T="App_PIN_Only"
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 26 -t piv-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 26 -t piv-card-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 26 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 26 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/26_Disco_Object_Present_App_PIN_Only"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 27
T="App_PIN_Prim"
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 27 -t piv-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 27 -t piv-card-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 27 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 27 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/27_Disco_Object_Present_App_PIN_Primary"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 28
T="Global_PIN_Prim"
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 28 -t piv-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 28 -t piv-card-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 28 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 28 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/28_Disco_Object_Present_Global_PIN_Primary"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 37
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-mgmt || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-card-auth -e prime256v1 || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Hist1_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist1 || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Hist2_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist2 || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Hist3_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist3 || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Hist4_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist4 || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Hist5_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist5 || exit $?
DEST="../cards/ICAM_Card_Objects/37_Golden_FIPS_201-2_PIV_PPS_F=512_D=64"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_PPS.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_PPS.crt "$DEST"
renameIn "$DEST" 1 1

## Card 38
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_Bad_SO_Hash -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 38 -t piv-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_Bad_SO_Hash -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 38 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_Bad_SO_Hash -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 38 -t piv-key-mgmt || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_Bad_SO_Hash -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 38 -t piv-card-auth || exit $?
DEST="../cards/ICAM_Card_Objects/38_Bad_Hash_in_Sec_Object"
cp -p data/ICAM_Test_Card_PIV*SP_800-73-4_Bad_SO_Hash.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV*SP_800-73-4_Bad_SO_Hash.crt "$DEST"
renameIn "$DEST" 1 1

## Card 39
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Auth_Fed_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Dig_Sig_Fed_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Key_Mgmt_Fed_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-key-mgmt || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Card_Auth_Fed_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-card-auth || exit $?
DEST="../cards/ICAM_Card_Objects/39_Golden_FIPS_201-2_Fed_PIV-I"
cp -p data/ICAM_Test_Card_PIV-I*Fed_SP_800-73-4.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV-I*Fed_SP_800-73-4.crt "$DEST"
renameIn "$DEST" 1 1

## Card 41
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_Re-key -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 41 -t piv-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_Re-key -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 41 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_Re-key -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 41 -t piv-key-mgmt || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_Re-key -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 41 -t piv-card-auth || exit $?
DEST="../cards/ICAM_Card_Objects/41_Re-keyed_Card"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_Re-key.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_Re-key.crt "$DEST"
renameIn "$DEST" 1 1

## Card 42
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_OCSP_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 42 -t piv-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_OCSP_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 42 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_OCSP_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 42 -t piv-key-mgmt || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_OCSP_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 42 -t piv-card-auth || exit $?
DEST="../cards/ICAM_Card_Objects/42_OCSP_Expired"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_OCSP_Expired.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_OCSP_Expired.crt "$DEST"
renameIn "$DEST" 1 1

## Card 43
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_OCSP_Revoked_NOCHECK -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 43 -t piv-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_OCSP_Revoked_NOCHECK -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 43 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_OCSP_Revoked_NOCHECK -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 43 -t piv-key-mgmt || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_OCSP_Revoked_NOCHECK -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 43 -t piv-card-auth || exit $?
DEST="../cards/ICAM_Card_Objects/43_OCSP_revoked_w_nocheck"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_OCSP_Revoked_NOCHECK.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_OCSP_Revoked_NOCHECK.crt "$DEST"
renameIn "$DEST" 1 1

## Card 44
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_OCSP_Revoked_WO_NOCHECK -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 44 -t piv-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_OCSP_Revoked_WO_NOCHECK -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 44 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_OCSP_Revoked_WO_NOCHECK -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 44 -t piv-key-mgmt || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_OCSP_Revoked_WO_NOCHECK -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 44 -t piv-card-auth || exit $?
DEST="../cards/ICAM_Card_Objects/44_OCSP_revoked_wo_nocheck"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_OCSP_Revoked_WO_NOCHECK.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_OCSP_Revoked_WO_NOCHECK.crt "$DEST"
renameIn "$DEST" 1 1

## Card 45
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_OCSP_Invalid_Signature -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 45 -t piv-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_OCSP_Invalid_Signature -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 45 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_OCSP_Invalid_Signature -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 45 -t piv-key-mgmt || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_OCSP_Invalid_Signature -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 45 -t piv-card-auth || exit $?
DEST="../cards/ICAM_Card_Objects/45_OCSP_Invalid_Signature"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_OCSP_Invalid_Signature.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_OCSP_Invalid_Signature.crt "$DEST"
renameIn "$DEST" 1 1

## Card 46
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 46 -t piv-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 46 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 46 -t piv-key-mgmt || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 46 -t piv-card-auth || exit $?
DEST="../cards/ICAM_Card_Objects/46_Golden_FIPS_201-2_PIV"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4.crt "$DEST"
renameIn "$DEST" 1 1

## Card 47
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_SAN_Order -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 47 -t piv-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_SAN_Order -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 47 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_SAN_Order -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 47 -t piv-key-mgmt || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_SAN_Order -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 47 -t piv-card-auth || exit $?
DEST="../cards/ICAM_Card_Objects/47_Golden_FIPS_201-2_PIV_SAN_Order"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_SAN_Order.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_SAN_Order.crt "$DEST"
renameIn "$DEST" 1 1

## Card 49
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_FI_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 49 -t piv-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_FI_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 49 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_FI_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 49 -t piv-key-mgmt || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_FI_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 49 -t piv-card-auth || exit $?
DEST="../cards/ICAM_Card_Objects/49_FIPS_201-2_Facial_Image_CBEFF_Expired"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_FI_Expired.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_FI_Expired.crt "$DEST"
renameIn "$DEST" 1 1

## Card 50
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_FI_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 50 -t piv-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_FI_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 50 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_FI_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 50 -t piv-key-mgmt || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_FI_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 50 -t piv-card-auth || exit $?
DEST="../cards/ICAM_Card_Objects/50_FIPS_201-2_Facial_Image_CBEFF_Expires_before_CHUID"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_FI_will_Expire.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_FI_will_Expire.crt "$DEST"
renameIn "$DEST" 1 1

## Card 51
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_FP_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 51 -t piv-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_FP_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 51 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_FP_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 51 -t piv-key-mgmt || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_FP_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 51 -t piv-card-auth || exit $?
DEST="../cards/ICAM_Card_Objects/51_FIPS_201-2_Fingerprint_CBEFF_Expired"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_FP_Expired.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_FP_Expired.crt "$DEST"
renameIn "$DEST" 1 1

## Card 52
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_FP_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 52 -t piv-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_FP_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 52 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_FP_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 52 -t piv-key-mgmt || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_FP_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 52 -t piv-card-auth || exit $?
DEST="../cards/ICAM_Card_Objects/52_FIPS_201-2_Fingerprint_CBEFF_Expires_before_CHUID"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_FP_will_Expire.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_FP_will_Expire.crt "$DEST"
renameIn "$DEST" 1 1

## Card 53
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_Large_Cert -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 53 -t piv-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_Large_Cert -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 53 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_Large_Cert -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 53 -t piv-key-mgmt || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_Large_Cert -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 53 -t piv-card-auth || exit $?
DEST="../cards/ICAM_Card_Objects/53_FIPS_201-2_Large_Card_Auth_Cert"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_Large_Cert.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_Large_Cert.crt "$DEST"
renameIn "$DEST" 1 1

## Card 54
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Auth_NFI_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Dig_Sig_NFI_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Key_Mgmt_NFI_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-key-mgmt || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Card_Auth_NFI_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-card-auth || exit $?
DEST="../cards/ICAM_Card_Objects/54_Golden_FIPS_201-2_NFI_PIV-I"
cp -p data/ICAM_Test_Card_PIV-I_*NFI_SP_800-73-4.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV-I*NFI_SP_800-73-4.crt "$DEST"
renameIn "$DEST" 1 1

## Card 55
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_Missing_SO -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 55 -t piv-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_Missing_SO -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 55 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_Missing_SO -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 55 -t piv-key-mgmt || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_Missing_SO -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 55 -t piv-card-auth || exit $?
DEST="../cards/ICAM_Card_Objects/55_FIPS_201-2_Missing_Security_Object"
cp -p data/ICAM_Test_Card_PIV*SP_800-73-4_Missing_SO.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV*SP_800-73-4_Missing_SO.crt "$DEST"
renameIn "$DEST" 1 1

## Card 56 
T="Signer_Expires"
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Auth_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 56 -t piv-auth -x 201201235959Z || exit $?
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 56 -t piv-dig-sig -x 201201235959Z || exit $?
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_Auth_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 56 -t piv-key-mgmt -x 201201235959Z || exit $?
sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 56 -t piv-card-auth -x 201201235959Z || exit $?
DEST="../cards/ICAM_Card_Objects/56_FIPS_201-2_Signer_Expires"
cp -p data/ICAM_Test_Card*_$T.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Gen3 Revoked CHUID Signer cert
SUBJ=ICAM_Test_Card_PIV_Revoked_CHUID_Signer_Cert_gen3
sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -t piv-content-signer-gen3-rsa -r 2048 --cakey rsa2048 || exit $?
DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
cp -p data/$SUBJ.p12 "$DEST"
cp -p data/pem/$SUBJ.crt "$DEST"

## Card 57 depends on revoked CHUID Signer cert
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_Revoked_CHUID_Cert -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 57 -t piv-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_Revoked_CHUID_Cert -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 57 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_Revoked_CHUID_Cert -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 57 -t piv-key-mgmt || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_Revoked_CHUID_Cert -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 57 -t piv-card-auth || exit $?
DEST="../cards/ICAM_Card_Objects/57_Revoked_CHUID_Cert"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_Revoked_CHUID_Cert.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_Revoked_CHUID_Cert.crt "$DEST"
renameIn "$DEST" 1 1

## Card 58
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_Revoked_Card_Auth_Cert -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 58 -t piv-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_Revoked_Card_Auth_Cert -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 58 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_Revoked_Card_Auth_Cert -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 58 -t piv-key-mgmt || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_Revoked_Card_Auth_Cert -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 58 -t piv-card-auth || exit $?
DEST="../cards/ICAM_Card_Objects/58_Revoked_Card_Auth_Cert"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_Revoked_Card_Auth_Cert.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_Revoked_Card_Auth_Cert.crt "$DEST"
renameIn "$DEST" 1 1
