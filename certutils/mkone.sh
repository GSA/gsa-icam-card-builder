#!/bin/sh
#
# Just uncomment everything between ## Card to make a single card.
#
. ./rename.sh
. ./revoke.sh

cp -p ../cards/ICAM_Card_Objects/ICAM_CA_and_Signer/*.p12 data

## Card 39
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Auth_Fed_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-auth || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Dig_Sig_Fed_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-dig-sig || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Key_Mgmt_Fed_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-key-mgmt || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Card_Auth_Fed_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-card-auth || exit $?
#DEST="../cards/ICAM_Card_Objects/39_Golden_FIPS_201-2_Fed_PIV-I"
#cp -p data/ICAM_Test_Card_PIV-I*Fed_SP_800-73-4.p12 "$DEST"
#cp -p data/pem/ICAM_Test_Card_PIV-I*Fed_SP_800-73-4.crt "$DEST"
#renameIn "$DEST" 1 1
#
## Card 45
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_OCSP_Invalid_Signature -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 45 -t piv-auth || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_OCSP_Invalid_Signature -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 45 -t piv-dig-sig || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_OCSP_Invalid_Signature -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 45 -t piv-key-mgmt || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_OCSP_Invalid_Signature -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 45 -t piv-card-auth || exit $?
#DEST="../cards/ICAM_Card_Objects/45_OCSP_Invalid_Signature"
#cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_OCSP_Invalid_Signature.p12 "$DEST"
#cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_OCSP_Invalid_Signature.crt "$DEST"
#renameIn "$DEST" 1 1
#
## Card 54
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Auth_NFI_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-auth || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Dig_Sig_NFI_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-dig-sig || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Key_Mgmt_NFI_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-key-mgmt || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Card_Auth_NFI_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-card-auth || exit $?
#DEST="../cards/ICAM_Card_Objects/54_Golden_FIPS_201-2_NFI_PIV-I"
#cp -p data/ICAM_Test_Card_PIV-I_*NFI_SP_800-73-4.p12 "$DEST"
#cp -p data/pem/ICAM_Test_Card_PIV-I*NFI_SP_800-73-4.crt "$DEST"
#renameIn "$DEST" 1 1
#
## Card 55
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_Missing_SO -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 55 -t piv-auth || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_Missing_SO -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 55 -t piv-dig-sig || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_Missing_SO -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 55 -t piv-key-mgmt || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_Missing_SO -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 55 -t piv-card-auth || exit $?
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
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-auth || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-dig-sig || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-mgmt || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-card-auth || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Hist1_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist1 || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Hist2_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist2 || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Hist3_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist3 || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Hist4_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist4 || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Hist5_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist5 || exit $?
#DEST="../cards/ICAM_Card_Objects/37_Golden_FIPS_201-2_PIV_PPS_F=512_D=64"
#cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_PPS.p12 "$DEST"
#cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_PPS.crt "$DEST"
#cp -p data/ICAM_Test_Card_PIV_ECC_Issued_P-256_SM_Certificate_Signer_2.p12 "$DEST"
#cp -p data/pem/ICAM_Test_Card_PIV_ECC_Issued_P-256_SM_Certificate_Signer_2.crt "$DEST"
#renameIn "$DEST" 1 1

## Card 45
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_OCSP_Invalid_Signature -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 45 -t piv-auth || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_OCSP_Invalid_Signature -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 45 -t piv-dig-sig || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_OCSP_Invalid_Signature -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 45 -t piv-key-mgmt || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_OCSP_Invalid_Signature -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 45 -t piv-card-auth || exit $?
#DEST="../cards/ICAM_Card_Objects/45_OCSP_Invalid_Signature"
#cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_OCSP_Invalid_Signature.p12 "$DEST"
#cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_OCSP_Invalid_Signature.crt "$DEST"
#renameIn "$DEST" 1 1

## Card 46
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 46 -t piv-auth || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 46 -t piv-dig-sig || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 46 -t piv-key-mgmt || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 46 -t piv-card-auth || exit $?
#DEST="../cards/ICAM_Card_Objects/46_Golden_FIPS_201-2_PIV"
#cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4.p12 "$DEST"
#cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4.crt "$DEST"
#renameIn "$DEST" 1 1

## Card 48
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_Non-Zero_PPS_LEN -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 48 -t piv-auth || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_Non-Zero_PPS_LEN -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 48 -t piv-dig-sig || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_Non-Zero_PPS_LEN -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 48 -t piv-key-mgmt || exit $?
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_Non-Zero_PPS_LEN -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 48 -t piv-card-auth || exit $?
#DEST="../cards/ICAM_Card_Objects/48_T=1_with_Non-Zero_PPS_LEN_Value"
#cp -p data/ICAM_Test_Card_PIV_*PPS_LEN.p12 "$DEST"
#cp -p data/pem/ICAM_Test_Card_PIV_*PPS_LEN.crt "$DEST"
#renameIn "$DEST" 1 1

## Gen3 Secure Messaging Key Establishment using ECC P-256 with intermediate CVC (RSA 2048 CA)
#SUBJ=ICAM_Test_Card_PIV_RSA_Issued_Intermediate_CVC_Signer
#sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_RSA_2048_Signing_CA_-_gold_gen3 -t piv-content-signer-rsa-2048 -e prime256v1 --cakey rsa2048 || exit $?
#DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
#cp -p data/$SUBJ.p12 "$DEST"
#cp -p data/pem/$SUBJ.crt "$DEST"

#RAF### Card 01
#RAF#T=Golden_PIV
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 01 -t piv-dig-sig || exit $?
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 01 -t piv-key-mgmt || exit $?
#RAF#DEST="../cards/ICAM_Card_Objects/01_$T"
#RAF#cp -p data/ICAM_*_$T.p12 "$DEST"
#RAF#cp -p data/pem/ICAM_*_$T.crt "$DEST"
#RAF#renameIn "$DEST" 1 1
#RAF#
#RAF### Card 02
#RAF#T=Golden_PIV-I
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 02 -t pivi-dig-sig || exit $?
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 02 -t pivi-key-mgmt || exit $?
#RAF#DEST="../cards/ICAM_Card_Objects/02_$T"
#RAF#cp -p data/ICAM_*_$T.p12 "$DEST"
#RAF#cp -p data/pem/ICAM_*_$T.crt "$DEST"
#RAF#renameIn "$DEST" 1 1
#RAF#
#RAF### Card 03
#RAF#T=SKID_Mismatch
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 03 -t piv-dig-sig || exit $?
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 03 -t piv-key-mgmt || exit $?
#RAF#DEST="../cards/ICAM_Card_Objects/03_$T"
#RAF#cp -p data/ICAM_*_$T.p12 "$DEST"
#RAF#cp -p data/pem/ICAM_*_$T.crt "$DEST"
#RAF#renameIn "$DEST" 1 1
#RAF#
#RAF### Card 04
#RAF#T=Tampered_CHUID
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 04 -t piv-dig-sig || exit $?
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 04 -t piv-key-mgmt || exit $?
#RAF#DEST="../cards/ICAM_Card_Objects/04_$T"
#RAF#cp -p data/ICAM_*_$T.p12 "$DEST"
#RAF#cp -p data/pem/ICAM_*_$T.crt "$DEST"
#RAF#renameIn "$DEST" 1 1
#RAF#
#RAF### Card 05
#RAF#T=Tampered_Certificates
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 05 -t piv-dig-sig || exit $?
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 05 -t piv-key-mgmt || exit $?
#RAF#DEST="../cards/ICAM_Card_Objects/05_$T"
#RAF#cp -p data/ICAM_*_$T.p12 "$DEST"
#RAF#cp -p data/pem/ICAM_*_$T.crt "$DEST"
#RAF#renameIn "$DEST" 1 1
#RAF#
#RAF### Card 06
#RAF#T=Tampered_PHOTO
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 06 -t piv-dig-sig || exit $?
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 06 -t piv-key-mgmt || exit $?
#RAF#DEST="../cards/ICAM_Card_Objects/06_$T"
#RAF#cp -p data/ICAM_*_$T.p12 "$DEST"
#RAF#cp -p data/pem/ICAM_*_$T.crt "$DEST"
#RAF#renameIn "$DEST" 1 1
#RAF#
#RAF### Card 07
#RAF#T=Tampered_Fingerprints
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 07 -t piv-dig-sig || exit $?
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 07 -t piv-key-mgmt || exit $?
#RAF#DEST="../cards/ICAM_Card_Objects/07_$T"
#RAF#cp -p data/ICAM_*_$T.p12 "$DEST"
#RAF#cp -p data/pem/ICAM_*_$T.crt "$DEST"
#RAF#renameIn "$DEST" 1 1
#RAF#
#RAF### Card 08
#RAF#T=Tampered_Security_Object
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 08 -t piv-dig-sig || exit $?
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 08 -t piv-key-mgmt || exit $?
#RAF#DEST="../cards/ICAM_Card_Objects/08_$T"
#RAF#cp -p data/ICAM_*_$T.p12 "$DEST"
#RAF#cp -p data/pem/ICAM_*_$T.crt "$DEST"
#RAF#renameIn "$DEST" 1 1
#RAF#
#RAF### Card 09
#RAF#T=Expired_CHUID_Signer
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 09 -t piv-dig-sig || exit $?
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 09 -t piv-key-mgmt || exit $?
#RAF#DEST="../cards/ICAM_Card_Objects/09_$T"
#RAF#cp -p data/ICAM_*_$T.p12 "$DEST"
#RAF#cp -p data/pem/ICAM_*_$T.crt "$DEST"
#RAF#renameIn "$DEST" 1 1
#RAF#
#RAF### Card 10
#RAF#T=Expired_Cert_Signer
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 10 -t piv-dig-sig || exit $?
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 10 -t piv-key-mgmt || exit $?
#RAF#DEST="../cards/ICAM_Card_Objects/10_$T"
#RAF#cp -p data/ICAM_*_$T.p12 "$DEST"
#RAF#cp -p data/pem/ICAM_*_$T.crt "$DEST"
#RAF#renameIn "$DEST" 1 1
#RAF#
#RAF### Card 11
#RAF#T=Certs_Expire_after_CHUID
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 11 -t piv-dig-sig || exit $?
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 11 -t piv-key-mgmt || exit $?
#RAF#DEST="../cards/ICAM_Card_Objects/11_$T"
#RAF#cp -p data/ICAM_*_$T.p12 "$DEST"
#RAF#cp -p data/pem/ICAM_*_$T.crt "$DEST"
#RAF#renameIn "$DEST" 1 1
#RAF#
#RAF### Card 12
#RAF#T=Certs_not_yet_valid
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 12 -t piv-dig-sig || exit $?
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 12 -t piv-key-mgmt || exit $?
#RAF#DEST="../cards/ICAM_Card_Objects/12_$T"
#RAF#cp -p data/ICAM_*_$T.p12 "$DEST"
#RAF#cp -p data/pem/ICAM_*_$T.crt "$DEST"
#RAF#renameIn "$DEST" 1 1
#RAF#
#RAF### Card 13
#RAF#T=Certs_are_expired
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 13 -t piv-dig-sig || exit $?
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 13 -t piv-key-mgmt || exit $?
#RAF#DEST="../cards/ICAM_Card_Objects/13_$T"
#RAF#cp -p data/ICAM_*_$T.p12 "$DEST"
#RAF#cp -p data/pem/ICAM_*_$T.crt "$DEST"
#RAF#renameIn "$DEST" 1 1
#RAF#
#RAF### Card 14
#RAF#T=Expired_CHUID
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 14 -t piv-dig-sig || exit $?
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 14 -t piv-key-mgmt || exit $?
#RAF#DEST="../cards/ICAM_Card_Objects/14_$T"
#RAF#cp -p data/ICAM_*_$T.p12 "$DEST"
#RAF#cp -p data/pem/ICAM_*_$T.crt "$DEST"
#RAF#renameIn "$DEST" 1 1
#RAF#
#RAF### Card 15
#RAF#T=CHUID_FASCN_mismatch
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 15 -t piv-dig-sig || exit $?
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 15 -t piv-key-mgmt || exit $?
#RAF#DEST="../cards/ICAM_Card_Objects/15_$T"
#RAF#cp -p data/ICAM_*_$T.p12 "$DEST"
#RAF#cp -p data/pem/ICAM_*_$T.crt "$DEST"
#RAF#renameIn "$DEST" 1 1
#RAF#
#RAF### Card 16
#RAF#T=Card_Authent_FASCN_mismatch
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 16 -t piv-dig-sig || exit $?
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 16 -t piv-key-mgmt || exit $?
#RAF#DEST="../cards/ICAM_Card_Objects/16_$T"
#RAF#cp -p data/ICAM_*_$T.p12 "$DEST"
#RAF#cp -p data/pem/ICAM_*_$T.crt "$DEST"
#RAF#renameIn "$DEST" 1 1
#RAF#
#RAF### Card 17
#RAF#T=PHOTO_FASCN_mismatch
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 17 -t piv-dig-sig || exit $?
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 17 -t piv-key-mgmt || exit $?
#RAF#DEST="../cards/ICAM_Card_Objects/17_$T"
#RAF#cp -p data/ICAM_*_$T.p12 "$DEST"
#RAF#cp -p data/pem/ICAM_*_$T.crt "$DEST"
#RAF#renameIn "$DEST" 1 1
#RAF#
#RAF### Card 18
#RAF#T=Fingerprints_FASCN_mismatch
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 18 -t piv-dig-sig || exit $?
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 18 -t piv-key-mgmt || exit $?
#RAF#DEST="../cards/ICAM_Card_Objects/18_$T"
#RAF#cp -p data/ICAM_*_$T.p12 "$DEST"
#RAF#cp -p data/pem/ICAM_*_$T.crt "$DEST"
#RAF#renameIn "$DEST" 1 1
#RAF#
#RAF### Card 19
#RAF#T=CHUID_UUID_mismatch
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 19 -t pivi-dig-sig || exit $?
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 19 -t pivi-key-mgmt || exit $?
#RAF#DEST="../cards/ICAM_Card_Objects/19_$T"
#RAF#cp -p data/ICAM_*_$T.p12 "$DEST"
#RAF#cp -p data/pem/ICAM_*_$T.crt "$DEST"
#RAF#renameIn "$DEST" 1 1
#RAF#
#RAF### Card 20
#RAF#T=Card_Authent_UUID_mismatch
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 20 -t pivi-dig-sig || exit $?
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 20 -t pivi-key-mgmt || exit $?
#RAF#DEST="../cards/ICAM_Card_Objects/20_$T"
#RAF#cp -p data/ICAM_*_$T.p12 "$DEST"
#RAF#cp -p data/pem/ICAM_*_$T.crt "$DEST"
#RAF#renameIn "$DEST" 1 1
#RAF#
#RAF### Card 21
#RAF#T=PHOTO_UUID_mismatch
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 21 -t pivi-dig-sig || exit $?
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 21 -t pivi-key-mgmt || exit $?
#RAF#DEST="../cards/ICAM_Card_Objects/21_$T"
#RAF#cp -p data/ICAM_*_$T.p12 "$DEST"
#RAF#cp -p data/pem/ICAM_*_$T.crt "$DEST"
#RAF#renameIn "$DEST" 1 1
#RAF#
#RAF### Card 22
#RAF#T=Fingerprints_UUID_mismatch
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 22 -t pivi-dig-sig || exit $?
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 22 -t pivi-key-mgmt || exit $?
#RAF#DEST="../cards/ICAM_Card_Objects/22_$T"
#RAF#cp -p data/ICAM_*_$T.p12 "$DEST"
#RAF#cp -p data/pem/ICAM_*_$T.crt "$DEST"
#RAF#renameIn "$DEST" 1 1
#RAF#
#RAF### Card 23
#T=Public_Private_Key_mismatch
#sh mkcert1.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 23 -t piv-auth || exit $?
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 23 -t piv-dig-sig || exit $?
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 23 -t piv-key-mgmt || exit $?
#sh mkcert1.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 23 -t piv-card-auth || exit $?
#DEST="../cards/ICAM_Card_Objects/23_$T"
#cp -p data/ICAM_*_$T.p12 "$DEST"
#cp -p data/pem/ICAM_*_$T.crt "$DEST"
#renameIn "$DEST" 1 1
#RAF#
#RAF## Card 24
#RAF#T=Revoked_Certificates
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 24 -t piv-dig-sig || exit $?
#RAF#sh mkcert.sh -w -b -s "ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T" -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 24 -t piv-key-mgmt || exit $?
#RAF#DEST="../cards/ICAM_Card_Objects/24_$T"
#RAF#cp -p data/ICAM_*_$T.p12 "$DEST"
#RAF#cp -p data/pem/ICAM_*_$T.crt "$DEST"
#RAF#renameIn "$DEST" 1 1
#RAF#
#RAF#
#RAF### Gen3 Content Signer issued by RSA 2040 Signing CA
#RAF#SUBJ=ICAM_Test_Card_PIV_Content_Signer_RSA_2048_gen3 
#RAF#sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_RSA_2048_Signing_CA_-_gold_gen3 -t piv-content-signer-rsa-2048 -r 2048 --cakey rsa2048 || exit $?
#RAF#DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
#RAF#cp -p data/$SUBJ.p12 "$DEST"
#RAF#cp -p data/pem/$SUBJ.crt "$DEST"
#RAF#
#RAF### Gen3 OCSP valid signer using RSA 2048 (RSA 2048 CA)
#RAF#SUBJ=ICAM_Test_Card_PIV_OCSP_RSA_2048_Valid_Signer_gen3
#RAF#sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_RSA_2048_Signing_CA_-_gold_gen3 -t piv-ocsp-valid-rsa-2048 -r 2048 --cakey rsa2048 || exit $?
#RAF#DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
#RAF#cp -p data/$SUBJ.p12 "$DEST"
#RAF#cp -p data/pem/$SUBJ.crt "$DEST"
#RAF#
#RAF### Gen3 Content Signer issued by RSA 2040 Signing CA (minus OSCP)
#RAF#SUBJ=ICAM_Test_Card_PIV_Content_Signer_RSA_2048_gen3_no_ocsp
#RAF#sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_RSA_2048_Signing_CA_-_gold_gen3 -t piv-content-signer-rsa-2048-no-ocsp -r 2048 --cakey rsa2048 || exit $?
#RAF#DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
#RAF#cp -p data/$SUBJ.p12 "$DEST"
#RAF#cp -p data/pem/$SUBJ.crt "$DEST"
#############################################################################

doit() {
	
	PIV_AUTH_P12_NAME="3 - ICAM_PIV_Auth_SP_800-73-4.p12"
	PIV_AUTH_CERT_NAME="3 - ICAM_PIV_Auth_SP_800-73-4.crt"

	DIG_SIG_P12_NAME="4 - ICAM_PIV_Dig_Sig_SP_800-73-4.p12"
	DIG_SIG_CERT_NAME="4 - ICAM_PIV_Dig_Sig_SP_800-73-4.crt"

	KEY_MGMT_P12_NAME="5 - ICAM_PIV_Key_Mgmt_SP_800-73-4.p12"
	KEY_MGMT_CERT_NAME="5 - ICAM_PIV_Key_Mgmt_SP_800-73-4.crt"

	CARD_AUTH_P12_NAME="6 - ICAM_PIV_Card_Auth_SP_800-73-4.p12"
	CARD_AUTH_CERT_NAME="6 - ICAM_PIV_Card_Auth_SP_800-73-4.crt"


	cp -p $1 $3
	cp -p $2 $3

	pushd $3

	case $4 in
		PIV_Auth)
			set -x
			mv $(basename $1) "$PIV_AUTH_P12_NAME"
			mv $(basename $2) "$PIV_AUTH_CERT_NAME"
			set +x
			;;
		PIV_Dig_Sig)
			set -x
			mv $(basename $1) "$DIG_SIG_P12_NAME"
			mv $(basename $2) "$DIG_SIG_CERT_NAME"
			set +x
			;;
		PIV_Key_Mgmt)
			set -x
			mv $(basename $1) "$KEY_MGMT_P12_NAME"
			mv $(basename $2) "$KEY_MGMT_CERT_NAME"
			set +x
			;;
		PIV_Card_Auth)
			set -x
			mv $(basename $1) "$CARD_AUTH_P12_NAME"
			mv $(basename $2) "$CARD_AUTH_CERT_NAME"
			set +x
			;;
	esac
	popd
}

set -x

EXP=190630235959Z

## Card 39
DEST="../cards/ICAM_Card_Objects/39_Golden_FIPS_201-2_Fed_PIV-I-X"
rm -f ${DEST}/*.{p12,crt}
if [ ! -f $DEST ]; then mkdir -p $DEST; fi
SUBJ=JOHN_M._SMITH

sh mkcert.sh -w -b -s $SUBJ -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-auth-x -x $EXP || exit $?
doit data/$SUBJ.p12 data/pem/$SUBJ.crt $DEST PIV_Auth
sh mkcert.sh -w -b -s $SUBJ -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-dig-sig-x -x $EXP || exit $?
doit data/$SUBJ.p12 data/pem/$SUBJ.crt $DEST PIV_Dig_Sig
sh mkcert.sh -w -b -s $SUBJ -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-key-mgmt-x -x $EXP || exit $?
doit data/$SUBJ.p12 data/pem/$SUBJ.crt $DEST PIV_Key_Mgmt
sh mkcert.sh -w -b -s $SUBJ -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-card-auth -x $EXP || exit $?
doit data/$SUBJ.p12 data/pem/$SUBJ.crt $DEST PIV_Card_Auth

## Card 54
DEST="../cards/ICAM_Card_Objects/54_Golden_FIPS_201-2_NFI_PIV-I-X"
rm -f ${DEST}/*.{p12,crt}
if [ ! -f $DEST ]; then mkdir -p $DEST; fi
SUBJ=JOHN_QUINCY_ADAMS_III

sh mkcert.sh -w -b -s $SUBJ -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-auth-x -x $EXP || exit $?
doit data/$SUBJ.p12 data/pem/$SUBJ.crt $DEST PIV_Auth
sh mkcert.sh -w -b -s $SUBJ -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-dig-sig-x -x $EXP || exit $?
doit data/$SUBJ.p12 data/pem/$SUBJ.crt $DEST PIV_Dig_Sig
sh mkcert.sh -w -b -s $SUBJ -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-key-mgmt-x -x $EXP || exit $?
doit data/$SUBJ.p12 data/pem/$SUBJ.crt $DEST PIV_Key_Mgmt
sh mkcert.sh -w -b -s $SUBJ -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-card-auth -x $EXP || exit $?
doit data/$SUBJ.p12 data/pem/$SUBJ.crt $DEST PIV_Card_Auth


## Card 47
DEST="../cards/ICAM_Card_Objects/47_Golden_FIPS_201-2_PIV_SAN_Order-X"
rm -f ${DEST}/*.{p12,crt}
if [ ! -f $DEST ]; then mkdir -p $DEST; fi
SUBJ=COOKIE_WILLAMS

sh mkcert.sh -w -b -s $SUBJ -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 47 -t piv-auth-x -x $EXP || exit $?
doit data/$SUBJ.p12 data/pem/$SUBJ.crt $DEST PIV_Auth
sh mkcert.sh -w -b -s $SUBJ -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 47 -t piv-dig-sig-x -x $EXP || exit $?
doit data/$SUBJ.p12 data/pem/$SUBJ.crt $DEST PIV_Dig_Sig
sh mkcert.sh -w -b -s $SUBJ -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 47 -t piv-key-mgmt-x -x $EXP || exit $?
doit data/$SUBJ.p12 data/pem/$SUBJ.crt $DEST PIV_Key_Mgmt
sh mkcert.sh -w -b -s $SUBJ -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 47 -t piv-card-auth -x $EXP || exit $?
doit data/$SUBJ.p12 data/pem/$SUBJ.crt $DEST PIV_Card_Auth
