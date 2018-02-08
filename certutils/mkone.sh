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
#renameIn "$DEST" 1 1
#
## Gen1-2 OCSP valid signer using RSA 2048 (RSA 2048 CA)
#SUBJ=ICAM_Test_Card_PIV_OCSP_Valid_Signer_gen1-2
#sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -t piv-ocsp-valid-gen1-2 -r 2048 --cakey rsa2048 || exit $?
#DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
#cp -p data/$SUBJ.p12 "$DEST"
#cp -p data/pem/$SUBJ.crt "$DEST"
#
## OCSP valid signer using RSA 2048 (RSA 2048 CA)
#SUBJ=ICAM_Test_Card_PIV_OCSP_Valid_Signer_gen3 
#sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -t piv-ocsp-valid-gen3-rsa -r 2048 --cakey rsa2048 || exit $?
#DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
#cp -p data/$SUBJ.p12 "$DEST"
#cp -p data/pem/$SUBJ.crt "$DEST"
#
## Gen3 Secure Messaging Key Establishment using ECC P-256 with intermediate CVC (RSA 2048 CA)
#SUBJ=ICAM_Test_Card_PIV_RSA_Issued_Intermediate_CVC_Signer
#sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -t piv-content-signer-gen3-rsa -e prime256v1 -c rsa2048 || exit $?
#DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
#cp -p data/$SUBJ.p12 "$DEST"
#cp -p data/pem/$SUBJ.crt "$DEST"
#
## Gen3 Secure Messaging Key Establishment using ECC P-256 (ECC P-384 CA)
#SUBJ=ICAM_Test_Card_PIV_ECC_Issued_P-256_SM_Certificate_Signer_2
#sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_P-384_Signing_CA_gold_gen3 -t piv-content-signer-gen3-p384 -e prime256v1 -c secp384r1 || exit $?
#DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
#cp -p data/$SUBJ.p12 "$DEST"
#cp -p data/pem/$SUBJ.crt "$DEST"
#
## OCSP Gen3 valid OCSP signer using ECC P-384 (ECC P-384)
#SUBJ=ICAM_Test_Card_PIV_OCSP_Valid_Signer_P384_gen3 
#sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_P-384_Signing_CA_gold_gen3 -t piv-ocsp-valid-gen3-p384 -r 2048 --cakey secp384r1 || exit $?
#DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
#cp -p data/$SUBJ.p12 "$DEST"
#cp -p data/pem/$SUBJ.crt "$DEST"

## Gen3 Secure Messaging Key Establishment using ECC P-256 (ECC P-384 CA)
#SUBJ=ICAM_Test_Card_PIV_ECC_Issued_P-256_SM_Certificate_Signer_2
#sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_P-384_Signing_CA_gold_gen3 -t piv-content-signer-gen3-p384 -e prime256v1 -c secp384r1 || exit $?
#DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
#cp -p data/$SUBJ.p12 "$DEST"
#cp -p data/pem/$SUBJ.crt "$DEST"

## Gen3 Secure Messaging Key Establishment using ECC P-384 (ECC P-384 CA)
#SUBJ=ICAM_Test_Card_PIV_ECC_Issued_P-384_SM_Certificate_Signer_3
#sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_P-384_Signing_CA_gold_gen3 -t piv-content-signer-gen3-p384 -e secp384r1 -c secp384r1 || exit $?
#DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
#cp -p data/$SUBJ.p12 "$DEST"
#cp -p data/pem/$SUBJ.crt "$DEST"
#
## Card 37
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-auth
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-dig-sig
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-card-auth 
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Hist1_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist1
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Hist2_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist2
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Hist3_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist3
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Hist4_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist4
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Hist5_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist5
DEST="../cards/ICAM_Card_Objects/37_Golden_FIPS_201-2_PIV_PPS_F=512_D=64"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_PPS.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_PPS.crt "$DEST"
cp -p data/ICAM_Test_Card_PIV_ECC_Issued_P-256_SM_Certificate_Signer_2.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_ECC_Issued_P-256_SM_Certificate_Signer_2.crt "$DEST"
renameIn "$DEST" 1 1
