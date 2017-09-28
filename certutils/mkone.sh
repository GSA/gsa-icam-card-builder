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

PIV_AUTH_CERT_NAME="3 - ICAM_PIV_Auth_SP_800-73-4.cer"
DIG_SIG_CERT_NAME="4 - ICAM_PIV_Dig_Sig_SP_800-73-4.cer"
KEY_MGMT_CERT_NAME="5 - ICAM_PIV_Key_Mgmt_SP_800-73-4.cer"
CARD_AUTH_CERT_NAME="6 - ICAM_PIV_Card_Auth_SP_800-73-4.cer"

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
		
		F=$(ls ICAM*Dig_Sig*.key.der)
		mv $F "4 - $F"
		cp -p "4 - $F" "$DIG_SIG_KEY_NAME"
		F=$(ls ICAM*Key_Mgmt*.key.der)
		mv $F "5 - $F"
		cp -p "5 - $F" "$KEY_MGMT_KEY_NAME"
		F=$(ls ICAM*Card_Auth*.key.der)
		mv $F "6 - $F"
		cp -p "6 - $F" "$CARD_AUTH_KEY_NAME"
		F=$(ls ICAM*PIV*_Auth*.key.der)
		mv $F "3 - $F"
		cp -p "3 - $F" "$PIV_AUTH_KEY_NAME"
		
		F=$(ls ICAM*Dig_Sig*.cer)
		mv $F "4 - $F"
		cp -p "4 - $F" "$DIG_SIG_CERT_NAME"
		F=$(ls ICAM*Key_Mgmt*.cer)
		mv $F "5 - $F"
		cp -p "5 - $F" "$KEY_MGMT_CERT_NAME"
		F=$(ls ICAM*Card_Auth*.cer)
		mv $F "6 - $F"
		cp -p "6 - $F" "$CARD_AUTH_CERT_NAME"
		F=$(ls ICAM*PIV*_Auth*.cer)
		mv $F "3 - $F"
		cp -p "3 - $F" "$PIV_AUTH_CERT_NAME"
	popd
}

set -x
#
sh mkcert.sh -w -b -s ICAM_NFI_PIV-I_Auth_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-auth
sh mkcert.sh -w -b -s ICAM_NFI_PIV-I_Dig_Sig_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-dig-sig
sh mkcert.sh -w -b -s ICAM_NFI_PIV-I_Key_Mgmt_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-key-mgmt
sh mkcert.sh -w -b -s ICAM_NFI_PIV-I_Card_Auth_SP_800-73-4 -i ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3 -n 54 -t pivi-card-auth
DEST="../cards/ICAM Card Objects/54 - Golden FIPS 201-2 NFI PIV-I"
cp data/ICAM_NFI_PIV-I*SP_800-73-4.p12 "$DEST"
cp data/der/ICAM_NFI_PIV-I*SP_800-73-4.key.der "$DEST"
cp data/der/ICAM_NFI_PIV-I*SP_800-73-4.cer "$DEST"
renameIn "$DEST"
