#!/bin/sh
#
# Just uncomment everything between ## Card to make a single card.
#
. ./rename.sh

## Content signer using RSA 2048 (RSA 2048 CA)

SUBJ=ICAM_Test_Card_PIV_Content_Signer 
sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -t piv-content-signer-gen3 -r 2048 --cakey rsa2048 || exit $?
DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
cp -p data/$SUBJ.p12 "$DEST"
cp -p data/pem/$SUBJ.crt "$DEST"

## Secure Messaging Key Establishment using ECC P-256 with intermediate CVC (RSA 2048 CA)

SUBJ=ICAM_Test_Card_PIV_RSA_Issued_Intermediate_CVC_Signer
sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -t piv-content-signer-gen3 -r 2048 -c rsa2048 || exit $?
DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
cp -p data/$SUBJ.p12 "$DEST"
cp -p data/pem/$SUBJ.crt "$DEST"

## Secure Messaging Key Establishment using ECC P-256 (ECC P-384 CA)

SUBJ=ICAM_Test_Card_PIV_ECC_issued_P-256_SM_Certificate_Signer_2
sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_P-384_Signing_CA_gold_gen3 -t piv-content-signer-gen3 -e prime256v1 -c secp384r1 || exit $?
DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
cp -p data/$SUBJ.p12 "$DEST"
cp -p data/pem/$SUBJ.crt "$DEST"

## Secure Messaging Key Establishment using ECC P-384 (ECC P-384 CA)

SUBJ=ICAM_Test_Card_PIV_ECC_issued_P-384_SM_Certificate_Signer_3
sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV_P-384_Signing_CA_gold_gen3 -t piv-content-signer-gen3 -e secp384r1 -c secp384r1 || exit $?
DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
cp -p data/$SUBJ.p12 "$DEST"
cp -p data/pem/$SUBJ.crt "$DEST"

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
cp -p data/ICAM_Test_Card_PIV_Card*SP_800-73-4_PPS.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_Card*SP_800-73-4_PPS.crt "$DEST"
renameIn "$DEST" 1 1
