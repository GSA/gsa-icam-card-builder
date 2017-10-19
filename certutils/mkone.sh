#!/bin/sh
#
# This makes the certs for all of the cards in the FIPS 201-2 card set.
# Note that if using the "CertiPath Load Tool" for certain types of high speed
# cards, all certs must use the names that Card 46 uses.  In fact, all data
# objects must be named the same.  To use the tool for cards other than Card 46,
# we need to rename the certs to conform with Card 46. 
#
# These names are hard-coded in the CertiPath populator tool.

PIV_AUTH_P12_NAME="3 - ICAM_PIV_Auth_SP_800-73-4.p12"
DIG_SIG_P12_NAME="4 - ICAM_PIV_Dig_Sig_SP_800-73-4.p12"
KEY_MGMT_P12_NAME="5 - ICAM_PIV_Key_Mgmt_SP_800-73-4.p12"
CARD_AUTH_P12_NAME="6 - ICAM_PIV_Card_Auth_SP_800-73-4.p12"

PIV_AUTH_KEY_NAME="3 - ICAM_PIV_Auth_SP_800-73-4.key.der"
DIG_SIG_KEY_NAME="4 - ICAM_PIV_Dig_Sig_SP_800-73-4.key.der"
KEY_MGMT_KEY_NAME="5 - ICAM_PIV_Key_Mgmt_SP_800-73-4.key.der"
CARD_AUTH_KEY_NAME="6 - ICAM_PIV_Card_Auth_SP_800-73-4.key.der"

PIV_AUTH_CERT_NAME="3 - ICAM_PIV_Auth_SP_800-73-4.crt"
DIG_SIG_CERT_NAME="4 - ICAM_PIV_Dig_Sig_SP_800-73-4.crt"
KEY_MGMT_CERT_NAME="5 - ICAM_PIV_Key_Mgmt_SP_800-73-4.crt"
CARD_AUTH_CERT_NAME="6 - ICAM_PIV_Card_Auth_SP_800-73-4.crt"

renameIn() {
	pushd "$1" || exit 10
		F=$(ls ICAM*Dig_Sig*.p12)
		mv $F "4 - $F"
		cp -p "4 - $F" "$DIG_SIG_P12_NAME"
		F=$(ls ICAM*Key_Mgmt*.p12)
		mv $F "5 - $F"
		cp -p "5 - $F" "$KEY_MGMT_P12_NAME"
		F=$(ls ICAM*Card_Auth*.p12)
		mv $F "6 - $F"
		cp -p "6 - $F" "$CARD_AUTH_P12_NAME"
		F=$(ls ICAM*PIV*_Auth*.p12)
		mv $F "3 - $F"
		cp -p "3 - $F" "$PIV_AUTH_P12_NAME"
		
		F=$(ls ICAM*Dig_Sig*.crt)
		mv $F "4 - $F"
		cp -p "4 - $F" "$DIG_SIG_CERT_NAME"
		F=$(ls ICAM*Key_Mgmt*.crt)
		mv $F "5 - $F"
		cp -p "5 - $F" "$KEY_MGMT_CERT_NAME"
		F=$(ls ICAM*Card_Auth*.crt)
		mv $F "6 - $F"
		cp -p "6 - $F" "$CARD_AUTH_CERT_NAME"
		F=$(ls ICAM*PIV*_Auth*.crt)
		mv $F "3 - $F"
		cp -p "3 - $F" "$PIV_AUTH_CERT_NAME"
	popd
}

set -x
# Card 54
sh mkcert.sh -w -b -s ICAM_NFI_PIV-I_Auth_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-auth
sh mkcert.sh -w -b -s ICAM_NFI_PIV-I_Dig_Sig_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-dig-sig
sh mkcert.sh -w -b -s ICAM_NFI_PIV-I_Key_Mgmt_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-key-mgmt
sh mkcert.sh -w -b -s ICAM_NFI_PIV-I_Card_Auth_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-card-auth
DEST="../cards/ICAM_Card_Objects/54_Golden_FIPS_201-2_NFI_PIV-I"
cp data/ICAM_NFI_PIV-I*SP_800-73-4.p12 "$DEST"
cp data/pem/ICAM_NFI_PIV-I*SP_800-73-4.crt "$DEST"
renameIn "$DEST"
