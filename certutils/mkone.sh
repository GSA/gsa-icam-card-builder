#!/bin/sh
#
# Just uncomment everything between ## Card to make a single card.
#
. ./rename.sh

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
## OCSP revoked signer with id-pkix-ocsp-nocheck present using RSA 2048 (RSA 2048 CA)
#SUBJ=ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Present_gen3 
#sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -t piv-ocsp-revoked-nocheck-present -r 2048 --cakey rsa2048 || exit $?
#DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
#cp -p data/$SUBJ.p12 "$DEST"
#cp -p data/pem/$SUBJ.crt "$DEST"
#
## OCSP revoked signer with id-pkix-ocsp-nocheck NOT present using RSA 2048 (RSA 2048 CA)
#SUBJ=ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Not_Present_gen3 
#sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -t piv-ocsp-revoked-nocheck-not-present -r 2048 --cakey rsa2048 || exit $?
#DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
#cp -p data/$SUBJ.p12 "$DEST"
#cp -p data/pem/$SUBJ.crt "$DEST"
