#!/bin/sh
#
# Just uncomment everything between ## Card to make a single card.
#
. ./rename.sh

## PIV-I Content signer using RSA 2048 (RSA 2048 CA)

SUBJ=ICAM_Test_Card_PIV-I_Content_Signer_-_gold_gen3 
sh mkcert.sh -b -s $SUBJ -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -t pivi-content-signer-gen3 -r 2048 --cakey rsa2048 || exit $?
DEST="../cards/ICAM_Card_Objects/ICAM_CA_and_Signer"
cp -p data/$SUBJ.p12 "$DEST"
cp -p data/pem/$SUBJ.crt "$DEST"
