#!/bin/sh
#
# Just uncomment everything between ## Card to make a single card.
#
. ./rename.sh

## PIV-I Content signer using RSA 2048 (RSA 2048 CA)

#SUBJ=ICAM_Test_Card_PIV-I_Content_Signer_-_gold_gen3 
#sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -t pivi-content-signer-gen3 -r 2048 --cakey rsa2048 || exit $?
#DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
#cp -p data/$SUBJ.p12 "$DEST"
#cp -p data/pem/$SUBJ.crt "$DEST"

## Card 46
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 46 -t piv-auth
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 46 -t piv-dig-sig
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 46 -t piv-key-mgmt
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4 -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 46 -t piv-card-auth
DEST="../cards/ICAM_Card_Objects/46_Golden_FIPS_201-2_PIV"
cp -p data/ICAM_Test_Card_PIV_*SP_800-73-4.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_*SP_800-73-4.crt "$DEST"
renameIn "$DEST" 1 0
