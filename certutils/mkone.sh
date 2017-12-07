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

## Card 55
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_SP_800-73-4_Missing_SO -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 55 -t piv-auth
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_SP_800-73-4_Missing_SO -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 55 -t piv-dig-sig
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_SP_800-73-4_Missing_SO -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 55 -t piv-key-mgmt
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_SP_800-73-4_Missing_SO -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3 -n 55 -t piv-card-auth
#DEST="../cards/ICAM_Card_Objects/55_FIPS_201-2_Missing_Security_Object"
#cp -p data/ICAM_Test_Card_PIV*SP_800-73-4_Missing_SO.p12 "$DEST"
#cp -p data/pem/ICAM_Test_Card_PIV*SP_800-73-4_Missing_SO.crt "$DEST"
#renameIn "$DEST" 1 1

## Card 25
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Auth_Disc_Object_Not_Present -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 25 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Dig_Sig_Disc_Object_Not_Present -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 25 -t piv-dig-sig
sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Key_Mgmt_Disc_Object_Not_Present -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 25 -t piv-dig-sig
#sh mkcert.sh -w -b -s ICAM_Test_Card_PIV_Card_Auth_Object_Not_Present -i ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2 -n 25 -t piv-dig-sig
DEST="../cards/ICAM_Card_Objects/25_Disc_Object_not_present"
cp -p data/ICAM_Test_Card_PIV_*Disc_Object_Not_Present.p12 "$DEST"
cp -p data/ICAM_Test_Card_PIV_*Disc_Object_Not_Present.crt "$DEST"
renameIn "$DEST" 1 1
