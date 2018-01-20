#!/bin/sh
#
# Just uncomment everything between ## Card to make a single card.
#
. ./rename.sh
. ./revoke.sh

## Card 39
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Auth_Fed_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-auth
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Dig_Sig_Fed_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-dig-sig
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Key_Mgmt_Fed_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-key-mgmt
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Card_Auth_Fed_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-card-auth
#DEST="../cards/ICAM_Card_Objects/39_Golden_FIPS_201-2_Fed_PIV-I"
#cp -p data/ICAM_Test_Card_PIV-I*Fed_SP_800-73-4.p12 "$DEST"
#cp -p data/pem/ICAM_Test_Card_PIV-I*Fed_SP_800-73-4.crt "$DEST"
#renameIn "$DEST" 1 1
#
## Card 45
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_OCSP_Invalid_Signature -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 45 -t piv-auth
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_OCSP_Invalid_Signature -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 45 -t piv-dig-sig
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_OCSP_Invalid_Signature -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 45 -t piv-key-mgmt
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_OCSP_Invalid_Signature -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 45 -t piv-card-auth
#DEST="../cards/ICAM_Card_Objects/45_OCSP_Invalid_Signature"
#cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_OCSP_Invalid_Signature.p12 "$DEST"
#cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_OCSP_Invalid_Signature.crt "$DEST"
#renameIn "$DEST" 1 1
#
## Card 54
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Auth_NFI_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-auth
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Dig_Sig_NFI_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-dig-sig
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Key_Mgmt_NFI_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-key-mgmt
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Card_Auth_NFI_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-card-auth
#DEST="../cards/ICAM_Card_Objects/54_Golden_FIPS_201-2_NFI_PIV-I"
#cp -p data/ICAM_Test_Card_PIV-I_*NFI_SP_800-73-4.p12 "$DEST"
#cp -p data/pem/ICAM_Test_Card_PIV-I*NFI_SP_800-73-4.crt "$DEST"
#renameIn "$DEST" 1 1
#
## Card 55
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_Missing_SO -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 55 -t piv-auth
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_Missing_SO -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 55 -t piv-dig-sig
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_Missing_SO -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 55 -t piv-key-mgmt
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_Missing_SO -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 55 -t piv-card-auth
#DEST="../cards/ICAM_Card_Objects/55_FIPS_201-2_Missing_Security_Object"
#cp -p data/ICAM_Test_Card_PIV*SP_800-73-4_Missing_SO.p12 "$DEST"
#cp -p data/pem/ICAM_Test_Card_PIV*SP_800-73-4_Missing_SO.crt "$DEST"
#
## Card 55
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_Missing_SO -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 55 -t piv-auth
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_Missing_SO -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 55 -t piv-dig-sig
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_Missing_SO -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 55 -t piv-key-mgmt
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_Missing_SO -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 55 -t piv-card-auth
#DEST="../cards/ICAM_Card_Objects/55_FIPS_201-2_Missing_Security_Object"
#cp -p data/ICAM_Test_Card_PIV*SP_800-73-4_Missing_SO.p12 "$DEST"
##cp -p data/pem/ICAM_Test_Card_PIV*SP_800-73-4_Missing_SO.crt "$DEST"
#
## OCSP valid signer using RSA 2048 (RSA 2048 CA)
#SUBJ=ICAM_Test_Card_PIV_OCSP_Valid_Signer_gen3 
#sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -t piv-ocsp-valid -r 2048 --cakey rsa2048 || exit $?
#DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
#cp -p data/$SUBJ.p12 "$DEST"
#cp -p data/pem/$SUBJ.crt "$DEST"
#
## OCSP expired signer using RSA 2048 (RSA 2048 CA)
#SUBJ=ICAM_Test_Card_PIV_OCSP_Expired_Signer_gen3 
#sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -t piv-ocsp-expired -r 2048 --cakey rsa2048 -x 171202000000Z || exit $?
#DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
#cp -p data/$SUBJ.p12 "$DEST"
#cp -p data/pem/$SUBJ.crt "$DEST"
#
## OCSP revoked signer with id-pkix-ocsp-nocheck present using RSA 2048 (RSA 2048 CA)
#SUBJ=ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Present_gen3 
#ISSUER=ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3
#CONFIG=$CWD/icam-piv-ocsp-revoked-nocheck-not-present.cnf
#CRL=ICAMTestCardGen3SigningCA
#sh mkcert.sh -b -s $SUBJ -i $ISSUER -t piv-ocsp-revoked-nocheck-present -r 2048 --cakey rsa2048 || exit $?
#DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
#cp -p data/$SUBJ.p12 "$DEST"
#cp -p data/pem/$SUBJ.crt "$DEST"
#revoke $SUBJ $ISSUER $CONFIG $CRL
#
## OCSP revoked signer with id-pkix-ocsp-nocheck NOT presetnt using RSA 2048 (RSA 2048 CA)
#SUBJ=ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Not_Present_gen3 
#ISSUER=ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3
#CONFIG=$CWD/icam-piv-ocsp-revoked-nocheck-present.cnf
#CRL=ICAMTestCardGen3SigningCA
#sh mkcert.sh -b -s $SUBJ -i $ISSUER -t piv-ocsp-revoked-nocheck-not-present -r 2048 --cakey rsa2048 || exit $?
#DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
#cp -p data/$SUBJ.p12 "$DEST"
#cp -p data/pem/$SUBJ.crt "$DEST"
#revoke $SUBJ $ISSUER $CONFIG $CRL
#
## OCSP invalid signature using RSA 2048 (RSA 2048 CA)
#SUBJ=ICAM_Test_Card_PIV_OCSP_Invalid_Sig_Signer_gen3
#NAME=$(echo $SUBJ | sed 's/[&_]/ /g')
#sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -t piv-ocsp-invalid-sig -r 2048 --cakey rsa2048 || exit $?
#
# Extract private/publilc keys from the .p12
#openssl pkcs12 -in data/$SUBJ.p12 -nocerts -nodes -passin pass: -passout pass: -out data/pem/$SUBJ.private.pem 
#openssl pkcs12 -in data/$SUBJ.p12 -clcerts -passin pass: -nokeys -out data/pem/$SUBJ.crt
#
## Manipulate the cert
#SIZE=$(du -b data/pem/$SUBJ.crt | awk '{ print $1 }')
#P1=$(expr $SIZE - 36)
#P3=$(expr $P1 + 4)
#dd if=data/pem/$SUBJ.crt bs=1 count=$P1 >/tmp/p1
#echo -n -e "\x41\x42\x43\x44" >/tmp/p2
#dd if=data/pem/$SUBJ.crt bs=1 skip=$P3 >/tmp/p3
#cat /tmp/p1 /tmp/p2 /tmp/p3 >data/pem/$SUBJ.crt
#cat data/pem/$SUBJ.private.pem data/pem/$SUBJ.crt >data/pem/$SUBJ.combined.pem
#
## Put the .p12 back together
#openssl pkcs12 -export -name "$NAME" -passout pass: -in data/pem/$SUBJ.combined.pem -macalg sha256 -out data/$SUBJ.p12
#DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
#cp -p data/$SUBJ.p12 "$DEST"
#cp -p data/pem/$SUBJ.crt "$DEST"
#rm -f data/pem/$SUBJ.combined.pem
#rm -f data/pem/$SUBJ.private.pem
##
## OCSP PIV-I valid signer using RSA 2048 (RSA 2048 CA)
#SUBJ=ICAM_Test_Card_PIV-I_OCSP_Valid_Signer_gen3 
#sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -t pivi-ocsp-valid -r 2048 --cakey rsa2048 || exit $?
#DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
#cp -p data/$SUBJ.p12 "$DEST"
#cp -p data/pem/$SUBJ.crt "$DEST"
#
## Early expiring PIV Content signer using RSA 2048 (RSA 2048 CA) not a permanent ICAM test card
SUBJ=ICAM_Test_Card_PIV_Content_Signer_Expiring_-_gold_gen3 
sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -t piv-content-signer-gen3 -r 2048 --cakey rsa2048 -x 201202000000Z || exit $?
DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
cp -p data/$SUBJ.p12 "$DEST"
cp -p data/pem/$SUBJ.crt "$DEST"
