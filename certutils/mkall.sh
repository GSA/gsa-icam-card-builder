#!/bin/sh
#
# This makes the certs for all of the cards in the FIPS 201-2 card set.
# Note that if using the "CertiPath Load Tool" for certain types of high speed
# cards, all certs must use the names that Card 46 uses.  In fact, all data
# objects must be named the same.  To use the tool for cards other than Card 46,
# we need to rename the certs to conform with Card 46. 
#
. ./rename.sh

## PIV Content signer using RSA 2048 (RSA 2048 CA)

#SUBJ=ICAM_Test_Card_PIV_Content_Signer_-_gold_gen3 
#sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -t piv-content-signer-gen3 -r 2048 --cakey rsa2048 || exit $?
#DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
#cp -p data/$SUBJ.p12 "$DEST"
#cp -p data/pem/$SUBJ.crt "$DEST"
#
### PIV Content signer using RSA 2048 (RSA 2048 CA)
#
#SUBJ=ICAM_Test_Card_PIV_Content_Signer_-_gold_gen3 
#sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -t piv-content-signer-gen3 -r 2048 --cakey rsa2048 || exit $?
#DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
#cp -p data/$SUBJ.p12 "$DEST"
#cp -p data/pem/$SUBJ.crt "$DEST"
#
### PIV-I Content signer using RSA 2048 (RSA 2048 CA)
#
#SUBJ=ICAM_Test_Card_PIV-I_Content_Signer_-_gold_gen3 
#sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -t pivi-content-signer-gen3 -r 2048 --cakey rsa2048 || exit $?
#DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
#cp -p data/$SUBJ.p12 "$DEST"
#cp -p data/pem/$SUBJ.crt "$DEST"
#
### Secure Messaging Key Establishment using ECC P-256 with intermediate CVC (RSA 2048 CA)
#
#SUBJ=ICAM_Test_Card_PIV_RSA_Issued_Intermediate_CVC_Signer
#sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -t piv-content-signer-gen3 -r 2048 -c rsa2048 || exit $?
#DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
#cp -p data/$SUBJ.p12 "$DEST"
#cp -p data/pem/$SUBJ.crt "$DEST"
#
### Secure Messaging Key Establishment using ECC P-256 (ECC P-384 CA)
#
#SUBJ=ICAM_Test_Card_PIV_ECC_Issued_P-256_SM_Certificate_Signer_2
#sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_P-384_Signing_CA_gold_gen3 -t piv-content-signer-gen3 -e prime256v1 -c secp384r1 || exit $?
#DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
#cp -p data/$SUBJ.p12 "$DEST"
#cp -p data/pem/$SUBJ.crt "$DEST"
#
### Secure Messaging Key Establishment using ECC P-384 (ECC P-384 CA)
#
#SUBJ=ICAM_Test_Card_PIV_ECC_Issued_P-384_SM_Certificate_Signer_3
#sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_P-384_Signing_CA_gold_gen3 -t piv-content-signer-gen3 -e secp384r1 -c secp384r1 || exit $?
#DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
#cp -p data/$SUBJ.p12 "$DEST"
#cp -p data/pem/$SUBJ.crt "$DEST"
#

## Card 25
T="Missing_DO"
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 25 -t piv-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 25 -t piv-card-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 25 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_Auth_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 25 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/25_Disco_Object_not_present"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 26
T="App_PIN_Only"
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 26 -t piv-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 26 -t piv-card-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 26 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 26 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/26_Disco_Object_Present,_App_PIN_only"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1
#
## Card 27
T="App_PIN_Prim"
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 27 -t piv-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 27 -t piv-card-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 27 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 27 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/27_Disco_Object_present,_App_PIN_Primary"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 28
T="Global_PIN_Prim"
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 28 -t piv-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 28 -t piv-card-auth || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 28 -t piv-dig-sig || exit $?
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_$T -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 28 -t piv-key-mgmt || exit $?
DEST="../cards/ICAM_Card_Objects/28_Disco_Object_present,_Global_PIN_Primary"
cp -p data/ICAM_*_$T.p12 "$DEST"
cp -p data/pem/ICAM_*_$T.crt "$DEST"
renameIn "$DEST" 1 1

## Card 37
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-auth
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-card-auth -e prime256v1
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Hist1_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist1
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Hist2_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist2
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Hist3_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist3
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Hist4_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist4
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Hist5_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist5
DEST="../cards/ICAM_Card_Objects/37_Golden_FIPS_201-2_PIV_PPS_F=512_D=64"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_PPS.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_PPS.crt "$DEST"
renameIn "$DEST" 1 1

## Card 38
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_Bad_SO_Hash -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 38 -t piv-auth
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_Bad_SO_Hash -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 38 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_Bad_SO_Hash -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 38 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_Bad_SO_Hash -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 38 -t piv-card-auth
DEST="../cards/ICAM_Card_Objects/38_Bad_Hash_in_Sec_Object"
cp -p data/ICAM_Test_Card_PIV*SP_800-73-4_Bad_SO_Hash.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV*SP_800-73-4_Bad_SO_Hash.crt "$DEST"
renameIn "$DEST" 1 1

## Card 39
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Auth_Fed_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-auth
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Dig_Sig_Fed_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-dig-sig
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Key_Mgmt_Fed_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-key-mgmt
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Card_Auth_Fed_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-card-auth
DEST="../cards/ICAM_Card_Objects/39_Golden_FIPS_201-2_Fed_PIV-I"
cp -p data/ICAM_Test_Card_PIV-I*Fed_SP_800-73-4.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV-I*Fed_SP_800-73-4.crt "$DEST"
renameIn "$DEST" 1 1

## Card 41
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_Re-key -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 41 -t piv-auth
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_Re-key -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 41 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_Re-key -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 41 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_Re-key -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 41 -t piv-card-auth
DEST="../cards/ICAM_Card_Objects/41_Re-keyed_Card"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_Re-key.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_Re-key.crt "$DEST"
renameIn "$DEST" 1 1

## Card 42
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_OCSP_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 42 -t piv-auth
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_OCSP_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 42 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_OCSP_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 42 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_OCSP_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 42 -t piv-card-auth
DEST="../cards/ICAM_Card_Objects/42_OCSP_Expired"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_OCSP_Expired.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_OCSP_Expired.crt "$DEST"
renameIn "$DEST" 1 1

## Card 43
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_OCSP_Revoked_NOCHECK -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 43 -t piv-auth
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_OCSP_Revoked_NOCHECK -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 43 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_OCSP_Revoked_NOCHECK -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 43 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_OCSP_Revoked_NOCHECK -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 43 -t piv-card-auth
DEST="../cards/ICAM_Card_Objects/43_OCSP_revoked_w_nocheck"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_OCSP_Revoked_NOCHECK.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_OCSP_Revoked_NOCHECK.crt "$DEST"
renameIn "$DEST" 1 1

## Card 44
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_OCSP_Revoked_WO_NOCHECK -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 44 -t piv-auth
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_OCSP_Revoked_WO_NOCHECK -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 44 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_OCSP_Revoked_WO_NOCHECK -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 44 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_OCSP_Revoked_WO_NOCHECK -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 44 -t piv-card-auth
DEST="../cards/ICAM_Card_Objects/44_OCSP_revoked_wo_nocheck"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_OCSP_Revoked_WO_NOCHECK.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_OCSP_Revoked_WO_NOCHECK.crt "$DEST"
renameIn "$DEST" 1 1

## Card 45
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_OCSP_Invalid_Signature -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 45 -t piv-auth
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_OCSP_Invalid_Signature -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 45 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_OCSP_Invalid_Signature -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 45 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_OCSP_Invalid_Signature -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 45 -t piv-card-auth
DEST="../cards/ICAM_Card_Objects/45_OCSP_Invalid_Signature"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_OCSP_Invalid_Signature.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_OCSP_Invalid_Signature.crt "$DEST"
renameIn "$DEST" 1 1

## Card 46
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 46 -t piv-auth
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 46 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 46 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 46 -t piv-card-auth
DEST="../cards/ICAM_Card_Objects/46_Golden_FIPS_201-2_PIV"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4.crt "$DEST"
renameIn "$DEST" 1 1

## Card 47
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_SAN_Order -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 47 -t piv-auth
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_SAN_Order -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 47 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_SAN_Order -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 47 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_SAN_Order -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 47 -t piv-card-auth
DEST="../cards/ICAM_Card_Objects/47_Golden_FIPS_201-2_PIV_SAN_Order"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_SAN_Order.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_SAN_Order.crt "$DEST"
renameIn "$DEST" 1 1

## Card 49
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_FI_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 49 -t piv-auth
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_FI_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 49 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_FI_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 49 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_FI_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 49 -t piv-card-auth
DEST="../cards/ICAM_Card_Objects/49_FIPS_201-2_Facial_Image_CBEFF_Expired"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_FI_Expired.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_FI_Expired.crt "$DEST"
renameIn "$DEST" 1 1

## Card 50
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_FI_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 50 -t piv-auth
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_FI_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 50 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_FI_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 50 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_FI_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 50 -t piv-card-auth
DEST="../cards/ICAM_Card_Objects/50_FIPS_201-2_Facial_Image_CBEFF_Expires_before_CHUID"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_FI_will_Expire.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_FI_will_Expire.crt "$DEST"
renameIn "$DEST" 1 1

## Card 51
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_FP_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 51 -t piv-auth
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_FP_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 51 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_FP_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 51 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_FP_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 51 -t piv-card-auth
DEST="../cards/ICAM_Card_Objects/51_FIPS_201-2_Fingerprint_CBEFF_Expired"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_FP_Expired.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_FP_Expired.crt "$DEST"
renameIn "$DEST" 1 1

## Card 52
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_FP_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 52 -t piv-auth
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_FP_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 52 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_FP_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 52 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_FP_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 52 -t piv-card-auth
DEST="../cards/ICAM_Card_Objects/52_FIPS_201-2_Fingerprint_CBEFF_Expires_before_CHUID"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_FP_will_Expire.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_FP_will_Expire.crt "$DEST"
renameIn "$DEST" 1 1

## Card 53
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_Large_Cert -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 53 -t piv-auth
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_Large_Cert -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 53 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_Large_Cert -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 53 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_Large_Cert -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 53 -t piv-card-auth
DEST="../cards/ICAM_Card_Objects/53_FIPS_201-2_Large_Card_Auth_Cert"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4_Large_Cert.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4_Large_Cert.crt "$DEST"
renameIn "$DEST" 1 1

## Card 54
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Auth_NFI_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-auth
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Dig_Sig_NFI_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-dig-sig
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Key_Mgmt_NFI_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-key-mgmt
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV-I_Card_Auth_NFI_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-card-auth
DEST="../cards/ICAM_Card_Objects/54_Golden_FIPS_201-2_NFI_PIV-I"
cp -p data/ICAM_Test_Card_PIV-I_*NFI_SP_800-73-4.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV-I*NFI_SP_800-73-4.crt "$DEST"
renameIn "$DEST" 1 1

## Card 55
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_Missing_SO -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 55 -t piv-auth
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_Missing_SO-i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 55 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_Missing_SO -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 55 -t piv-key-mgmt
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_Missing_SO -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 55 -t piv-card-auth
DEST="../cards/ICAM_Card_Objects/55_FIPS_201-2_Missing_Security_Object"
cp -p data/ICAM_Test_Card_PIV*SP_800-73-4_Missing_SO.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV*SP_800-73-4_Missing_SO.crt "$DEST"

