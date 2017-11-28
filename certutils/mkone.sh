#!/bin/sh
#
# Just uncomment everything between ## Card to make a single card.
#
. ./rename.sh

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
cp -p data/ICAM_Test_Card_PIV_Card*SP_800-73-4_PPS.p12 "$DEST"
cp -p data/pem/ICAM_Test_Card_PIV_Card*SP_800-73-4_PPS.crt "$DEST"
renameIn "$DEST" 1 1
