#!/bin/sh
#
# Just uncomment everything between ## Card to make a single card.
#
. ./rename.sh

## Card 37
#sh mkcert.sh -w -b -s ICAM_PIV_Auth_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-auth
#sh mkcert.sh -w -b -s ICAM_PIV_Dig_Sig_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-dig-sig
#sh mkcert.sh -w -b -s ICAM_PIV_Key_Mgmt_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-mgmt
#sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-card-auth
#sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist1
#sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist2
#sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist3
#sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist4
##sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_PPS -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 37 -t piv-key-hist5
#DEST="../cards/ICAM_Card_Objects/37_Golden_FIPS_201-2_PIV_PPS_F=512_D=64"
#cp data/ICAM_PIV_*SP_800-73-4_PPS.p12 "$DEST"
#cp data/pem/ICAM_PIV_*SP_800-73-4_PPS.crt "$DEST"
#renameIn "$DEST"
## Card 41
#sh mkcert.sh -w -b -s ICAM_PIV_Auth_SP_800-73-4_Re-key -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 41 -t piv-auth
#sh mkcert.sh -w -b -s ICAM_PIV_Dig_Sig_SP_800-73-4_Re-key -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 41 -t piv-dig-sig
#sh mkcert.sh -w -b -s ICAM_PIV_Key_Mgmt_SP_800-73-4_Re-key -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 41 -t piv-key-mgmt
#sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_Re-key -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 41 -t piv-card-auth
#DEST="../cards/ICAM_Card_Objects/41_Re-keyed_Card"
#cp data/ICAM_PIV_*SP_800-73-4_Re-key.p12 "$DEST"
#cp data/pem/ICAM_PIV_*SP_800-73-4_Re-key.crt "$DEST"
#renameIn "$DEST"
## Card 39
#sh mkcert.sh -w -b -s ICAM_Fed_PIV-I_Auth_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-auth
#sh mkcert.sh -w -b -s ICAM_Fed_PIV-I_Dig_Sig_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-dig-sig
#sh mkcert.sh -w -b -s ICAM_Fed_PIV-I_Key_Mgmt_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-key-mgmt
#sh mkcert.sh -w -b -s ICAM_Fed_PIV-I_Card_Auth_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 39 -t pivi-card-auth
#DEST="../cards/ICAM_Card_Objects/39_Golden_FIPS_201-2_Fed_PIV-I"
#cp data/ICAM_Fed_PIV-I*SP_800-73-4.p12 "$DEST"
#cp data/pem/ICAM_Fed_PIV-I*SP_800-73-4.crt "$DEST"
#renameIn "$DEST"
## Card 46
#sh mkcert.sh -w -b -s ICAM_PIV_Auth_SP_800-73-4 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 46 -t piv-auth
#sh mkcert.sh -w -b -s ICAM_PIV_Dig_Sig_SP_800-73-4 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 46 -t piv-dig-sig
#sh mkcert.sh -w -b -s ICAM_PIV_Key_Mgmt_SP_800-73-4 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 46 -t piv-key-mgmt
#sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 46 -t piv-card-auth
#DEST="../cards/ICAM_Card_Objects/46_Golden_FIPS_201-2_PIV"
#cp data/ICAM_PIV_*SP_800-73-4.p12 "$DEST"
#cp data/pem/ICAM_PIV_*SP_800-73-4.crt "$DEST"
#renameIn "$DEST" 0
## Card 47
#sh mkcert.sh -w -b -s ICAM_PIV_Auth_SP_800-73-4_SAN_Order -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 47 -t piv-auth
#sh mkcert.sh -w -b -s ICAM_PIV_Dig_Sig_SP_800-73-4_SAN_Order -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 47 -t piv-dig-sig
#sh mkcert.sh -w -b -s ICAM_PIV_Key_Mgmt_SP_800-73-4_SAN_Order -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 47 -t piv-key-mgmt
#sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_SAN_Order -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 47 -t piv-card-auth
#DEST="../cards/ICAM_Card_Objects/47_Golden_FIPS_201-2_PIV_SAN_Order"
#cp data/ICAM_PIV_*SP_800-73-4_SAN_Order.p12 "$DEST"
#cp data/pem/ICAM_PIV_*SP_800-73-4_SAN_Order.crt "$DEST"
#renameIn "$DEST" 1
## Card 49
#sh mkcert.sh -w -b -s ICAM_PIV_Auth_SP_800-73-4_FI_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 49 -t piv-auth
#sh mkcert.sh -w -b -s ICAM_PIV_Dig_Sig_SP_800-73-4_FI_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 49 -t piv-dig-sig
#sh mkcert.sh -w -b -s ICAM_PIV_Key_Mgmt_SP_800-73-4_FI_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 49 -t piv-key-mgmt
#sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_FI_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 49 -t piv-card-auth
#DEST="../cards/ICAM_Card_Objects/49_FIPS_201-2_Facial_Image_CBEFF_Expired"
#cp data/ICAM_PIV_*SP_800-73-4_FI_Expired.p12 "$DEST"
#cp data/pem/ICAM_PIV_*SP_800-73-4_FI_Expired.crt "$DEST"
#renameIn "$DEST"
## Card 50
#sh mkcert.sh -w -b -s ICAM_PIV_Auth_SP_800-73-4_FI_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 50 -t piv-auth
#sh mkcert.sh -w -b -s ICAM_PIV_Dig_Sig_SP_800-73-4_FI_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 50 -t piv-dig-sig
#sh mkcert.sh -w -b -s ICAM_PIV_Key_Mgmt_SP_800-73-4_FI_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 50 -t piv-key-mgmt
#sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_FI_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 50 -t piv-card-auth
#DEST="../cards/ICAM_Card_Objects/50_FIPS_201-2_Facial_Image_CBEFF_Expires_before_CHUID"
#cp data/ICAM_PIV_*SP_800-73-4_FI_will_Expire.p12 "$DEST"
#cp data/pem/ICAM_PIV_*SP_800-73-4_FI_will_Expire.crt "$DEST"
#renameIn "$DEST"
## Card 51
#sh mkcert.sh -w -b -s ICAM_PIV_Auth_SP_800-73-4_FP_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 51 -t piv-auth
#sh mkcert.sh -w -b -s ICAM_PIV_Dig_Sig_SP_800-73-4_FP_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 51 -t piv-dig-sig
#sh mkcert.sh -w -b -s ICAM_PIV_Key_Mgmt_SP_800-73-4_FP_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 51 -t piv-key-mgmt
#sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_FP_Expired -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 51 -t piv-card-auth
#DEST="../cards/ICAM_Card_Objects/51_FIPS_201-2_Fingerprint_CBEFF_Expired"
#cp data/ICAM_PIV_*SP_800-73-4_FP_Expired.p12 "$DEST"
#cp data/pem/ICAM_PIV_*SP_800-73-4_FP_Expired.crt "$DEST"
#renameIn "$DEST"
## Card 52
#sh mkcert.sh -w -b -s ICAM_PIV_Auth_SP_800-73-4_FP_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 52 -t piv-auth
#sh mkcert.sh -w -b -s ICAM_PIV_Dig_Sig_SP_800-73-4_FP_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 52 -t piv-dig-sig
#sh mkcert.sh -w -b -s ICAM_PIV_Key_Mgmt_SP_800-73-4_FP_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 52 -t piv-key-mgmt
#sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_FP_will_Expire -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 52 -t piv-card-auth
#DEST="../cards/ICAM_Card_Objects/52_FIPS_201-2_Fingerprint_CBEFF_Expires_before_CHUID"
#cp data/ICAM_PIV_*SP_800-73-4_FP_will_Expire.p12 "$DEST"
#cp data/pem/ICAM_PIV_*SP_800-73-4_FP_will_Expire.crt "$DEST"
#renameIn "$DEST"
## Card 53
#sh mkcert.sh -w -b -s ICAM_PIV_Auth_SP_800-73-4_Large_Cert -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 53 -t piv-auth
#sh mkcert.sh -w -b -s ICAM_PIV_Dig_Sig_SP_800-73-4_Large_Cert -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 53 -t piv-dig-sig
#sh mkcert.sh -w -b -s ICAM_PIV_Key_Mgmt_SP_800-73-4_Large_Cert -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 53 -t piv-key-mgmt
#sh mkcert.sh -w -b -s ICAM_PIV_Card_Auth_SP_800-73-4_Large_Cert -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 53 -t piv-card-auth
#DEST="../cards/ICAM_Card_Objects/53_FIPS_201-2_Large_Card_Auth_Cert"
#cp data/ICAM_PIV_*SP_800-73-4_Large_Cert.p12 "$DEST"
#cp data/pem/ICAM_PIV_*SP_800-73-4_Large_Cert.crt "$DEST"
#renameIn "$DEST"
## Card 54
#sh mkcert.sh -w -b -s ICAM_NFI_PIV-I_Auth_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-auth
#sh mkcert.sh -w -b -s ICAM_NFI_PIV-I_Dig_Sig_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-dig-sig
#sh mkcert.sh -w -b -s ICAM_NFI_PIV-I_Key_Mgmt_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-key-mgmt
#sh mkcert.sh -w -b -s ICAM_NFI_PIV-I_Card_Auth_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-card-auth
#DEST="../cards/ICAM_Card_Objects/54_Golden_FIPS_201-2_NFI_PIV-I"
#cp data/ICAM_NFI_PIV-I*SP_800-73-4.p12 "$DEST"
#cp data/pem/ICAM_NFI_PIV-I*SP_800-73-4.crt "$DEST"
#renameIn "$DEST"

## Content signer
sh mkcert.sh -b -s ICAM_Test_Card_PIV_Content_Signer_-_gold_gen3 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -t piv-content-signer-gen3 || exit $?
DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
cp -p data/ICAM_Test_Card_PIV_Content_Signer_-_gold_gen3.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_Content_Signer_-_gold_gen3.crt "$DEST"

## CVC Certificate signer
sh mkcert.sh -b -s ICAM_Test_Card_PIV_Intermediate_CVC_Signer_-_gold_gen3 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -t piv-content-signer-gen3 || exit $?
DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
cp -p data/ICAM_Test_Card_PIV_Intermediate_CVC_Signer_-_gold_gen3.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_Intermediate_CVC_Signer_-_gold_gen3.crt "$DEST"

## RSA-signed P-256 SMCS
sh mkcert.sh -b -s ICAM_Test_Card_PIV_RSA_issued_P-256_Secure_Messaging_Certificate_Signer_1 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -t piv-content-signer-gen3 || exit $?
DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
cp -p data/ICAM_Test_Card_PIV_RSA_issued_P-256_Secure_Messaging_Certificate_Signer_1.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_RSA_issued_P-256_Secure_Messaging_Certificate_Signer_1.crt "$DEST"
